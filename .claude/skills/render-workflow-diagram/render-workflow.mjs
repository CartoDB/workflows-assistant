#!/usr/bin/env node
/**
 * render-workflow.mjs
 *
 * Renders a CARTO Workflow JSON as a Unicode box-art DAG in the terminal.
 *
 * Usage:
 *   node render-workflow.mjs <workflow.json>
 *   cat workflow.json | node render-workflow.mjs
 *
 * Pipeline:
 *   1. Parse workflow JSON (nodes + edges)
 *   2. Convert to Graphviz DOT string
 *   3. Layout with @hpcc-js/wasm-graphviz (dot engine, "plain" format)
 *   4. Map positions to a character grid
 *   5. Print Unicode box-art to stdout
 */

import { readFileSync } from "node:fs";
import { Graphviz } from "@hpcc-js/wasm-graphviz";

// ── Constants ────────────────────────────────────────────────────────────────

const NATIVE_PREFIX = "native.";
const NODE_PADDING_X = 1; // horizontal padding inside box (each side)
const NODE_PADDING_Y = 0; // vertical padding inside box (top/bottom)
const MIN_NODE_WIDTH = 12;
const EDGE_GAP = 1; // rows/cols of space between node border and edge start

// Adaptive scaling: minimum chars per graphviz inch
const BASE_SCALE_X = 8;
const BASE_SCALE_Y = 2;

// Box-drawing characters
const BOX = {
  tl: "\u250C", // ┌
  tr: "\u2510", // ┐
  bl: "\u2514", // └
  br: "\u2518", // ┘
  h: "\u2500",  // ─
  v: "\u2502",  // │
};

// Corner characters for edge routing (named by directions: from → to)
const CORNER = {
  down_right: "\u250C", // ┌  coming down, turning right
  down_left: "\u2510",  // ┐  coming down, turning left
  up_right: "\u2514",   // └  coming up, turning right
  up_left: "\u2518",    // ┘  coming up, turning left
};

const ARROW = {
  down: "\u25BC",  // ▼
  right: "\u25B6", // ▶
  left: "\u25C0",  // ◀
  up: "\u25B2",    // ▲
};

// ── Read input ───────────────────────────────────────────────────────────────

function readInput() {
  const filePath = process.argv[2];
  if (filePath) {
    return readFileSync(filePath, "utf-8");
  }
  return readFileSync(0, "utf-8");
}

// ── Workflow → DOT ───────────────────────────────────────────────────────────

function shortName(node) {
  return (node.data?.name || node.id || "").replace(NATIVE_PREFIX, "");
}

function nodeLabel(node) {
  const name = shortName(node);
  const label = node.data?.label || "";
  if (!label || label === name || label === node.data?.name) {
    return name;
  }
  return `${label}\\n(${name})`;
}

function nodeLabelLines(node) {
  const name = shortName(node);
  const label = node.data?.label || "";
  if (!label || label === name || label === node.data?.name) {
    return [name];
  }
  return [label, `(${name})`];
}

