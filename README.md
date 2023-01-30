 
# Weather API
Test task for Middle Ruby on Rails Developer position 

## Technologies

Rails 6+, Grape, Rufus, RSpec, VCR, Swagger, Docker, Postman

Third-party API - https://developer.accuweather.com/apis.

## Run Locally  

Clone the project  

~~~bash  
git clone git@github.com:muromski/weather_api.git
~~~

Go to the project directory  

~~~bash  
cd weather_api
~~~

Rename `.env.example` file to `.env`

You should have credentials to become an access to third-party API. You can get your own API_KEY after registration https://developer.accuweather.com/


Build docker-compose  

~~~bash  
docker-compose build app
~~~

Run docker-compose 
~~~bash  
docker-compose up -d
~~~

Run tests
~~~bash  
docker-compose exec app bin/rails spec
~~~

![screenshot](https://i.ibb.co/c6pnfsC/2023-01-30-04-10-47.png)


RPS metrics are located in the `metrics` folder

The Postman collection for API testing is located at the root of the project

