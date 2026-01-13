# Component: native.getisord

Performs Getis-Ord Gi* spatial statistic analysis.

## Output Schema

The Getis-Ord component outputs exactly **3 columns**, regardless of input:

| Column | Type | Description |
|--------|------|-------------|
| `index` | STRING | The index value (H3, geohash, etc.) - **renamed from input column** |
| `gi` | FLOAT64 | The Gi* z-score statistic |
| `p_value` | FLOAT64 | The p-value for statistical significance |

## Gotcha: Column Renaming

**The input index column is renamed to `index`** in the output, regardless of its original name.

If your input has a column named `h3`, the output will have `index`:

```
Input:  h3, value, ...
Output: index, gi, p_value
```

Reference `index` (not the original column name) in downstream nodes.

## Example

If you need to join Getis-Ord results with H3 Boundary:

```json
// Getis-Ord outputs: index, gi, p_value
// H3 Boundary expects the H3 column - use "index" not "h3"
{
  "name": "h3",
  "type": "Column",
  "value": "index"
}
```
