I have data about Madrid's public bike-sharing stations in `cartodb-on-gcp-datascience.dvicente`. I want to find areas that are underserved. Compute walking isochrones (5 and 10 minutes) around each station, then identify which parts of the city fall outside these service areas. Show the coverage gaps by district.

Use `$WORKFLOWS_TEMP_LOCATION` as the Workflows temp location and the connection stored in `$WORKFLOWS_CONNECTION`.
