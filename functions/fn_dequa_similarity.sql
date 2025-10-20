CREATE OR REPLACE FUNCTION public.fn_dequa_similarity(text_set character varying, searchstring character varying)
 RETURNS real
 LANGUAGE plpgsql
AS $function$
	begin
		return
		SIMILARITY(text_set, searchstring);
		--word_similarity(text_set, searchstring);
	END;
$function$
;
