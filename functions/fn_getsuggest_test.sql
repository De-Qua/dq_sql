CREATE OR REPLACE FUNCTION public.fn_getsuggest_test(searchstring character varying, top integer)
 RETURNS TABLE(resulttype text, latitude double precision, longitude double precision, shape geometry, street character varying, neighborhood character varying, housenumber character varying, poiname character varying, poicategoryname character varying[], opening_hours character varying, wheelchair character varying, toilets boolean, toilets_wheelchair boolean, wikipedia character varying, phone character varying)
 LANGUAGE plpgsql
AS $function$
	begin
		return query
		
		select
			n.resulttype
			,st_y(st_centroid(n.shape)) as latitude
			,st_x(st_centroid(n.shape)) as longitude
			,n.shape
			,null::character varying as street
			,n.neig_name as neighborhood
			,null::character varying as housenumber
			,null::character varying as poiname
			,null::character varying[] as poicategoryname
		--			,string_agg(poicategoryname,',' order by poicategoryname)  as poicategoryname
			,null::character varying as opening_hours
			,null::character varying as wheelchair
			,null::boolean as toilets
			,null::boolean as toilets_wheelchair
			,null::character varying as wikipedia
			,null::character varying as phone
		from fn_getsuggest_neighborhood(searchstring, top) as n
		
		union all
		
		select
			s.resulttype
			,st_y(st_centroid(s.shape)) as latitude
			,st_x(st_centroid(s.shape)) as longitude
			,s.shape
			,s.str_name as street
			,s.str_neig as neighborhood
			,null as housenumber
			,null as poiname
			,null as poicategoryname
	--			,string_agg(poicategoryname,',' order by poicategoryname)  as poicategoryname
			,null as opening_hours
			,null as wheelchair
			,null as toilets
			,null as toilets_wheelchair
			,null as wikipedia
			,null as phone
		from fn_getsuggest_street(searchstring, top) as s
		
		union all
		
		select 
			a.resulttype
			,a.latitude
			,a.longitude
			,st_point(a.latitude, a.longitude)
			,a.address_street as street
			,a.address_neigh as neighborhood
			,a.housenumber
			,null as poiname
			,null as poicategoryname
	--			,string_agg(poicategoryname,',' order by poicategoryname)  as poicategoryname
			,null as opening_hours
			,null as wheelchair
			,null as toilets
			,null as toilets_wheelchair
			,null as wikipedia
			,null as phone
		from fn_getsuggest_address(searchstring,top) as a
		
		union all 
		
		select
			p.resulttype
			,p.latitude
			,p.longitude
			,st_point(p.latitude, p.longitude)
			,p.address_street as street
			,p.address_neigh as neighborhood
			,p.housenumber
			,p.poiname
			,p.poicategoryname
			,p.opening_hours
			,p.wheelchair
			,p.toilets
			,p.toilets_wheelchair
			,p.wikipedia
			,p.phone
		
		from fn_getsuggest_poi(searchstring,top) as p;

	END;
$function$
;
