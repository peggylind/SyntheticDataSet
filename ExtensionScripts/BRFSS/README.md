# Behavioral Risk Factor Surveillance System Scripts
The Behavioral Risk Factor Surveillance System is the Center for Disease Control's national telephone survey on health behaviors and outcomes. The data is publicly available at https://www.cdc.gov/brfss/annual_data/annual_data.htm. A more in depth survey on asthma behaviors and outcomes for participants who responded that they or their child have been diagnosed with asthma is also collected and the data is also publicly available at https://www.cdc.gov/brfss/acbs/index.htm.

These scripts are to clean and merge this data to augment possible houston created by citymodels. clean_and_merge_BRFSS_data.R is used to prepare the BRFSS data for the for_diabetes_BRFSS.R functions. These functions add diabetes and prediabetes related variables to a citymodels dataset by matching characteristics of the respondents of the survey with the simulated characteristics of individuals in the model and then sampling randomly to assign appropriate health behaviors and outcomes variables.

new_diabetes_simulation_prep_for_opuntia.R is a use case for these functions. It augments the Houston model with diabetes and prediabetes related variables which are then used to further extrapolate the impact of the Diabetes Prevention Program. The projected participation rate, costs and savings were taken from the CDC's Impact app technical information available here: https://www.cdc.gov/diabetes/prevention/pdf/Impact_Toolkit_TechnicalReport.pdf. After the model was created it was demonstrated in an RShiny app at http://dash.hnet.uh.edu:3838/cmupchur/diabetes_app/ . The code for this app available here: https://github.com/DataAnalyticsinStudentHands/SyntheticDataSet/tree/master/Shiny%20Apps/diabetes%20app .

organize_BRFSS_and_asthma_survey.R cleans and merges the Childhood Asthma Call Back Survey and the Behavioral Risk Factor Surveillance System data for use in the simulate_asthma.R functions. These functions first subset households with children, match for characteristics to simulate asthma diagnosis, then match and simulate further characteristics from the Childhood Asthma Call Back Survey. This was also used in a Houston use case demonstrated in an app here: http://dash.hnet.uh.edu:3838/cmupchur/asthma_app/ with code available here: https://github.com/DataAnalyticsinStudentHands/SyntheticDataSet/tree/master/Shiny%20Apps/asthma%20app

The primary function used for the merge can just be called with the model created from citymodels and a seed for sampling.

```R
merged_model=getBRFSSdata(current_model,seed=1)
```

The app specific scripts should just be sourced with the model that has already been merged with HCAD using the functions in https://github.com/DataAnalyticsinStudentHands/SyntheticDataSet/tree/master/Potential%20Expansions/merging%20with%20HCAD%20functions to create the outputs specif to apps in https://github.com/DataAnalyticsinStudentHands/SyntheticDataSet/tree/master/Shiny%20Apps .

