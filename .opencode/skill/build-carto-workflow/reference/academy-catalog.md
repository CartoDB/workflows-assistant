# CARTO Academy Content Catalog

Comprehensive index of all CARTO Academy content, organized by section.
Each entry includes relevance to existing or potential skills.

> Last crawled: 2026-03-30

---

## 1. Working with Geospatial Data

Foundational content on spatial data types, optimization, and spatial indexes.

### Geospatial Data: The Basics
- **URL**: https://academy.carto.com/working-with-geospatial-data/geospatial-data-the-basics
- **Covers**: Points, lines, polygons, spatial data types in cloud DWH
- **Skill relevance**: General foundation — useful context for all skills

### Optimizing Your Data for Spatial Analysis
- **URL**: https://academy.carto.com/working-with-geospatial-data/optimizing-your-data-for-spatial-analysis
- **Covers**: Provider-specific optimization (BQ clustering, Snowflake search optimization, Redshift sort keys, Databricks z-order, PostgreSQL indexing), data reduction strategies, spatial type selection
- **Key tips**:
  - BQ: cluster by geometry/spatial index column
  - Snowflake points/polygons: enable Search Optimization; spatial indexes: cluster by index column
  - Redshift: set SRID to EPSG:4326 for points/polygons; use spatial index as sort key
  - Databricks: use H3 column as z-order
  - PostgreSQL: index by geometry/spatial index; use SRID 3857
  - Prefer spatial indexes for best performance
  - Simplify complex polygons; avoid overlapping geometries
- **Skill relevance**: `build-carto-workflow` (saveastable optimization), all skills (data prep guidance)

### Introduction to Spatial Indexes
- **URL**: https://academy.carto.com/working-with-geospatial-data/introduction-to-spatial-indexes
- **Covers**: H3 vs Quadbin vs S2 comparison, resolution selection, advantages of each
- **Key content**:
  - H3: hexagonal, 16 resolutions, best for gradual spatial changes, movement, curves
  - Quadbin: square-based, 26 resolutions, best for perpendicular/gridded geographies
  - S2: spherical quadrilaterals, 31 resolutions, best near poles and across 180° longitude
  - Resolution choice: linked to spatial problem scale and source data granularity
  - "Go more detailed if in doubt — easier to aggregate up than add detail down"
- **Skill relevance**: `hotspot-analysis`, `spatial-enrichment`, `trade-area-analysis` (resolution guidance)

#### Sub-pages:

**Spatial Index Support in CARTO**
- **URL**: https://academy.carto.com/working-with-geospatial-data/introduction-to-spatial-indexes/spatial-index-support-in-carto
- **Skill relevance**: Reference for which providers support which indexes

**Create or Enrich an Index**
- **URL**: https://academy.carto.com/working-with-geospatial-data/introduction-to-spatial-indexes/create-or-enrich-an-index
- **Covers**: 4 tutorials — points→index, polygons→index (polyfill), lines→index (buffer first), enrich an index
- **Key tips**:
  - Points: H3 from GeoPoint → Group by (H3, count) to deduplicate
  - Polygons: H3 Polyfill; use Group by to remove duplicate cells along borders
  - Lines: Buffer first (even 1m), then H3 Polyfill with mode=Intersects for continuous grid
  - Enrich: target H3 grid (top input) + source geometry (bottom input); set variables + aggregation types
  - Enrich supports K-ring + decay function for neighborhood statistics
- **Skill relevance**: `spatial-enrichment` (directly), `hotspot-analysis` (grid creation)

**Work with Unique Spatial Index Properties**
- **URL**: https://academy.carto.com/working-with-geospatial-data/introduction-to-spatial-indexes/work-with-unique-spatial-index-properties
- **Covers**: Parent/child hierarchies, K-rings, converting indexes to geometry, enriching geometry with index
- **Key tips**:
  - H3 to Parent → Group by to change resolution (aggregate up)
  - K-rings: fast distance-based calculations without geometry
  - H3 Center (point) vs H3 Boundary (polygon) — points are lighter, better for distance; polygons for visualization
  - Enriching polygon with index: polyfill polygon at same resolution as source index → Join → Group by
- **Skill relevance**: `spatial-enrichment`, `trade-area-analysis` (K-ring trade areas)

