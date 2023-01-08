-- Функція, що повертає ІД заяви, по якій було зараховано абітурієнта або NULL. Вхідні параметри: abit_id - ІД абітурієнта
CREATE OR REPLACE FUNCTION get_id_enrolled_abit(abit_id INTEGER)
RETURNS INTEGER
AS $$
	DECLARE
		enrol INTEGER;
	BEGIN
		SELECT enrolled_abiturient.id_statement 
		FROM enrolled_abiturient 
		WHERE enrolled_abiturient.id_statement IN (
			SELECT statements."id"
			FROM statements
			WHERE statements.id_abiturient = abit_id)
		INTO enrol;
		
		RETURN enrol;
	END;
$$ LANGUAGE plpgsql;

SELECT get_id_enrolled_abit(9) AS "ІД зарахованої заяви 9 абітурієнта";
SELECT get_id_enrolled_abit(5) AS "ІД зарахованої заяви 5 абітурієнта";



-- Функція, що повертає інформацію про всі подані заяви абітурієнтом. Вхідні параметри: abit_id - ІД абітурієнта
CREATE OR REPLACE FUNCTION get_statements(abit_id INTEGER)
RETURNS TABLE(
	specialty INTEGER,
	prioritet SMALLINT,
	score "numeric"(6, 3),
	course SMALLINT)
AS $$
	BEGIN
		RETURN query
			SELECT statements.id_specialty, statements.priorities, statements.score, statements.course
			FROM statements
			WHERE statements.id_abiturient = abit_id
			ORDER BY statements.priorities;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_statements(3);