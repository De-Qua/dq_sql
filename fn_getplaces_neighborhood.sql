CREATE OR REPLACE FUNCTION public.fn_getplaces_neighborhood(searchstring character varying, top integer)
 RETURNS TABLE(resulttype text, neighborhood_name character varying, zipcode integer, shape geometry, latitude double precision, longitude double precision, sim real)
 LANGUAGE plpgsql
AS $function$
	BEGIN
		return query select
		'neighborhood' resulttype,
		n."name" as neighborhood_name,
		n.zipcode,
		n.shape,
		ST_Y(ST_CENTROID(n.shape)) as latitude,
		ST_X(ST_CENTROID(n.shape)) as longitude,
		--ST_CENTROID(s.shape).y as longitude,
		greatest(
			0, 
			fn_dequa_similarity(n."name", searchstring) 
			--fn_dequa_similarity(n.zipcode, searchstring)
			) as sim
		from neighborhood n
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