**Scaling Common Geoprocessing Tasks with Spatial Indexes**
- **URL**: https://academy.carto.com/working-with-geospatial-data/introduction-to-spatial-indexes/scaling-common-geoprocessing-tasks-with-spatial-indexes
- **Covers**: Buffer, clip/intersect, difference, spatial join, aggregate within distance — all via spatial indexes
- **Key patterns**:
  - Buffer → K-ring approximation
  - Clip/intersect → convert both to index + inner Join
  - Difference → convert both + full outer Join + Where filter
  - Spatial join → Enrich H3/Quadbin Grid (up to 98% faster than geometry)
  - Aggregate within distance → K-ring + Group by
- **Skill relevance**: All skills — fundamental optimization patterns

**Using Spatial Indexes for Analysis**
- **URL**: https://academy.carto.com/working-with-geospatial-data/introduction-to-spatial-indexes/using-spatial-indexes-for-analysis
- **Covers**: Links to featured tutorials and use cases
- **Sub-tutorials linked**: Cell towers + population, traffic accident rates, OD patterns, GWR, hotspots, space-time hotspots, spatial interpolation
- **Skill relevance**: Index page — pointers to deeper content

### The Modern Geospatial Analysis Stack
- **URL**: https://academy.carto.com/working-with-geospatial-data/the-modern-geospatial-analysis-stack
- **Covers**: Cloud-native geospatial architecture concepts
- **Skill relevance**: Background context

---

## 2. Building Interactive Maps

Builder-focused tutorials. Less directly relevant to workflow building but useful for understanding visualization and analysis patterns.

### Data Visualization
- **URL**: https://academy.carto.com/building-interactive-maps/data-visualization
- **Skill relevance**: Low for workflow skills (Builder-specific)

### Data Analysis
- **URL**: https://academy.carto.com/building-interactive-maps/data-analysis
- **Skill relevance**: Medium — analysis patterns translate to workflows

### Solving Geospatial Use Cases
- **URL**: https://academy.carto.com/building-interactive-maps/solving-geospatial-use-cases
- **Skill relevance**: Medium — real-world use case patterns

### Sharing and Collaborating
- **URL**: https://academy.carto.com/building-interactive-maps/sharing-and-collaborating
- **Skill relevance**: Low for workflow skills

---

## 3. Agentic GIS

### AI Agents
- **URL**: https://academy.carto.com/agentic-gis/ai-agents
- **Covers**: What AI agents are (instructions + tools + model), enabling in CARTO org, setting up in Builder, use case field, custom instructions, welcome messages, conversation starters
- **Skill relevance**: High — context for how our agent skills will be consumed

### CARTO MCP Server
- **URL**: https://academy.carto.com/agentic-gis/carto-mcp-server
- **Covers**: Exposing Workflows as MCP Tools, API token setup, connecting agents (e.g. Gemini CLI), sync vs async modes
- **Key tips**:
  - Write clear tool descriptions; define inputs precisely
  - Test workflows manually before exposing as tools
  - Async mode requires agent to poll for status — needs additional prompt engineering
- **Skill relevance**: High — our workflows could become MCP tools

### Step-by-step Tutorials (Agentic)
- **URL**: https://academy.carto.com/agentic-gis/step-by-step-tutorials
- **Skill relevance**: Medium — patterns for agentic use

---

## 4. Creating Workflows

### Introduction to CARTO Workflows
- **URL**: https://academy.carto.com/creating-workflows/introduction-to-carto-workflows
- **Skill relevance**: `build-carto-workflow` (foundational)

### Step-by-step Tutorials (22 tutorials)

#### Insurance (5)
| Tutorial | URL | Techniques | Skill relevance |
|----------|-----|------------|-----------------|
| Crime data for insurance risk | .../using-crime-data-and-spatial-analysis-to-assess-home-insurance-risk | H3 polyfill, enrichment, composite scoring | `composite-scoring`, `spatial-enrichment` |
| Stores in weather risk areas | .../finding-stores-in-areas-with-weather-risks | Spatial filter, buffer, intersection | `spatial-enrichment` |
| Composite score for fire risk | .../creating-a-composite-score-for-fire-risk | Composite scoring (supervised/unsupervised) | `composite-scoring` |
| Real-time flood claims | .../real-time-flood-claims-analysis | Real-time spatial analysis, buffer, intersection | `spatial-enrichment` |
| Space-time anomaly detection | .../space-time-anomaly-detection-for-real-time-portfolio-management | Spacetime Getis-Ord, anomaly detection | `hotspot-analysis` |

