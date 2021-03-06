# Projected Childhood Asthma in School Zones

This application uses the base model developed from U.S. Census Data and matches with data from the Child Asthma Call Back Survey to project the number of children with uncontrolled asthma symptoms in environments with asthma triggers, and maps it by school zone. Code for the simulation is https://github.com/DataAnalyticsinStudentHands/SyntheticDataSet/tree/master/Potential%20Expansions/BRFSS . The finished app is hosted here: http://dash.hnet.uh.edu:3838/cmupchur/asthma_app/ .

Once the model has been run with both the merge with the BRFSS data as mentioned above and with the shape files for locations of the houses with the code from https://github.com/DataAnalyticsinStudentHands/SyntheticDataSet/tree/master/Potential%20Expansions/merging%20with%20HCAD%20functions 

The place_kids_in_school_zones.R script can be sourced to put individuals in school zones. To source the script the model and school zone shapefiles from http://cohgis-mycity.opendata.arcgis.com/datasets?t=after%20school%20program. Then the table_variables_by_school_and_make_maps.R script can be sourced to create the maps used in the app. The app can be displayed by sourcing either ui.R or server.R from the appropriate working directory.
