import pandas as pd

# Load WCA competitions data
competitions = pd.read_csv('WCA Database/WCA_export_Competitions.tsv', delimiter='\t', low_memory=False)

# Filter competitions held in the Philippines
philippines_competitions = competitions[competitions['countryId'] == 'Philippines']

# Add a column for the name length
philippines_competitions['name_length'] = philippines_competitions['name'].apply(len)

# Sort competitions by name length
sorted_competitions = philippines_competitions[['name', 'name_length']].sort_values(by='name_length')
sorted_competitions.to_csv('philippines_competitions_name_lengths.csv', index=False)

print("All competition name lengths have been saved to 'philippines_competitions_name_lengths.csv'.")
