import pandas as pd

# List of events in WCA order
eventi = [
    '333', '222', '444', '555', '666', '777', '333bf',
    '333fm', '333oh', 'clock', 'minx', 'pyram', 'skewb', 'sq1',
    '444bf', '555bf', '333mbf'
]

results = pd.read_csv('WCA Database/WCA_export_Results.tsv', delimiter='\t', low_memory=False)
persons = pd.read_csv('WCA Database/WCA_export_Persons.tsv', delimiter='\t', low_memory=False)

filipino_results = results[results['personCountryId'] == 'Philippines']

# Initialize lists to store best singles and averages
data = {}

for event in eventi:
    # Filter results for the current event
    event_results = filipino_results[filipino_results['eventId'] == event]
    
    # Group by personId to find the best single and average
    grouped = event_results.groupby('personId').agg({
        'best': 'min',
        'average': lambda x: x[x > 0].min() if any(x > 0) else None  # Consider only positive averages
    }).reset_index()

    merged = pd.merge(grouped, persons[['id', 'name']], left_on='personId', right_on='id')
    
    merged = merged.drop_duplicates(subset=['name'])
    
    for _, row in merged.iterrows():
        name = row['name']
        if name not in data:
            data[name] = {}
        data[name][f"{event}_single"] = row['best']
        data[name][f"{event}_average"] = row['average']

final_df = pd.DataFrame.from_dict(data, orient='index').reset_index()
final_df.rename(columns={'index': 'name'}, inplace=True)

final_df.to_csv('Filipino_Speedcubers_Results.csv', index=False)

print("Best singles and averages for Filipino speedcubers have been recorded in 'Filipino_Speedcubers_Results.csv'.")
