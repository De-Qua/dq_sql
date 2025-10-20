CREATE OR REPLACE FUNCTION public.fn_getsuggest_neighborhood(searchstring character varying, top integer)
 RETURNS TABLE(resulttype text, neig_name character varying, shape geometry)
 LANGUAGE plpgsql
AS $function$
	begin
		return query select 
		'neighborhood' resulttype
		,n."name" as neig_name
		,n.shape as shape
	from
		neighborhood n
	where
		n."name" ilike ('%' || searchstring || '%')
	limit(top);

end;

$function$
;
