CREATE OR REPLACE FUNCTION public.fn_getplaces_street(searchstring character varying, top integer)
 RETURNS TABLE(resulttype text, street_name character varying, name_alt character varying, name_spe character varying, name_den character varying, shape geometry, latitude double precision, longitude double precision, sim real)
 LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select
		'street' resulttype,
		s."name" as street_name,
		s.name_alt,
		s.name_spe,
		s.name_den,
		s.shape,
		ST_Y(ST_CENTROID(s.shape)) as latitude,
		ST_X(ST_CENTROID(s.shape)) as longitude,
		--ST_CENTROID(s.shape).y as longitude,
		greatest(
			0, 
			fn_dequa_similarity(s."name", searchstring), 
			fn_dequa_similarity(s.name_alt, searchstring),
			fn_dequa_similarity(s.name_den, searchstring)
			) as sim
		from street s
		--where 
		--a.address_neigh ilike (searchstring || '%')
		--or 
		--(a.address_neigh || ' ' || a.housenumber) ilike (searchstring || '%')
		--or a.address_street ilike (searchstring || '%')
		order by sim desc
		limit (top);
	END;
$function$
;
