# Component: native.getisord

Performs Getis-Ord Gi* spatial statistic analysis.

## Output Schema

The Getis-Ord component outputs exactly **3 columns**, regardless of input:

| Column | Type | Description |
|--------|------|-------------|
| `index` | STRING | The spatial index value - **renamed from input column** |
| `gi` | FLOAT64 | The Gi* z-score statistic |
| `p_value` | FLOAT64 | The p-value for statistical significance |

**All other input columns are dropped.**

## Gotcha: Column Renaming

**The input index column is renamed to `index`** in the output, regardless of its original name.

```
Input:  h3, value, other_col, ...
Output: index, gi, p_value
```

Reference `index` (not the original column name) in downstream nodes.
