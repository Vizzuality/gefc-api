# README

API for Green Energy China Platform.

## Ruby version
3.0.0

## System dependencies
PostgreSQL 12

## Configuration

Grab a copy of the `.env` file


## Database creation
Grab a dump

## How to run the test suite
`bundle exec rspec spec`

## Check coverage
After running the test suit you will find the a coverage report at coverage/index.html. Try running `xdg-open coverage/index.html`

## Authentication

 - How should the client authenticate?
	Since /login and /signup are protected using authentication, the api expects a header with key 'Api-Auth' and a valid jwt as value, but only for those endpoints.
 - What makes valid an api jwt?
	The api_jwt es generated using two elements: the payload that we expect to be encrypted and the encryption key.
	 - In the payload we expect to find encrypted the api_client_key in our credentials.
	 - We use the devise_secret_key as encryption key.
 - How can I get one of those super cool api valid jwt?
	Just run rails api_jwt:generate

Remember to add to your credentials:

    api_valid_jwt: { generated rails api_jwt:generate }
*Right now this one is only used in the specs but I would like to keep it in the credentials until we agree with the FE about how are we going to authenticate because I have seen that api-key is saved in the .env in otp, but for me makes more sense not saving it at all and rely in deconding the token to authenticate.*

    devise_secret_key: { generated with rails secret }

*This is the key that we are using to encrypt all jwt, maybe would make more sense to rename it into jwt_secret_key, right?*

    api_client_key: { generated with rails secret }

*this is the key that we encrypt into the api_jwt payload.*

### Usage example

 - Signup request, which creates a new user if Api-Auth is valid:
 ```
	     curl --location --request POST 'http://127.0.0.1:3000/api/v1/users/signup' \
    --header 'Api-Auth: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5MDc0NzlmMTkzNDc1ZmRmOTQ5ZDkzN2QxZTA2ZDUxMmE5ZWRmMDdjNTUxZmFmODFlOGEyNWQyMTZmYmRiNTMxZjk0ZDhkNjcyZTZmNGYyZDVjMDFjYTQzNDBmODdhOTg0YTY0ZmEwZDYzM2IyM2QxNTFjNDlmYjIzZWRjYTY1NyIsImV4cCI6MTYyNjc3ODA2N30.kAAUhF35vHZYbHPN1lTebrRJm5wWj7OjO4Hv_Eh7uiY"' \
    --header 'Content-Type: application/json' \
    --header 'Cookie: __profilin=p%3Dt' \
    --data-raw '{
        "email": "valid_example@example.com",
        "password": "12345678",
        "password_confirmation": "12345678"
    }'
```

Same for /login, but without password_confirmation.

**Both endpoints will return the user jwt that are needed to reach users/me.**

- Once signup/login is successful, the response to those endpoints will include a user valid jwt that must be provided to authenticate.

```
curl --location --request GET 'http://localhost:3000/api/v1/users/me' \
--header 'Authentication: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMmZiY2Y4MS00NWM2LTQ4YTMtYTAxOC01N2M3MmM5OTY4ODMiLCJleHAiOjE2MjY4NzM2MjV9.3s6FZwkxobHcYNWnw-91SdJEnq_AoOlbl1V2lbn0-Ns' \
--header 'Cookie: __profilin=p%3Dt' \
--data-raw ''
```

## Updating datasets


  1. Using individual rake tasks that starts async jobs: need to be run in the correct order:
    ```
    bundle exec rails groups:import_csv_async file_path="public/to_upload/groups/"

    bundle exec rails widgets:import_json_async file_path="public/to_upload/widgets/"

    bundle exec rails geometries:points:import_geojson_async file_path="public/to_upload/geometries/points/"
    
    bundle exec rails geometries:polygons:import_geojson_async file_path="public/to_upload/geometries/polygons/"

    bundle exec rails sankeys:import_json_async file_path="/var/www/gefc_api/current/public/to_upload/sankey/"
    ```

    OR using a combo rake task
    `groups_file_path="public/to_upload/groups/" widgets_file_path="public/to_upload/widgets/" points_file_path="public/to_upload/geometries/points/" polygons_file_path="public/to_upload/geometries/polygons/" sankeys_file_path="/var/www/gefc_api/current/public/to_upload/sankey/" bundle exec rake import:all`

  2. Then we need to run some fixing tasks:
    ```
    import:populate_extra_info_async

For running the rake tasks on staging, you need to:
  - be able to ssh to the staging server
    `ssh [user]@[server]` (check config/deploy/staging.rb for server address, your SSH key needs to be allowed on the server)
  - upload your files to the staging server, e.g. using `scp`
    `scp socioecon_widgets_2306.csv [user]@[server]:/var/www/gefc_api/current`
  - navigate to the application directory on the server
    `cd /var/www/gefc_api/current`
  - run the tasks prepending `RAILS_ENV=staging`
    e.g. `RAILS_ENV=staging file_name=socioecon_widgets_2306.csv bundle exec rake groups:import_csv`


* Services (job queues, cache servers, search engines, etc.)

Sidekiq is used for background jobs (mostly data import.) In development you start it:
`bundle exec sidekiq`

* Deployment instructions
Remember to update `.env` if needed and then `cap staging deploy`.
