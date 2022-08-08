# README
Imagine you have a piece of old code that needs to be fixed.
There is a service in your application. It is designed to export payments from the database to a set of CSV files. It also adds some logging records to the database.

Although the service works - it has some problems.
It was created a long time ago and, for some reason, doesn't have any tests.
Another problem - when there are many payments to export, the service runs for 2 hours and then kills the server without finishing.

## The challenge
You need to write tests and then refactor the service to make it process more data. Also, feel free to fix everything you find wrong!

## TEST
The test are very important part of the project, after write the test it give me confidence to start the refactoring process

To run the unit test:

```
rspec
```

## Refactor
First Step:

read the code to understand what is doing and see if the name of the methos and variables, have sence
 -I change the name of some methods and also delete one method that does not have sense like update_contract,
there is no need to update an contract ( we are exporting payments not contracts).
also change generate_export_csv to csv_data method and biceversa.

Second Step:

After complete the test suit, I focus on benchmark what was the slowest process and i found that
the payments update is the slowest one, I decide use in_batches.update_all(exported_at: @exported_at)
in order to avoid all the callbacks and make it faster again the test give me confidence to do it.
I decide to edit the query for ready_to_export payments to include unproccesed payemnts because
and remove if clausule in the generate_export_csv, after that all the ralted process with @payments get faster

Benchmarking:

after some testing, I realiza that was posssible to make the code x7 faster.


Last Step:

Implement a Reque job in order to process the PaymentsExportService as a backgroupd job

## Setup

To setup up the application, please do the following:
```
bin/rails db:drop db:create db:migrate
bin/rails db < refactoring_development.sql
```

## Run Job PaymentsExportService
Please install Redis and start it!!

https://redis.io/docs/getting-started/installation/

exmaple for Mac:
Install
```
brew install redis
```

Start redis
```
brew services start redis
```

To Enqueue a PaymentExportJob
```
Resque.enqueue(PaymentExportJob, Agent.fir
st.id, 'Company_4', 'my_export_type')
```

Start a Worker
```
QUEUE=payments_export rake resque:work
```

To check what Workers and Queue are doing, from the root folder start ``` resque-web```

```
resque-web -p 8282 config/initializers/resque.rb
```


