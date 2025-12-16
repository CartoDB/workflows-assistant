I have bike accident data along with infrastructure and station data for Madrid in `cartodb-on-gcp-datascience.dvicente`. For each accident, compute the distance to the nearest bike lane and nearest BiciMAD station using spatial joins. Export the enriched dataset with these features for use in machine learning.

Use `$WORKFLOWS_TEMP_LOCATION` as the Workflows temp location and the connection stored in `$WORKFLOWS_CONNECTION`.
