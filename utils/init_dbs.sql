-- Create all databases
CREATE DATABASE opendata_ve_pg;
CREATE DATABASE dequa_config_data;
CREATE DATABASE dequa_collected_data;
CREATE DATABASE dequa_internal;
CREATE DATABASE dequa_geotag;
CREATE DATABASE dequa_data_versions;

-- Enable PostGIS on specific databases
\connect opendata_ve_pg;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
\i /functions/fn_dequa_similarity.sql
\i /functions/fn_getplaces_address.sql
\i /functions/fn_getplaces_neighborhood.sql
\i /functions/fn_getplaces_poi.sql
\i /functions/fn_getplaces.sql
\i /functions/fn_getplaces_street.sql
\i /functions/fn_getsuggest_address.sql
\i /functions/fn_getsuggest_neighborhood.sql
\i /functions/fn_getsuggest_poi2.sql
\i /functions/fn_getsuggest_poi.sql
\i /functions/fn_getsuggest.sql
\i /functions/fn_getsuggest_street.sql
\i /functions/fn_getsuggest_test.sql

\connect dequa_geotag;
CREATE EXTENSION IF NOT EXISTS postgis;