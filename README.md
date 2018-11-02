# Trade liberation on food security

The complex system of weather shocks, price flunctuations, trade liberation and food security.

The motivation, research design, methodology are listed in the food_trade.pdf. 


1.Current stance: 

a. Clean and merged data of global food production, crop prices, trade dependence, weather (annual 1957-2006)

b. Find weather shocks to ag production, crop prices alleviated by higher trade openness, but effects on conflict is small and inconsitent.

c. Trying to finetuning variables like using more accurate weather data, focus on a subset of countries. 

2. Next steps: 

a. Focus countries on SSA and probably south Asia 

b. Collect and clean local food prices, food security surveys where available

c. Merge in the cropland specific weather, identify primary (rainfed) growing season in the countries

d. run the same panel regression with fixed effect 

3. Data: 

a. master_data contains the crop production, trade dependence, commodity prices and weather variables for the main developing countries.

b. Policy_data is a subset data that has some estimated subsidy and tax policy measures in monetary terms. Only exists for a subset of countries. 

c. Wto_data contains the all the information on when do countries enter the GATT and WTO. 

d. cropland specific weather data 


4. Code:

panel_regression.do contains the most recent dofile  

