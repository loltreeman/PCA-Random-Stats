import pandas as pd

# Define the list of events in WCA order
eventi = [
    '333', '222', '444', '555', '666', '777', '333bf',
    '333fm', '333oh', 'clock', 'minx', 'pyram', 'skewb', 'sq1',
    '444bf', '555bf', '333mbf'
]

# Load the WCA results data
results = pd.read_csv('WCA Database/WCA_export_Results.tsv', delimiter='\t', low_memory=False)
persons = pd.read_csv('WCA Database/WCA_export_Persons.tsv', delimiter='\t', low_memory=False)

# Filter results for Filipino competitors
filipino_results = results[results['personCountryId'] == 'Philippines']

# Total number of unique Filipino competitors
total_competitors = persons[persons['countryId'] == 'Philippines']['id'].nunique()

# Initialize dictionary to store data
data = {}
event_participation = {}  # Store participation stats

# Iterate over each event
for event in eventi:
    # Filter results for the current event
    event_results = filipino_results[filipino_results['eventId'] == event]
    
    # Count unique competitors in the event
    num_competitors = event_results['personId'].nunique()
    event_participation[event] = num_competitors

    # Group by personId to find the best single and average
    grouped = event_results.groupby('personId').agg({
        'best': 'min',
        'average': lambda x: x[x > 0].min() if any(x > 0) else None  # Consider only positive averages
    }).reset_index()
    
    # Merge with persons data to get competitor names
    merged = pd.merge(grouped, persons[['id', 'name']], left_on='personId', right_on='id')
    
    # Ensure unique names
    merged = merged.drop_duplicates(subset=['name'])
    
    # Store results in dictionary format
    for _, row in merged.iterrows():
        name = row['name']
        if name not in data:
            data[name] = {}
        data[name][f"{event}_single"] = row['best']
        data[name][f"{event}_average"] = row['average']

# Convert dictionary to DataFrame
final_df = pd.DataFrame.from_dict(data, orient='index').reset_index()
final_df.rename(columns={'index': 'name'}, inplace=True)

# Save competitor results to CSV
final_df.to_csv('Filipino_Speedcubers_Results.csv', index=False)

# Create event participation DataFrame
event_stats = pd.DataFrame([
    {'Event': event, 'Competitors': event_participation[event], 
     'Total Competitors': total_competitors, 
     'Participation %': (event_participation[event] / total_competitors) * 100}
    for event in eventi
])

# Save event stats to CSV
event_stats.to_csv('Filipino_Event_Participation.csv', index=False)

print("✅ Best singles and averages saved in 'Filipino_Speedcubers_Results.csv'.")
print("✅ Event participation stats saved in 'Filipino_Event_Participation.csv'.")
