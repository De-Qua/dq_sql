CREATE OR REPLACE FUNCTION public.fn_getsuggest_address(searchstring character varying, top integer)
 RETURNS TABLE(resulttype text, address_street character varying, address_neigh character varying, housenumber character varying, latitude double precision, longitude double precision)
 LANGUAGE plpgsql
AS $function$
	begin
		if searchstring similar to '%[0-9]%'
		then return query select
			'address' resulttype,
			a.address_street, 
			a.address_neigh, 
			a.housenumber, 
			l.latitude,
			l.longitude
			from address a
			inner join location l on l.id  = a.location_id		
			where 
			--a.address_neigh ilike (searchstring || '%')
			--or 
			(a.address_neigh || ' ' || a.housenumber) ilike ('%' || searchstring || '%')
			or (a.housenumber || ' ' || a.address_neigh) ilike ('%' || searchstring || '%')
			or (a.address_street || ' ' || a.housenumber) ilike ('%' || searchstring || '%')
			order by a.address_neigh, a.housenumber_num , a.address_street		
			limit (top);
		end if;
	END;
$function$
;
