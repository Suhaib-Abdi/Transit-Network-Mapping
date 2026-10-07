import pandas as pd

def load_gtfs(data_dir):
    # Load raw text files
    routes = pd.read_csv(f'{data_dir}/routes.txt')
    trips = pd.read_csv(f'{data_dir}/trips.txt')
    stops = pd.read_csv(f'{data_dir}/stops.txt')
    stop_times = pd.read_csv(f'{data_dir}/stop_times.txt')

    # Drop unused columns
    routes = routes.drop(columns=['route_desc', 'route_url', 'route_color', 'route_text_color'], errors='ignore')
    stops = stops.drop(columns=['stop_desc', 'stop_url', 'zone_id', 'level_id', 'location_type'], errors='ignore')
    trips = trips.drop(columns=['block_id', 'trip_short_name'], errors='ignore')
    stop_times = stop_times.drop(columns=['stop_headsign', 'pickup_type', 'drop_off_type'], errors='ignore')

    # Convert times to timedelta (handles times past 24:00:00)
    stop_times['arrival_timedelta'] = pd.to_timedelta(stop_times['arrival_time'])
    stop_times['departure_timedelta'] = pd.to_timedelta(stop_times['departure_time'])

    return routes, trips, stops, stop_times
trips_routes = pd.merge(trips, routes, on='route_id', how='left')
full_schedule = pd.merge(stop_times, trips_routes, on='trip_id', how='left')
master_schedule = pd.merge(full_schedule, stops, on='stop_id', how='left')
master_schedule = master_schedule.sort_values(['trip_id', 'stop_sequence'])

#Filter by Active Service Days
calendar = pd.read_csv(f'{data_dir}/calendar.txt')
weekday_services = calendar[calendar['monday'] == 1]['service_id']
weekday_schedule = master_schedule[master_schedule['service_id'].isin(weekday_services)]
