# Archived since Garmin Connect API (undocumented one) doesn't support course alteration for the current user

### PROGRAM CHANGES

1. read all current routes from the Strava API
2. compare the current ones with the ones that we have saved in the DB

- if the Strava route isn't in the DB, we INSERT it into the DB
- if some route with the same name already exists, we check route['updated_at'] against the DB
  - if it's the same, we do nothing
  - if it's not the same, we update it in the DB and mark it for processing in Garmin Connect
- if we have a route in the DB that isn't in Strava anymore, we mark it for DELETE
  - this marks the route for deletion in the DB
  - deletes the route from Garmin Connect
  - deletes the route from DB

For communication with the Garmin API, check out [this](https://github.com/cyberjunky/python-garminconnect/blob/master/garminconnect/__init__.py)