function workflowToDot(workflow) {
  const lines = [
    "digraph workflow {",
    "  rankdir=TB;",
    "  node [shape=box];",
    "  ranksep=0.2;",
    "  nodesep=0.4;",
    "",
  ];

  const nodes = workflow.nodes || [];
  const edges = workflow.edges || [];

  // Filter out note nodes — they're annotations, not data flow
  const dataNodes = nodes.filter((n) => n.type !== "note");

  for (const node of dataNodes) {
    const label = nodeLabel(node);
    const escapedLabel = label.replace(/"/g, '\\"');
    lines.push(`  "${node.id}" [label="${escapedLabel}"];`);
  }

  lines.push("");

  for (const edge of edges) {
    lines.push(`  "${edge.source}" -> "${edge.target}";`);
  }

  lines.push("}");
  return lines.join("\n");
}

// ── Parse Graphviz "plain" format ────────────────────────────────────────────
//
// Each line:
//   graph scale width height
//   node name x y width height label style shape color fillcolor
//   edge tail head n x1 y1 ... xn yn [label xl yl] style color
//   stop

function parsePlainOutput(plain) {
  const lines = plain.trim().split("\n");
  const nodes = [];
  const edges = [];
  let graphWidth = 0;
  let graphHeight = 0;

  for (const line of lines) {
    const parts = line.split(/\s+/);
    const type = parts[0];

    if (type === "graph") {
      graphWidth = parseFloat(parts[2]);
      graphHeight = parseFloat(parts[3]);
    } else if (type === "node") {
      nodes.push({
        id: parts[1].replace(/^"|"$/g, ""),
        x: parseFloat(parts[2]),
        y: parseFloat(parts[3]),
        w: parseFloat(parts[4]),
        h: parseFloat(parts[5]),
        label: parts.slice(6, parts.length - 3).join(" ").replace(/^"|"$/g, ""),
      });
    } else if (type === "edge") {
      const tail = parts[1].replace(/^"|"$/g, "");
      const head = parts[2].replace(/^"|"$/g, "");
      const nPoints = parseInt(parts[3], 10);
      const points = [];
      for (let i = 0; i < nPoints; i++) {
        const baseIdx = 4 + i * 2;
        points.push({
          x: parseFloat(parts[baseIdx]),
          y: parseFloat(parts[baseIdx + 1]),
        });
      }
      edges.push({ tail, head, points });
    }
  }

  return { nodes, edges, graphWidth, graphHeight };
}

// ── Edge character merging ────────────────────────────────────────────────────
// When two edges cross or meet at the same cell, merge them into a junction.
// Each edge char implies which directions it connects (up/down/left/right).

const JUNCTION = {
  cross: "\u253C",   // ┼
  teeDown: "\u252C",  // ┬  (left + right + down)
  teeUp: "\u2534",    // ┴  (left + right + up)
  teeRight: "\u251C",  // ├  (up + down + right)
  teeLeft: "\u2524",   // ┤  (up + down + left)
};

// Direction flags
const UP = 1, DOWN = 2, LEFT = 4, RIGHT = 8;

const CHAR_DIRS = new Map([
  [BOX.v, UP | DOWN],
  [BOX.h, LEFT | RIGHT],
  [CORNER.down_right, DOWN | RIGHT], // ┌
  [CORNER.down_left, DOWN | LEFT],   // ┐
  [CORNER.up_right, UP | RIGHT],     // └
  [CORNER.up_left, UP | LEFT],       // ┘
  [JUNCTION.teeDown, LEFT | RIGHT | DOWN],
  [JUNCTION.teeUp, LEFT | RIGHT | UP],
  [JUNCTION.teeRight, UP | DOWN | RIGHT],
  [JUNCTION.teeLeft, UP | DOWN | LEFT],
  [JUNCTION.cross, UP | DOWN | LEFT | RIGHT],
]);

const DIRS_TO_CHAR = new Map([
  [UP | DOWN, BOX.v],
  [LEFT | RIGHT, BOX.h],
  [DOWN | RIGHT, CORNER.down_right],
  [DOWN | LEFT, CORNER.down_left],
  [UP | RIGHT, CORNER.up_right],
  [UP | LEFT, CORNER.up_left],
  [LEFT | RIGHT | DOWN, JUNCTION.teeDown],
  [LEFT | RIGHT | UP, JUNCTION.teeUp],
  [UP | DOWN | RIGHT, JUNCTION.teeRight],
  [UP | DOWN | LEFT, JUNCTION.teeLeft],
  [UP | DOWN | LEFT | RIGHT, JUNCTION.cross],
]);

function mergeEdgeChar(existing, incoming) {
  const eDirs = CHAR_DIRS.get(existing);
  const iDirs = CHAR_DIRS.get(incoming);
  if (eDirs === undefined || iDirs === undefined) return null;
  const merged = eDirs | iDirs;
  return DIRS_TO_CHAR.get(merged) || null;
}

// ── Character grid ───────────────────────────────────────────────────────────

class CharGrid {
  constructor(width, height) {
    this.width = width;
    this.height = height;
    this.grid = Array.from({ length: height }, () =>
      Array.from({ length: width }, () => " ")
    );
  }

  set(col, row, ch) {
    if (row >= 0 && row < this.height && col >= 0 && col < this.width) {
      this.grid[row][col] = ch;
    }
  }

  get(col, row) {
    if (row >= 0 && row < this.height && col >= 0 && col < this.width) {
      return this.grid[row][col];
    }
    return " ";
  }

  /** Write if cell is empty, or merge with existing edge character */
  setIfEmpty(col, row, ch) {
    const existing = this.get(col, row);
    if (existing === " ") {
      this.set(col, row, ch);
    } else {
      // Merge edge characters into junction characters
      const merged = mergeEdgeChar(existing, ch);
      if (merged) this.set(col, row, merged);
    }
  }

  writeString(col, row, str) {
    for (let i = 0; i < str.length; i++) {
      this.set(col + i, row, str[i]);
    }
  }

  toString() {
    // Trim trailing whitespace per line and trailing empty lines
    const lines = this.grid.map((row) => row.join("").trimEnd());
    // Remove leading and trailing empty lines
    let start = 0;
    while (start < lines.length && lines[start] === "") start++;
    let end = lines.length - 1;
    while (end > start && lines[end] === "") end--;
    return lines.slice(start, end + 1).join("\n");
  }
}

// ── Edge drawing ─────────────────────────────────────────────────────────────

function drawVerticalSegment(grid, col, fromRow, toRow) {
  const dir = toRow > fromRow ? 1 : -1;
  for (let r = fromRow; r !== toRow + dir; r += dir) {
    grid.setIfEmpty(col, r, BOX.v);
  }
}

function drawHorizontalSegment(grid, row, fromCol, toCol) {
  const dir = toCol > fromCol ? 1 : -1;
  for (let c = fromCol; c !== toCol + dir; c += dir) {
    grid.setIfEmpty(c, row, BOX.h);
  }
}

function drawEdge(grid, src, dst) {
  // Determine connection direction and attachment points
  let startCol, startRow, endCol, endRow;
  let vertical = false; // primary direction

  if (dst.top > src.bottom) {
    // dst is below src
    startCol = src.cx;
    startRow = src.bottom + EDGE_GAP;
    endCol = dst.cx;
    endRow = dst.top - EDGE_GAP;
    vertical = true;
  } else if (dst.bottom < src.top) {
    // dst is above src
    startCol = src.cx;
    startRow = src.top - EDGE_GAP;
    endCol = dst.cx;
    endRow = dst.bottom + EDGE_GAP;
    vertical = true;
  } else if (dst.left > src.right) {
    // dst is to the right
    startCol = src.right + EDGE_GAP;
    startRow = src.cy;
    endCol = dst.left - EDGE_GAP;
    endRow = dst.cy;
    vertical = false;
  } else {
    // dst is to the left
    startCol = src.left - EDGE_GAP;
    startRow = src.cy;
    endCol = dst.right + EDGE_GAP;
    endRow = dst.cy;
    vertical = false;
  }

  if (startCol === endCol) {
    // Straight vertical line
    drawVerticalSegment(grid, startCol, startRow, endRow);
  } else if (startRow === endRow) {
    // Straight horizontal line
    drawHorizontalSegment(grid, startRow, startCol, endCol);
  } else if (vertical) {
    // Primary direction is vertical — use Z-route: down, across, down
    const midRow = Math.round((startRow + endRow) / 2);
    const goingDown = endRow > startRow;
    const goingRight = endCol > startCol;

    // First vertical segment: start → one cell before midRow (corner handles midRow)
    const v1End = goingDown ? midRow - 1 : midRow + 1;
    if ((goingDown && v1End >= startRow) || (!goingDown && v1End <= startRow)) {
      drawVerticalSegment(grid, startCol, startRow, v1End);
    }

    // Horizontal segment at midRow (between corners, exclusive)
    const hStart = goingRight ? startCol + 1 : startCol - 1;
    const hEnd = goingRight ? endCol - 1 : endCol + 1;
    if ((goingRight && hEnd >= hStart) || (!goingRight && hEnd <= hStart)) {
      drawHorizontalSegment(grid, midRow, hStart, hEnd);
    }

    // Second vertical segment: one cell after midRow → end (corner handles midRow)
    const v2Start = goingDown ? midRow + 1 : midRow - 1;
    if ((goingDown && endRow >= v2Start) || (!goingDown && endRow <= v2Start)) {
      drawVerticalSegment(grid, endCol, v2Start, endRow);
    }

    // Corner at (startCol, midRow): vertical meets horizontal
    if (goingDown && goingRight) {
      grid.setIfEmpty(startCol, midRow, CORNER.up_right); // └
    } else if (goingDown && !goingRight) {
      grid.setIfEmpty(startCol, midRow, CORNER.up_left); // ┘
    } else if (!goingDown && goingRight) {
      grid.setIfEmpty(startCol, midRow, CORNER.down_right); // ┌
    } else {
      grid.setIfEmpty(startCol, midRow, CORNER.down_left); // ┐
    }

    // Corner at (endCol, midRow): horizontal meets vertical
    if (goingDown && goingRight) {
      grid.setIfEmpty(endCol, midRow, CORNER.down_left); // ┐
    } else if (goingDown && !goingRight) {
      grid.setIfEmpty(endCol, midRow, CORNER.down_right); // ┌
    } else if (!goingDown && goingRight) {
      grid.setIfEmpty(endCol, midRow, CORNER.up_left); // ┘
    } else {
      grid.setIfEmpty(endCol, midRow, CORNER.up_right); // └
    }
  } else {
    // Primary direction is horizontal — use Z-route: across, down, across
    const midCol = Math.round((startCol + endCol) / 2);
    const goingRight = endCol > startCol;
    const goingDown = endRow > startRow;

    // First horizontal segment: start → one cell before midCol
    const h1End = goingRight ? midCol - 1 : midCol + 1;
    if ((goingRight && h1End >= startCol) || (!goingRight && h1End <= startCol)) {
      drawHorizontalSegment(grid, startRow, startCol, h1End);
    }

    // Vertical segment between corners (exclusive)
    const vStart = goingDown ? startRow + 1 : startRow - 1;
    const vEnd = goingDown ? endRow - 1 : endRow + 1;
    if ((goingDown && vEnd >= vStart) || (!goingDown && vEnd <= vStart)) {
      drawVerticalSegment(grid, midCol, vStart, vEnd);
    }

    // Second horizontal segment: one cell after midCol → end
    const h2Start = goingRight ? midCol + 1 : midCol - 1;
    if ((goingRight && endCol >= h2Start) || (!goingRight && endCol <= h2Start)) {
      drawHorizontalSegment(grid, endRow, h2Start, endCol);
    }

    // Corner at (midCol, startRow)
    if (goingRight && goingDown) {
      grid.setIfEmpty(midCol, startRow, CORNER.down_left); // ┐
    } else if (goingRight && !goingDown) {
      grid.setIfEmpty(midCol, startRow, CORNER.up_left); // ┘
    } else if (!goingRight && goingDown) {
      grid.setIfEmpty(midCol, startRow, CORNER.down_right); // ┌
    } else {
      grid.setIfEmpty(midCol, startRow, CORNER.up_right); // └
    }

    // Corner at (midCol, endRow)
    if (goingRight && goingDown) {
      grid.setIfEmpty(midCol, endRow, CORNER.up_right); // └
    } else if (goingRight && !goingDown) {
      grid.setIfEmpty(midCol, endRow, CORNER.down_right); // ┌
    } else if (!goingRight && goingDown) {
      grid.setIfEmpty(midCol, endRow, CORNER.up_left); // ┘
    } else {
      grid.setIfEmpty(midCol, endRow, CORNER.down_left); // ┐
    }
  }

  // Arrowhead at destination
  if (vertical) {
    const arrowDir = endRow > startRow ? ARROW.down : ARROW.up;
    grid.set(endCol, endRow, arrowDir);
  } else {
    const arrowDir = endCol > startCol ? ARROW.right : ARROW.left;
    grid.set(endCol, endRow, arrowDir);
  }
}

// ── Render to grid ───────────────────────────────────────────────────────────

function renderToGrid(layout, workflow) {
  const workflowNodeMap = new Map();
  for (const n of workflow.nodes || []) {
    workflowNodeMap.set(n.id, n);
  }

  // Compute per-node character dimensions from labels
  const nodeCharInfo = new Map();
  for (const n of layout.nodes) {
    const wfNode = workflowNodeMap.get(n.id);
    const lines = wfNode ? nodeLabelLines(wfNode) : [n.label];
    const maxLineLen = Math.max(...lines.map((l) => l.length));
    const boxWidth = Math.max(maxLineLen + NODE_PADDING_X * 2 + 2, MIN_NODE_WIDTH);
    const boxHeight = lines.length + NODE_PADDING_Y * 2 + 2;
    nodeCharInfo.set(n.id, { lines, boxWidth, boxHeight });
  }

  // Adaptive scaling: ensure boxes don't overlap at this scale
  const scaleX = Math.max(
    BASE_SCALE_X,
    ...layout.nodes.map((n) => {
      const info = nodeCharInfo.get(n.id);
      return info ? (info.boxWidth + 2) / Math.max(n.w, 0.5) : BASE_SCALE_X;
    })
  );
  const scaleY = Math.max(
    BASE_SCALE_Y,
    ...layout.nodes.map((n) => {
      const info = nodeCharInfo.get(n.id);
      return info ? (info.boxHeight + 1) / Math.max(n.h, 0.5) : BASE_SCALE_Y;
    })
  );

  const gridWidth = Math.ceil(layout.graphWidth * scaleX) + 4;
  const gridHeight = Math.ceil(layout.graphHeight * scaleY) + 4;
  const grid = new CharGrid(gridWidth, gridHeight);

  // Coordinate conversion: graphviz uses bottom-left origin, we use top-left
  const toCol = (x) => Math.round(x * scaleX) + 1;
  const toRow = (y) => gridHeight - 1 - Math.round(y * scaleY);

  const nodeBounds = new Map();

  // ── Draw nodes ──
  for (const n of layout.nodes) {
    const { lines, boxWidth, boxHeight } = nodeCharInfo.get(n.id);

    const cx = toCol(n.x);
    const cy = toRow(n.y);
    const left = cx - Math.floor(boxWidth / 2);
    const top = cy - Math.floor(boxHeight / 2);

    nodeBounds.set(n.id, {
      left,
      top,
      right: left + boxWidth - 1,
      bottom: top + boxHeight - 1,
      cx,
      cy,
    });

    // Border
    grid.set(left, top, BOX.tl);
    grid.set(left + boxWidth - 1, top, BOX.tr);
    grid.set(left, top + boxHeight - 1, BOX.bl);
    grid.set(left + boxWidth - 1, top + boxHeight - 1, BOX.br);

    for (let c = left + 1; c < left + boxWidth - 1; c++) {
      grid.set(c, top, BOX.h);
      grid.set(c, top + boxHeight - 1, BOX.h);
    }
    for (let r = top + 1; r < top + boxHeight - 1; r++) {
      grid.set(left, r, BOX.v);
      grid.set(left + boxWidth - 1, r, BOX.v);
    }

    // Label text, centered
    for (let i = 0; i < lines.length; i++) {
      const textRow = top + 1 + NODE_PADDING_Y + i;
      const textCol = left + 1 + Math.floor((boxWidth - 2 - lines[i].length) / 2);
      grid.writeString(textCol, textRow, lines[i]);
    }
  }

  // ── Draw edges ──
  for (const edge of layout.edges) {
    const srcBounds = nodeBounds.get(edge.tail);
    const dstBounds = nodeBounds.get(edge.head);
    if (!srcBounds || !dstBounds) continue;
    drawEdge(grid, srcBounds, dstBounds);
  }

  return grid;
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  const input = readInput();
  let workflow;
  try {
    workflow = JSON.parse(input);
  } catch {
    console.error("Error: Invalid JSON input");
    process.exit(1);
  }

  const dot = workflowToDot(workflow);
  const graphviz = await Graphviz.load();
  const plain = graphviz.dot(dot, "plain");
  const layout = parsePlainOutput(plain);

  if (layout.nodes.length === 0) {
    console.log("(empty workflow — no data nodes)");
    return;
  }

  const grid = renderToGrid(layout, workflow);

  // Output: title + diagram
  const outputLines = [];

  if (workflow.title) {
    outputLines.push(`  ${workflow.title}`);
    outputLines.push(`  ${"─".repeat(workflow.title.length)}`);
    outputLines.push("");
  }

  outputLines.push(grid.toString());

  console.log(outputLines.join("\n"));
}

main().catch((err) => {
  console.error("Error:", err.message);
  process.exit(1);
});
