# SelectColumnAggregation

Select columns with aggregation methods for GROUP BY operations.

## Type Name
`SelectColumnAggregation` (internal: `WorkflowComponentParamType.SelectColumnAggregation`)

## Value Format

**Comma-separated pairs** of column name and aggregation method:

```json
{
  "name": "columns",
  "type": "SelectColumnAggregation",
  "value": "population,sum,area,avg,name,count"
}
```

Format: `column1,method1,column2,method2,column3,method3,...`

**Critical**: Must have an **even number** of comma-separated tokens.

## Structure

The value is parsed as alternating pairs:
- Token 1: column name
- Token 2: aggregation method
- Token 3: column name
- Token 4: aggregation method
- ... and so on

## Aggregation Methods by Column Type

### String Columns
| Method | Description |
|--------|-------------|
| `concat` | Concatenate values |
| `count` | Count occurrences |
| `any` | Any single value |
| `array` | Collect into array |

### Number Columns
| Method | Description |
|--------|-------------|
| `min` | Minimum value |
| `max` | Maximum value |
| `avg` | Average value |
| `sum` | Sum of values |
| `count` | Count occurrences |
| `any` | Any single value |
| `array` | Collect into array |

### Boolean Columns
| Method | Description |
|--------|-------------|
| `count` | Count occurrences |
| `count_distinct` | Count distinct values |
| `any` | Any single value |

### Geography Columns
| Method | Description |
|--------|-------------|
| `combine` | Union geometries |
| `count` | Count occurrences |
| `any` | Any single value |
| `array` | Collect into array |
| `centroid` | Centroid of geometries |
| `makeline` | Create line from points |
| `convexhull` | Convex hull of geometries |

## Validation Rules

1. Must have **even number** of comma-separated tokens
2. No empty tokens (no `,,` or trailing commas)
3. Column must exist in the source table
4. Aggregation method must be valid for the column's data type

## Common Mistakes

| Mistake | Example | Correction |
|---------|---------|------------|
| Odd number of tokens | `"col1,sum,col2"` | Add missing method: `"col1,sum,col2,avg"` |
| Empty column name | `",sum,col2,max"` | Remove leading comma |
| Empty method | `"col1,,col2,max"` | Specify method: `"col1,sum,col2,max"` |
| Trailing comma | `"col1,sum,col2,avg,"` | Remove trailing comma |
| Invalid method | `"col1,average"` | Use `avg`: `"col1,avg"` |
| Wrong method for type | `"name,sum"` (string column) | Use valid method: `"name,count"` |
| JSON format | `"[{...}]"` | Use comma-separated: `"col,method"` |

## Example Usage

### Single Column Aggregation
```json
{
  "name": "columns",
  "type": "SelectColumnAggregation",
  "value": "population,sum"
}
```

### Multiple Columns
```json
{
  "name": "columns",
  "type": "SelectColumnAggregation",
  "value": "population,sum,area,avg,count,max"
}
```

### Mixed Types
```json
{
  "name": "columns",
  "type": "SelectColumnAggregation",
  "value": "amount,sum,category,count,geom,combine"
}
```

### All Count Aggregations
```json
{
  "name": "columns",
  "type": "SelectColumnAggregation",
  "value": "id,count,name,count,type,count"
}
```

### Geometry Aggregation
```json
{
  "name": "columns",
  "type": "SelectColumnAggregation",
  "value": "geometry,combine,point_count,sum"
}
```

## Complete Node Example

```json
{
  "id": "groupby-node",
  "type": "generic",
  "data": {
    "name": "native.groupby",
    "label": "Group By District",
    "inputs": [
      { "name": "source", "type": "Table" },
      { "name": "groupby", "type": "Column", "value": ["district"] },
      { "name": "columns", "type": "SelectColumnAggregation", "value": "population,sum,area,avg,geom,combine" }
    ],
    "outputs": [
      { "name": "result", "type": "Table" }
    ]
  }
}
```

## Debugging

If you get validation errors:

1. **Count the tokens**: Split by comma and verify even count
2. **Check for empties**: Look for `,,` or leading/trailing commas
3. **Verify column names**: Use `carto connections describe` to get exact names
4. **Check method validity**: Match method to column data type

## Output Column Naming

**Important**: GroupBy output columns are renamed using the pattern `{column}_{method}`.

| Input | Aggregation | Output Column |
|-------|-------------|---------------|
| `population` | `sum` | `population_sum` |
| `area` | `avg` | `area_avg` |
| `geom` | `any` | `geom_any` |
| `count` | `max` | `count_max` |

Downstream nodes must reference the **renamed columns**, not the original names.

### Example

```json
// GroupBy with: "gi,any,p_value,any,district,any"
// Outputs columns: gi_any, p_value_any, district_any

// Downstream node must use:
{ "name": "column", "type": "Column", "value": "gi_any" }  // Not "gi"
```

## Related Types
- `Column` - Simple column selection (used for GROUP BY columns)
- `ColumnNumber` - Column + numeric weight pairs
