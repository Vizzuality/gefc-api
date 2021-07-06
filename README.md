# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration
Remember to add to your credentials:
devise_secret_key: { generated with rails secret }
api_client_key: { generated with rails secret }
api_valid_jwt: { generated using API::V1::Authentication.api_jwt }


* Database creation

* Database initialization

```
file_name=socioecon_widgets_2306.csv bundle exec rake groups:import_csv
file_name=socioecon_widgets.json bundle exec rake widgets:import_json
file_name=geometries_poly.geojson bundle exec rake geometries:polygons:import_geojson
file_name=geometries_point.geojson bundle exec rake geometries:points:import_geojson
```

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