#### Telco (4)
| Tutorial | URL | Techniques | Skill relevance |
|----------|-----|------------|-----------------|
| LTE population coverage | .../estimate-the-population-covered-by-lte-cells | Buffer, H3 polyfill, spatial features enrichment, join | `spatial-enrichment` |
| Customer churn classification | .../train-a-classification-model-to-estimate-customer-churn | BigQuery ML classification | `ml-pipelines` |
| Cell antenna deficit | .../identify-buildings-in-areas-with-a-deficit-of-cell-network-antennas | H3 grid, coverage gap analysis | `spatial-enrichment` |
| Territory balancing | .../optimizing-workload-distribution-through-territory-balancing | Territory planning extension | New skill potential |
| Location allocation | .../transforming-telco-network-management-decisions-with-location-allocation | Location allocation (maximize coverage / minimize cost) | New skill potential |

#### OOH / Retail (4)
| Tutorial | URL | Techniques | Skill relevance |
|----------|-----|------------|-----------------|
| Best billboards multi-channel | .../identify-the-best-billboards-and-stores-for-a-multi-channel-product-launch-campaign | Trade areas, enrichment, scoring | `trade-area-analysis`, `composite-scoring` |
| OOH advertising optimization | .../a-no-code-approach-to-optimizing-ooh-advertising-locations | Spatial indexes, mobility data, spend data | `spatial-enrichment` |
| Geomarketing sportswear | .../geomarketing-techniques-for-targeting-sportswear-consumers | Geomarketing, audience targeting | `trade-area-analysis` |
| Merchant scoring | .../spatial-scoring-measuring-merchant-attractiveness-and-performance | Spatial scoring, composite scores | `composite-scoring` |

#### Transport & Logistics (3)
| Tutorial | URL | Techniques | Skill relevance |
|----------|-----|------------|-----------------|
| EV charging site selection | .../optimizing-site-selection-for-ev-charging-stations | Site selection, enrichment, scoring | `trade-area-analysis`, `composite-scoring` |
| Scalable routing | .../how-to-run-scalable-routing-analysis-the-easy-way | OD matrix, routing | New skill potential |
| OD patterns | .../analyzing-origin-and-destination-patterns | H3 aggregation, OD analysis | `hotspot-analysis` |
| Accident hotspots | .../understanding-accident-hotspots | H3, Getis-Ord Gi* | `hotspot-analysis` |

#### Cross-industry (4)
| Tutorial | URL | Techniques | Skill relevance |
|----------|-----|------------|-----------------|
| Wind turbine planning | .../how-to-optimize-location-planning-for-wind-turbines | Site feasibility, terrain, demographics | `trade-area-analysis` |
| GenAI for spatial analysis | .../how-to-use-genai-to-optimize-your-spatial-analysis | ML Generate Text component | New capability |
| Walk-time isolines retail | .../calculate-walk-time-isolines-for-top-retail-locations | Isolines, population enrichment | `trade-area-analysis` |
| Active fire customers | .../identifying-customers-potentially-affected-by-an-active-fire-in-california | Spatial filter, buffer, intersection | `spatial-enrichment` |

### Workflow Templates (13 categories, ~60+ templates)

#### Data Preparation
- **URL**: https://academy.carto.com/creating-workflows/workflow-templates/data-preparation
- Join, group by, union, custom geo filter, multi-column formula, normalize, rank/limit, filter columns
- **Skill relevance**: Building blocks for all skills

#### Data Enrichment
- **URL**: https://academy.carto.com/creating-workflows/workflow-templates/data-enrichment
- Enrich buffers (Quadbin), trade areas (H3), points, polygons, grids
- **Skill relevance**: `spatial-enrichment` (core templates)

