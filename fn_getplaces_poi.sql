CREATE OR REPLACE FUNCTION public.fn_getplaces_poi(searchstring character varying, top integer)
 RETURNS TABLE(resulttype text, address_street character varying, address_neigh character varying, housenumber character varying, latitude double precision, longitude double precision, poiname character varying, poicategoryname character varying[], opening_hours character varying, wheelchair character varying, toilets boolean, toilets_wheelchair boolean, wikipedia character varying, phone character varying, sim real)
 LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select 
			a1.resulttype
			,a1.address_street		
			,a1.address_neigh
			,a1.housenumber
			,a1.latitude
			,a1.longitude
			,a1.poiname
			,array_agg(a1.poicategoryname)  as poicategoryname
--			,string_agg(poicategoryname,',' order by poicategoryname)  as poicategoryname
			,a1.opening_hours
			,a1.wheelchair
			,a1.toilets
			,a1.toilets_wheelchair
			,a1.wikipedia
			,a1.phone
			,a1.sim
			from (	
				select
						'poi' resulttype,
						a.address_street, 
						a.address_neigh, 
						a.housenumber, 
						l.latitude,
						l.longitude,
						p."name" as poiname,
						pct."name" as poicategoryname,
						p.opening_hours ,
						p.wheelchair ,
						p.toilets,
						p.toilets_wheelchair ,
						p.wikipedia ,
						p.phone,
						greatest(0, fn_dequa_similarity(p."name", searchstring), fn_dequa_similarity(p.name_alt, searchstring)) as sim
						from poi p		
						inner join poi_types pt on pt.poi_id = p.id 
						inner join poi_category_type pct on pt.type_id = pct.id
						inner join location l on l.id  = p.location_id		
						left outer join address a on a.location_id = p.location_id 
						--SIMILARITY(a.address_neigh || ' ' || a.housenumber, searchstring) as sim_neigh
						--SIMILARITY(a.address_street, searchstring) as sim_str
						--where sim is not null 
						--p."name" ilike ('%' || searchstring || '%')
						--or p.name_alt ilike ('%' || searchstring || '%')
						--or (a.address_neigh || ' ' || a.housenumber) ilike (searchstring || '%')
						--or a.address_street ilike (searchstring || '%')
					
			) as  a1
			group by 
			a1.resulttype
			,a1.address_street		
			,a1.address_neigh
			,a1.housenumber
			,a1.latitude
			,a1.longitude
			,a1.poiname
			,a1.opening_hours
			,a1.wheelchair
			,a1.toilets
			,a1.toilets_wheelchair
			,a1.wikipedia
			,a1.phone
			,a1.sim
			order by a1.sim desc
			--max(a1.sim, a1.sim_alt) as sim_best
		limit (TOP);
	END;
$function$
;
