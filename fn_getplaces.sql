CREATE OR REPLACE FUNCTION public.fn_getplaces(searchstring character varying, top integer)
 RETURNS TABLE(resulttype text, sim real, latitude double precision, longitude double precision, shape geometry, address_street character varying, address_neigh character varying, housenumber character varying, poiname character varying, poicategoryname character varying[], opening_hours character varying, wheelchair character varying, toilets boolean, toilets_wheelchair boolean, wikipedia character varying, phone character varying, street_name text, name_alt text, name_spe text, name_den text, neighborhood_name text, zipcode integer)
 LANGUAGE plpgsql
AS $function$
	BEGIN
		return query
		select 
		a.resulttype
		,a.sim
		,a.latitude
		,a.longitude
		,st_point(a.latitude, a.longitude)
		,a.address_street		
		,a.address_neigh
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
		,null as street_name
		,null as name_alt
		,null as name_spe
		,null as name_den
		,null as neighborhood_name
		,null::int as zipcode
		from fn_getplaces_address(searchstring,top) as a
		
		union all 
		
		select
			p.resulttype
			,p.sim
			,p.latitude
			,p.longitude
			,st_point(p.latitude, p.longitude) 
			,p.address_street		
			,p.address_neigh
			,p.housenumber
			,p.poiname
			,p.poicategoryname
			,p.opening_hours
			,p.wheelchair
			,p.toilets
			,p.toilets_wheelchair
			,p.wikipedia
			,p.phone
			,null as street_name
			,null as name_alt
			,null as name_spe
			,null as name_den
			,null as neighborhood_name
			,null::int as zipcode
		
		from fn_getplaces_poi(searchstring,top) as p
		
		union all 
		
		select
			s.resulttype
			,s.sim
			,s.latitude
			,s.longitude
			,s.shape
			,null as address_street		
			,null as address_neigh
			,null as housenumber
			,null as poiname
			,null as poicategoryname
			,null as opening_hours
			,null as wheelchair
			,null as toilets
			,null as toilets_wheelchair
			,null as wikipedia
			,null as phone
			,s.street_name
			,s.name_alt
			,s.name_spe
			,s.name_den
			,null as neighborhood_name
			,null::int as zipcode
		
		from fn_getplaces_street(searchstring,top) as s
		
		union all 
		
		select
			n.resulttype
			,n.sim
			,n.latitude
			,n.longitude
			,n.shape
			,null as address_street		
			,null as address_neigh
			,null as housenumber
			,null as poiname
			,null as poicategoryname
			,null as opening_hours
			,null as wheelchair
			,null as toilets
			,null as toilets_wheelchair
			,null as wikipedia
			,null as phone
			,null as street_name
			,null as name_alt
			,null as name_spe
			,null as name_den
			,n.neighborhood_name
			,n.zipcode
		
		from fn_getplaces_neighborhood(searchstring,top) as n
	
		order by sim desc
		limit (top);
	END;
$function$
;
