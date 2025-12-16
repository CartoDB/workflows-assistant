I have bike parking locations and district boundaries for Madrid in `cartodb-on-gcp-datascience.dvicente`. Do a spatial join to count parkings per district, then normalize by area to create a parking density score. Rank the districts from best to worst parking availability.

Use `$WORKFLOWS_TEMP_LOCATION` as the Workflows temp location and the connection stored in `$WORKFLOWS_CONNECTION`.
