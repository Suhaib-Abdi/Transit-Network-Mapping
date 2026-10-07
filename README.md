# Transit-Network-Mapping
# MBTA Transit Network Mapping & Analysis

This project processes, analyzes, and visualizes the Massachusetts Bay Transportation Authority (MBTA) transit system using raw General Transit Feed Specification (GTFS) data. It combines a relational SQL database for querying schedule analytics with a Python pipeline for memory-efficient data processing and interactive  mapping.

## Technologies Used
* **Python :** Data manipulation and pipeline automation.
* **Pandas:** Memory-efficient merging and time-series transformations (handling >3 million stop times).
* **Plotly Express:** Interactive geospatial network visualization.
* **MySQL:** Relational database  design and advanced analytical querying.

## Repository Files
* **`Code for TNP.py`**: The core Python script that ingests the raw GTFS text files, optimizes memory usage by dropping unused columns, converts 25+ hour scheduling formats using `timedelta`, and generates an interactive web map of the entire network.
* **`Query codes for this project.sql`**: The database initialization script. It creates the `mbta_db` schema, builds the relational tables (`routes`, `trips`, `stops`, `stop_times`), and securely loads the heavy local CSV data into the database.
* **`questions using the code.sql`**: A collection of 10   queries designed to extract  insights from the network, such as identifying the busiest transit hubs, calculating extreme geographic boundaries, and isolating peak morning service deployments.



### Dependencies
Open your terminal and install the required libraries:
```bash
pip install pandas plotly<img width="1922" height="621" alt="image" src="https://github.com/user-attachments/assets/191c95f6-9725-48ab-848f-078ac282df9a" />
