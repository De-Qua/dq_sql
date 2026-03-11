# dq_sql
Magical real-time suggestions ready for you.

Now also the `getNearby..` family of functions is available.

Just run `sh create_functions.sh` and all functions will be added (I hope)

## The magical `INDEX`
To optimize queries, you can create the index. For example, the `getNearbyStreets` function works much faster (~10x in our quick experiments) after creating the relative index, with:

``` SQL
CREATE INDEX ON public.street using gist (shape);
```

We are still studying whether it makes sense to create other indices on other tables.
We created also on locations (`CREATE INDEX ON public.location using gist (shape);`) but it did not help much on the `getNearbyAddresses` function.