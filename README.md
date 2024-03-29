# README

API for Green Energy China Platform.

## System dependencies

- Ruby v3.0.0
- PostgreSQL v14 + PostGIS
- Memcached

## Configuration

Copy the `.env.sample` file as `.env` and fill the different variable values accordingly.

## Tests

`bundle exec rspec spec`

## Code coverage

After running the test suit, you will find a coverage report at `coverage/index.html`.

## Data import tasks

This project includes multiple `rake` tasks to handle different data import and transformation tasks.

### All-in-one task

`folder_name=<full path to the folder containing the data>  bundle exec rake import:all`

This assumes the following:
- All the files (`*.csv`, `*.json`, `*.geojson`), except the sankey `.json`, must be in the root of that folder.
- There can only be two subfolders named `sankey` and `energy_balance` respectively. In each, there can only be a single `.json` file that contains the corresponding data.


This command is a simple aggregate of all the commands below, executed back to back in the correct order. The operation
is not atomic. For details on what exactly this command does, check the documentation for each of the subtasks it executes.

> Example

```
<root folder>
├── <data_file_1>.csv
├── <data_file_1>.json
├── <data_file_2>.csv
├── <data_file_2>.json
├── <data_file_3>.csv
├── <data_file_3>.json
├── <geometries_file_1>.geojson
├── <geometries_file_2>.geojson
├── sankey
   └── <sankey_file>.json
├── energy_balance
   └── <energy_balance>.json
```

### Step by step / details

The above command combines all the 

### Data import

- `groups:import_csv_file`: Imports a .csv file containing Records. Creates associated Indicator, Groups, Subgroups,
  Units, Regions, Scenarios, Widgets, and underlying associations. Deletes all these data types prior to import.
  Requires a `file_name` env var with the full path to the .csv file.
- `groups:import_csv_folder`: Similar to `groups:import_csv_file`, but instead imports all .csv files found within a
  given folder. Requires a `folder_name` env var with the full path to the folder containing the .csv files.
- `widgets:import_json_file`: Imports a .json file containing widgets configuration data, extending existing Indicator
  data and creating IndicatorWidget associations. Deletes all IndicatorWidget prior to import. Requires preexisting
  Indicator, Groups, Subgroups data (imported through either `groups:import_csv_file` or `groups:import_csv_folder`).
  Requires a `file_name` env var with the full path to the .json file.
- `widgets:import_json_folder`: Similar to `widgets:import_json_file`, but instead imports all .json files found within
  a given folder. Requires a `folder_name` env var with the full path to the folder containing the .json files.
- `sankeys:import_json`: Imports a .json file containing sankey Indicator data, extending existing Indicator data.
  Requires preexisting Indicator data (imported through either `groups:import_csv_file` or `groups:import_csv_folder`).
  Requires a `file_name` env var with the full path to the .json file.
- `geometries:import_geojson`: Imports all .geojson files contained in the provided `folder_name` env var.
  Adds these geographic data to existing Regions, or creates new ones.

### Data transform

- `indicators:populate_extra_info`: Recalculates Indicator visualization meta that is used to configure frontend visualisations. 
   Should only be executed after `widgets:import_json_file` or `widgets:import_json_folder`
- `indicators:populate_sankey_meta`: For existing indicators that are visualized in a sankey diagram, recalculates the
  visualisation metadata that is used to configure frontend visualisations. Should only be executed
  after `widgets:import_json_file` or `widgets:import_json_folder`
- `regions:populate_extra_info`: <TBD>

## Updating datasets

3 ways to do this:

1. using the CMS: import files in the order in which they come in the `Import` menu item:
    1. Groups
    2. Widgets
    3. Points
    4. Polygons
2. using individual rake tasks: need to be run in the correct order
   ```
   file_name=socioecon_widgets_2306.csv bundle exec rake groups:import_csv
   file_name=socioecon_widgets.json bundle exec rake widgets:import_json
   file_name=geometries_poly.geojson bundle exec rake geometries:polygons:import_geojson
   file_name=geometries_point.geojson bundle exec rake geometries:points:import_geojson
   ```
3. using a combo rake task
   `groups_file_name=socioecon_widgets_2306.csv widgets_file_name=socioecon_widgets.json points_file_name=geometries_point.geojson polygons_file_name=geometries_poly.geojson bundle exec rake import:all`

For running the rake tasks on staging, you need to:

- be able to ssh to the staging server
  `ssh [user]@[server]` (check config/deploy/staging.rb for server address, your SSH key needs to be allowed on the
  server)
- upload your files to the staging server, e.g. using `scp`
  `scp socioecon_widgets_2306.csv [user]@[server]:/var/www/gefc_api/current`
- navigate to the application directory on the server
  `cd /var/www/gefc_api/current`
- run the tasks prepending `RAILS_ENV=staging`
  e.g. `RAILS_ENV=staging file_name=socioecon_widgets_2306.csv bundle exec rake groups:import_csv`


* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
  Remember to update `.env` if needed and then `cap staging deploy`.

## Deploying

Deploying the application to production is done using [Capistrano](https://capistranorb.com/), which is already
configured.
You will need SSH access to the server, which you can get from the server's admin.

## Configuration

High-level application configuration is done using environment variables. The list below covers the application-specific
variables used. More, like the standard Rails env vars, are available.

| Variable name          | Description                                                                                               | Default value |
|------------------------|-----------------------------------------------------------------------------------------------------------|--------------:|
| POSTGRES_DATABASE      | Name of the Postgres database to use.                                                                     |      gefc_api |
| POSTGRES_USERNAME      | Postgres username to use.                                                                                 |      postgres |
| POSTGRES_PASSWORD      | Postgres password to use.                                                                                 |               |
| POSTGRES_HOST          | Postgres server hostname                                                                                  |     localhost |
| POSTGRES_PORT          | Postgres server port                                                                                      |          5432 |
| REDIS_URL              | Full Redis URL, including protocol, host, port and database, for the Redis server for Sidekiq async tasks |               |
| DOWNLOADS_PATH         | Path under the local file system where the generated download files are stored                            |               |
| API_BASE_URL           | Base URL (inc protocol) under which the API is hosted                                                     |               |
| SITE_BASE_URL          | Base URL (inc protocol) under which the site is hosted                                                    |               |
| FROM_EMAIL_ADDRESS     | Email address from which to send system emails (like "reset password")                                    |               |
| APPSIGNAL_PUSH_API_KEY | AppSignal API Key for error and metric logging                                                            |               |
