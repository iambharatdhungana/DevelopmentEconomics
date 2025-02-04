# Load necessary libraries
library(dplyr)
library(tidyr)

# Read the CSV file while skipping metadata rows
df <- read.csv("annualgdpwb.csv", check.names = FALSE, skip = 3)

# Rename the first few columns for clarity
colnames(df)[1:4] <- c("Country Name", "Country Code", "Indicator Name", "Indicator Code")

# Filter for Nepal and GDP growth indicator
nepal_gdp <- df %>%
  filter(`Country Name` == "Nepal", `Indicator Name` == "GDP growth (annual %)") %>%
  select(-`Country Code`, -`Indicator Name`, -`Indicator Code`)  # Remove unnecessary columns

# Convert from wide to long format for easier calculations
nepal_gdp_long <- pivot_longer(nepal_gdp, cols = -`Country Name`, names_to = "Year", values_to = "GDP_Growth")

# Convert Year to numeric
nepal_gdp_long$Year <- as.numeric(nepal_gdp_long$Year)

# Group by decades and calculate average GDP growth
average_gdp_by_decade <- nepal_gdp_long %>%
  mutate(Decade = floor(Year / 10) * 10) %>%
  group_by(Decade) %>%
  summarize(Average_GDP_Growth = mean(`GDP_Growth`, na.rm = TRUE))

# Print results
print(average_gdp_by_decade)