#### Spatial Indexes
- **URL**: https://academy.carto.com/creating-workflows/workflow-templates/spatial-indexes
- H3 polyfill, Quadbin from point, H3 from point, K-rings
- **Skill relevance**: Foundation for `hotspot-analysis`, `spatial-enrichment`

#### Spatial Analysis
- **URL**: https://academy.carto.com/creating-workflows/workflow-templates/spatial-analysis
- K-means clustering, point-in-polygon, aggregate into polygons, Voronoi, custom SQL
- **Skill relevance**: Potential new skill (spatial clustering / K-means)

#### Generating New Spatial Data
- **URL**: https://academy.carto.com/creating-workflows/workflow-templates/generating-new-spatial-data
- Custom geographies, routes, geocoding, lat/lon to points, isochrones
- **Skill relevance**: `trade-area-analysis` (isochrones), geocoding potential

#### Statistics
- **URL**: https://academy.carto.com/creating-workflows/workflow-templates/statistics
- POI hotspots, space-time hotspots, spacetime classification, time series clustering, spatial autocorrelation, GWR, composite scores (supervised + unsupervised), space-time anomalies
- **Skill relevance**: `hotspot-analysis`, `composite-scoring`, potential GWR/autocorrelation skills

#### Industry Templates
- **Retail & CPG**: Population around stores, commercial hotspots
- **Telco**: Population coverage, mobile pings, population stats, emergency response, tower site selection, competitor coverage, path profile/loss
- **Insurance**: Flood risk, volcano damage, underwriting, coastal flood, car journey risk
- **OOH**: Best billboards targeting
- **Skill relevance**: Industry-specific patterns that existing skills cover

#### Extension Package Templates
- **BigQuery ML**: Classification, regression, forecast, import model
- **Snowflake ML**: Classification, forecasting
- **Territory Planning**: Territory balancing, location allocation (maximize coverage / minimize cost)
- **Skill relevance**: `ml-pipelines`, potential territory planning skill

---

## 5. Advanced Spatial Analytics (Analytics Toolbox)

### BigQuery AT Tutorials (34 tutorials)

#### Statistics & Spatial Analysis
| Tutorial | URL | Technique |
|----------|-----|-----------|
| Composite score | .../how-to-create-a-composite-score-with-your-spatial-data | CREATE_SPATIAL_COMPOSITE_UNSUPERVISED |
| Space-time hotspot analysis | .../space-time-hotspot-analysis-identifying-traffic-accident-hotspots | GETIS_ORD_SPACETIME_H3_TABLE |
| Spacetime hotspot classification | .../spacetime-hotspot-classification-understanding-collision-patterns | SPACETIME_HOTSPOTS_CLASSIFICATION |
| Time series clustering | .../time-series-clustering-identifying-areas-with-similar-traffic-accident-patterns | CLUSTER_TIME_SERIES |
| Space-time anomaly (quick start) | .../detecting-space-time-anomalous-regions-to-improve-real-estate-portfolio-management-quick-start | DETECT_SPACETIME_ANOMALIES |
| Space-time anomaly (full) | .../detecting-space-time-anomalous-regions-to-improve-real-estate-portfolio-management | DETECT_SPACETIME_ANOMALIES |
| Spatial autocorrelation | .../computing-the-spatial-autocorrelation-of-pois-locations-in-berlin | LOCAL_MORANS_I |
| Amenity hotspots Stockholm | .../identifying-amenity-hotspots-in-stockholm | GETIS_ORD_H3_TABLE |
| GWR Airbnb prices | .../applying-gwr-to-understand-airbnb-listings-prices | GWR_GRID |
| Earthquake-prone areas | .../identifying-earthquake-prone-areas-in-the-state-of-california | Spatial statistics |

#### Retail / Site Selection
| Tutorial | URL | Technique |
|----------|-----|-----------|
| Store cannibalization | .../store-cannibalization-quantifying-the-effect-of-opening-new-stores-on-your-existing-network | Trade area overlap analysis |
| Twin areas | .../find-twin-areas-of-top-performing-stores | FIND_TWIN_AREAS |
| Similar locations | .../find-similar-locations-based-on-their-trade-areas | Location similarity |
| Pizza Hut Honolulu | .../opening-a-new-pizza-hut-location-in-honolulu | Commercial hotspot + site selection |
| Starbucks cannibalization | .../an-h3-grid-of-starbucks-locations-and-simple-cannibalization-analysis | H3 grid + overlap |
| CPG market penetration | .../calculating-market-penetration-in-cpg-with-merchant-universe-matching | Merchant matching |
| CPG merchant scoring | .../measuring-merchant-attractiveness-and-performance-in-cpg-with-spatial-scores | Spatial scoring |
| CPG merchant segmentation | .../segmenting-cpg-merchants-using-trade-areas-characteristics | Trade area segmentation |
| Chicago crime clusters | .../new-police-stations-based-on-chicago-crime-location-clusters | K-means clustering |

