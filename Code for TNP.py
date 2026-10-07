import pandas as pd
import plotly.express as px

def load_gtfs(data_dir):
    # Load raw text files 
    routes = pd.read_csv(f'{data_dir}/routes.txt', low_memory=False)
    trips = pd.read_csv(f'{data_dir}/trips.txt', low_memory=False)
    stops = pd.read_csv(f'{data_dir}/stops.txt', low_memory=False)
    stop_times = pd.read_csv(f'{data_dir}/stop_times.txt', low_memory=False)

    routes = routes.drop(columns=['route_desc', 'route_url', 'route_color', 'route_text_color'], errors='ignore')
    stops = stops.drop(columns=['stop_desc', 'stop_url', 'zone_id', 'level_id', 'location_type'], errors='ignore')
    trips = trips.drop(columns=['block_id', 'trip_short_name'], errors='ignore')
    stop_times = stop_times.drop(columns=['stop_headsign', 'pickup_type', 'drop_off_type'], errors='ignore')

    # Convert times to timedelta 
    stop_times['arrival_timedelta'] = pd.to_timedelta(stop_times['arrival_time'])
    stop_times['departure_timedelta'] = pd.to_timedelta(stop_times['departure_time'])

    return routes, trips, stops, stop_times


#MAIN
if __name__ == '__main__':
    data_path = 'C:/Transit-Network-Mapping/mdb-437-202610030001'
    
    # 1. Load data
    routes, trips, stops, stop_times = load_gtfs(data_path)

    trips_routes = pd.merge(trips, routes, on='route_id', how='left')
    full_schedule = pd.merge(stop_times, trips_routes, on='trip_id', how='left')
    master_schedule = pd.merge(full_schedule, stops, on='stop_id', how='left')
    master_schedule = master_schedule.sort_values(['trip_id', 'stop_sequence'])

    trip_durations = master_schedule.groupby('trip_id').agg(
        start_time=('arrival_timedelta', 'min'),
        end_time=('arrival_timedelta', 'max')
    )
    trip_durations['total_duration'] = trip_durations['end_time'] - trip_durations['start_time']

    fig = px.scatter_map(
        stops, 
        lat="stop_lat", 
        lon="stop_lon", 
        hover_name="stop_name", 
        zoom=10, 
        height=700,
        title="MBTA Complete Transit Network Stops"
    )
    fig.update_layout(map_style="open-street-map")
    fig.show()