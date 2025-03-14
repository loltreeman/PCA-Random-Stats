import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime, timedelta

# Load WCA data
results = pd.read_csv('WCA Database/WCA_export_Results.tsv', delimiter='\t', low_memory=False)
competitions = pd.read_csv('WCA Database/WCA_export_Competitions.tsv', delimiter='\t', low_memory=False)
persons = pd.read_csv('WCA Database/WCA_export_Persons.tsv', delimiter='\t', low_memory=False)

# Convert competition dates to datetime
competitions['date'] = pd.to_datetime(competitions['date'])

# Define the cutoff for "active" competitors (last 365 days)
one_year_ago = datetime.today() - timedelta(days=365)

# Filter for Filipino competitors only
filipino_competitors = persons[persons['countryId'] == 'Philippines']['id'].unique()
filipino_results = results[results['personId'].isin(filipino_competitors)]

# Get total number of Filipino competitors
total_filipino_competitors = len(filipino_competitors)

# Filter competitions in the last year
recent_competitions = competitions[competitions['date'] >= one_year_ago]

# Get list of active Filipino competitors (who competed in the last year)
active_filipino_ids = filipino_results[filipino_results['competitionId'].isin(recent_competitions['id'])]['personId'].unique()
active_filipino_competitors = len(active_filipino_ids)

# Calculate participation rate
participation_rate = (active_filipino_competitors / total_filipino_competitors) * 100

# Save results to CSV
filipino_stats = pd.DataFrame([{
    'Total Filipino Competitors': total_filipino_competitors,
    'Active Filipino Competitors': active_filipino_competitors,
    'Participation Rate (%)': participation_rate
}])

filipino_stats.to_csv('Filipino_Competitors.csv', index=False)

# 📊 Generate a Bar Chart
labels = ['Total Competitors', 'Active Competitors']
values = [total_filipino_competitors, active_filipino_competitors]

plt.figure(figsize=(6, 4))
plt.bar(labels, values, color=['blue', 'green'])
plt.ylabel('Number of Competitors')
plt.title('Total vs Active Filipino Competitors')
plt.text(0, total_filipino_competitors, f"{total_filipino_competitors}", ha='center', va='bottom', fontsize=12)
plt.text(1, active_filipino_competitors, f"{active_filipino_competitors}", ha='center', va='bottom', fontsize=12)

# Save and Show Graph
plt.savefig('Filipino_Competitors.png')
plt.show()

print("✅ Filipino competitor stats saved in 'Filipino_Competitors.csv' and 'Filipino_Competitors.png'.")
