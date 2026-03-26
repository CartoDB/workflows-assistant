# Import Commands

## carto imports create

Import geospatial files to a table.

```bash
carto imports create
  --file <path>             # Local file to upload
  --url <url>               # Remote file URL
  --connection <name>       # Connection name (required)
  --destination <fqn>       # Target table FQN (required)
  --overwrite               # Overwrite existing table
  --no-autoguessing         # Disable column type detection
  --async                   # Return immediately (don't wait)
```

**Supported formats**: CSV, GeoJSON, GeoPackage, GeoParquet, KML, KMZ, Shapefile (zip)

**Size limit**: 1GB per file

## Examples

### Local File Upload

```bash
carto imports create \
  --file ./data.csv \
  --connection carto_dw \
  --destination project.dataset.table
```

### Remote URL Import

```bash
carto imports create \
  --url https://example.com/data.geojson \
  --connection carto_dw \
  --destination project.dataset.my_data
```

### Overwrite Existing Table

```bash
carto imports create \
  --file ./updated.csv \
  --connection carto_dw \
  --destination project.dataset.table \
  --overwrite
```

### Async Import (Don't Wait)

```bash
carto imports create \
  --file ./large_file.geojson \
  --connection carto_dw \
  --destination project.dataset.large_data \
  --async
```

## Behavior

- **Default**: Waits for completion and reports status
- **With `--async`**: Returns immediately after upload starts
- **Column detection**: Automatically guesses column types unless `--no-autoguessing` is set
