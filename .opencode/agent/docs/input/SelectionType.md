# SelectionType

Selection of data types (provider-specific).

## Type Name
`SelectionType` (internal: `WorkflowComponentParamType.SelectionType`)

## Value Format

```json
{
  "name": "newtype",
  "type": "SelectionType",
  "value": "STRING"
}
```

## Purpose

Used when selecting a data type for type casting or schema operations. The available options depend on the database provider.

## Provider-Specific Types

### BigQuery
| Type | Description |
|------|-------------|
| `STRING` | Text data |
| `INT64` | 64-bit integer |
| `FLOAT64` | 64-bit floating point |
| `BOOL` | Boolean |
| `DATE` | Date |
| `DATETIME` | Date and time |
| `TIMESTAMP` | Timestamp with timezone |
| `GEOGRAPHY` | Spatial geometry |
| `JSON` | JSON data |

### Snowflake
| Type | Description |
|------|-------------|
| `VARCHAR` | Text data |
| `NUMBER` | Numeric |
| `FLOAT` | Floating point |
| `BOOLEAN` | Boolean |
| `DATE` | Date |
| `TIMESTAMP` | Timestamp |
| `GEOGRAPHY` | Spatial geometry |
| `VARIANT` | Semi-structured data |

### PostgreSQL
| Type | Description |
|------|-------------|
| `TEXT` | Text data |
| `INTEGER` | Integer |
| `DOUBLE PRECISION` | Floating point |
| `BOOLEAN` | Boolean |
| `DATE` | Date |
| `TIMESTAMP` | Timestamp |
| `GEOGRAPHY` | PostGIS geography |
| `GEOMETRY` | PostGIS geometry |

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using generic type name | Use provider-specific type: `INT64` not `INTEGER` for BigQuery |
| Case sensitivity | Types are typically uppercase |
| Incompatible cast | Not all type conversions are valid |

## Example Usage

### Cast to String (BigQuery)
```json
{
  "name": "newtype",
  "type": "SelectionType",
  "value": "STRING"
}
```

### Cast to Number (BigQuery)
```json
{
  "name": "newtype",
  "type": "SelectionType",
  "value": "FLOAT64"
}
```

### Cast to Geography (BigQuery)
```json
{
  "name": "newtype",
  "type": "SelectionType",
  "value": "GEOGRAPHY"
}
```

## Typical Use Cases

- Type casting with `native.cast` component
- Schema modification
- Data transformation

## Related Types
- `Selection` - For general dropdown selections
- `SelectColumnType` - For column + type selection pairs
