import pandas as pd
import requests
import time
from io import StringIO

def scrape_batting_stats(year):
    """
    Scrapes standard batting stats for a given MLB season from Baseball Reference.
    Saves both raw and cleaned summary data to CSV.
    """
    try:
        print(f"Scraping data for {year}...")

        # Construct URL for the desired year's standard batting stats
        url = f"https://www.baseball-reference.com/leagues/majors/{year}-standard-batting.shtml"
        print(f"URL: {url}")

        # Set headers to mimic a browser request (helps avoid request blocks)
        headers = {'User-Agent': 'Mozilla/5.0'}
        response = requests.get(url, headers=headers)

        # Check for successful HTTP response
        if response.status_code != 200:
            print(f"Failed to fetch data for {year}. Status code: {response.status_code}")
            return None

        # Parse HTML tables using pandas
        tables = pd.read_html(StringIO(response.text))
        print(f"Found {len(tables)} tables.")

        # Identify the correct table containing player batting stats
        df = next((t for t in tables if 'Player' in t.columns and 'G' in t.columns), None)
        if df is None:
            print(f"No valid table found for {year}")
            return None

        print(f"Selected DataFrame Columns: {df.columns}")

        # Save the raw table to a CSV for inspection
        df.to_csv(f"raw_data_{year}.csv", index=False)
        print(f"Raw data saved to raw_data_{year}.csv")

        # Add a column indicating the season year
        df['Year'] = year

        # Clean player names by removing symbols like '#' and '*'
        df['Player'] = df['Player'].str.replace(r'[#*]', '', regex=True).str.strip()

        # Keep only summary rows for players who played on multiple teams or leagues
        df = df[(df['Team'] == '2TM') | (df['Lg'] == '2LG')]

        # Fill any missing values with 0
        df = df.fillna(0)

        # Attempt to convert all columns to numeric where possible
        for col in df.columns:
            try:
                df[col] = pd.to_numeric(df[col], errors='coerce')
            except Exception as e:
                print(f"Error converting column {col}: {e}")

        # Save cleaned summary data to CSV
        filename = f"batting_stats_{year}.csv"
        df.to_csv(filename, index=False)
        print(f"Summary data saved to {filename}")

        # Pause between requests to avoid triggering anti-scraping measures
        time.sleep(3)

        return df

    except Exception as e:
        print(f"Error scraping data for {year}: {e}")

# Loop through a range of years to scrape data in bulk
for year in range(2015, 2025):
    scrape_batting_stats(year)

print("Scraping and data saving completed.")