#### Data Processing & Enrichment
| Tutorial | URL | Technique |
|----------|-----|-----------|
| Trade area isolines | .../generating-trade-areas-based-on-drive-walk-time-isolines | CREATE_ISOLINES |
| Geocoding | .../geocoding-your-address-data | GEOCODE_TABLE |
| Data Observatory enrichment | .../data-enrichment-using-the-data-observatory | ENRICH_GRID / ENRICH_POLYGONS |

#### Telco
| Tutorial | URL | Technique |
|----------|-----|-----------|
| Signal coverage / path loss | .../analyzing-signal-coverage-with-line-of-sight-calculation-and-path-loss-estimation | LOS / path loss |

#### Geometry / Tiling
| Tutorial | URL | Technique |
|----------|-----|-----------|
| Kriging interpolation | .../interpolating-elevation-along-a-road-using-kriging | Spatial interpolation |
| Voronoi weather stations | .../analyzing-weather-stations-coverage-using-a-voronoi-diagram | ST_VORONOIPOLYGONS |
| Delaunay triangulation NYC | .../a-nyc-subway-connection-graph-using-delaunay-triangulation | ST_DELAUNAYPOLYGONS |
| Airport route interpolation | .../computing-us-airport-connections-and-route-interpolations | ST_GREATCIRCLE |
| SF buffer bikeshare | .../bikeshare-stations-within-a-san-francisco-buffer | Buffer analysis |
| UK census tiles | .../census-areas-in-the-uk-within-tiles-of-multiple-resolutions | Multi-resolution tiling |
| Simple tilesets | .../creating-simple-tilesets | CREATE_SIMPLE_TILESET |
| Spatial index tilesets | .../creating-spatial-index-tilesets | CREATE_SPATIAL_INDEX_TILESET |
| Aggregation tilesets | .../creating-aggregation-tilesets | CREATE_POINT_AGGREGATION_TILESET |
| Rooftop PV potential (raster) | .../using-raster-and-vector-data-to-calculate-total-rooftop-pv-potential-in-the-us | Raster + vector |
| Routing module | .../using-the-routing-module | ROUTING |

### Snowflake AT Tutorials (16 tutorials)

| Tutorial | URL | Technique |
|----------|-----|-----------|
| Composite score | .../how-to-create-a-composite-score-with-your-spatial-data | CREATE_SPATIAL_COMPOSITE_UNSUPERVISED |
| Space-time hotspot | .../space-time-hotspot-analysis-identifying-traffic-accident-hotspots | GETIS_ORD_SPACETIME_H3_TABLE |
| Spatial autocorrelation | .../computing-the-spatial-autocorrelation-of-pois-locations-in-berlin | LOCAL_MORANS_I |
| Amenity hotspots | .../identifying-amenity-hotspots-in-stockholm | GETIS_ORD_H3_TABLE |
| GWR Airbnb | .../applying-gwr-to-understand-airbnb-listings-prices | GWR_GRID |
| Pizza Hut Honolulu | .../opening-a-new-pizza-hut-location-in-honolulu | Site selection |
| Trade area isolines | .../generating-trade-areas-based-on-drive-walk-time-isolines | CREATE_ISOLINES |
| Geocoding | .../geocoding-your-address-data | GEOCODE_TABLE |
| Spatial index tilesets | .../creating-spatial-index-tilesets | Tilesets |
| Quadkey cannibalization | .../a-quadkey-grid-of-stores-locations-and-simple-cannibalization-analysis | Quadkey + overlap |
| Minkowski cannibalization | .../minkowski-distance-to-perform-cannibalization-analysis | Minkowski distance |
| Airport connections | .../computing-us-airport-connections-and-route-interpolations | Route interpolation |
| Store clusters | .../new-supplier-offices-based-on-store-locations-clusters | K-means |
| Voronoi store coverage | .../analyzing-store-location-coverage-using-a-voronoi-diagram | Voronoi |
| Catchment enrichment | .../enrichment-of-catchment-areas-for-store-characterization | Trade area enrichment |
| Data Observatory | .../data-enrichment-using-the-data-observatory | ENRICH_GRID |

