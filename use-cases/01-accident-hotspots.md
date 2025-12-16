I have bike accident data for Madrid in `cartodb-on-gcp-datascience.dvicente`. I want to identify the most dangerous areas for cyclists. Aggregate the accidents to an H3 grid and run a Getis-Ord Gi* hotspot analysis to find statistically significant clusters. Summarize the results by district.

Use `$WORKFLOWS_TEMP_LOCATION` as the Workflows temp location and the connection stored in `$WORKFLOWS_CONNECTION`.
