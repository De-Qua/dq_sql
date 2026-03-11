# dq_sql

Magical real-time suggestions ready for you.

Now also the `getNearby..` family of functions is available.

Just run `sh create_functions.sh` and all functions will be added (I hope)

## Set up the Database

To start a freshly new database:

1. Start the postgres container 
```
docker compose up -d
```
It will automatically create the databases with postgis extensions in some of them

2. From the main flask folder run the alembic upgrade
```
flask db upgrade
```
It will create all the tables and relationships

3. From the db folder restore all the data
```
./restore_data.sh
```
It will restore all the data

If you want to dump all the data it is necessary to dump with the `data-only` flag! Otherwise there are problems with alembic since it will delete and recreate all the tables!
If you want you can run the script
```
./backup_data.sh
```
which will dump all the data of the different databases in the folder `db_dump`!

Evviva!


## The magical `INDEX`
To optimize queries, you can create the index. For example, the `getNearbyStreets` function works much faster (~10x in our quick experiments) after creating the relative index, with:

``` SQL
CREATE INDEX ON public.street using gist (shape);
```

We are still studying whether it makes sense to create other indices on other tables.
We created also on locations (`CREATE INDEX ON public.location using gist (shape);`) but it did not help much on the `getNearbyAddresses` function.