### Redshift AT
- **URL**: https://academy.carto.com/advanced-spatial-analytics/spatial-analytics-for-redshift
- Less content available; follow same URL pattern

---

## 6. Potential New Skills (not yet covered)

Based on the academy content, these topics have enough depth to warrant new skills:

### Territory Planning / Location Allocation
- Workflow tutorials: territory balancing, location allocation (maximize coverage, minimize cost)
- AT coverage: extension package templates
- **Academy refs**:
  - .../optimizing-workload-distribution-through-territory-balancing
  - .../transforming-telco-network-management-decisions-with-location-allocation
  - Templates: territory-planning section

### Store Cannibalization / Twin Areas
- Multiple AT tutorials on overlap analysis, finding similar/twin areas
- **Academy refs**:
  - .../store-cannibalization-quantifying-the-effect-of-opening-new-stores-on-your-existing-network
  - .../find-twin-areas-of-top-performing-stores
  - .../an-h3-grid-of-starbucks-locations-and-simple-cannibalization-analysis

### Spatial Autocorrelation (Moran's I)
- Distinct from Getis-Ord — measures overall clustering pattern, not individual hotspots
- **Academy refs**:
  - .../computing-the-spatial-autocorrelation-of-pois-locations-in-berlin
  - Template: spatial auto-correlation of POI locations

### GWR (Geographically Weighted Regression)
- Models spatially varying relationships (e.g. what drives Airbnb prices differs by neighborhood)
- **Academy refs**:
  - .../applying-gwr-to-understand-airbnb-listings-prices
  - Template: GWR for local spatial relationships

### Routing / OD Analysis
- OD matrix, scalable routing, route creation
- **Academy refs**:
  - .../how-to-run-scalable-routing-analysis-the-easy-way
  - .../analyzing-origin-and-destination-patterns
  - .../using-the-routing-module

### Geocoding
- Address to point geometry conversion
- **Academy refs**:
  - .../geocoding-your-address-data (BQ + SF)
  - Template: geocode street addresses

---

## 7. Content to Enrich Existing Skills

### `hotspot-analysis`
- Academy accident hotspots tutorial: step-by-step workflow walkthrough
- AT Stockholm hotspots: raw SQL approach with GETIS_ORD_H3_TABLE
- Space-time hotspot: detailed temporal analysis patterns
- Spacetime classification: trend detection (new/intensifying/diminishing)
- Time series clustering: grouping similar temporal patterns
- Space-time anomaly detection: real estate portfolio management

### `spatial-enrichment`
- Create/enrich index tutorial: detailed step-by-step for all geometry types
- Scaling geoprocessing: buffer→kring, intersect→join, enrich 98% faster
- LTE coverage tutorial: full buffer→polyfill→join→enrich pipeline
- K-ring properties: distance approximation without geometry

### `composite-scoring`
- Fire risk composite score tutorial: end-to-end workflow walkthrough
- AT composite score tutorial: raw SQL with CREATE_SPATIAL_COMPOSITE_UNSUPERVISED
- Crime risk assessment: composite scoring for insurance
- Merchant scoring: spatial scoring in CPG context

### `trade-area-analysis`
- EV charging site selection: multi-criteria trade area scoring
- Walk-time isolines tutorial: isochrone-based trade areas
- AT isolines tutorial: raw SQL approach
- Similar locations / twin areas: comparing trade area characteristics
- Catchment enrichment (SF): enriching trade areas for characterization

### `ml-pipelines`
- Customer churn classification: BQ ML end-to-end
- GenAI for spatial analysis: ML Generate Text component

### `build-carto-workflow`
- Data optimization guide: provider-specific tips for saveastable
- All workflow template descriptions: component usage patterns
