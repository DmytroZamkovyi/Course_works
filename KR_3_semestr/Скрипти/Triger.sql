-- Тригер на генерацію повідомлення про зарахування абітурієнта
CREATE OR REPLACE FUNCTION add_enroll_abit() RETURNS TRIGGER
AS $$
	DECLARE
		abit_name VARCHAR;
		abit_lastname VARCHAR;
		abit_fathername VARCHAR;
		abit_email VARCHAR;
	BEGIN
		SELECT abiturient.first_name, abiturient.last_name, abiturient.fathers_name, abiturient.email
		FROM statements, abiturient
		WHERE statements.id_abiturient = abiturient."id" AND
					statements."id" = NEW.id_statement
		INTO abit_name, abit_lastname, abit_fathername, abit_email;
		
		RAISE NOTICE '
 			Новий абітурієнт
 			ПІБ: %
 			Пошта: %
			', concat(abit_name, ' ', abit_lastname, ' ', abit_fathername), abit_email;
		
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER add_enroll_abit_trigger
	AFTER INSERT
	ON enrolled_abiturient
	FOR EACH ROW
EXECUTE FUNCTION add_enroll_abit();



-- Тригер, що генерує текст для стороннього сервісу по відправці листа абітурієнту
CREATE OR REPLACE FUNCTION generate_letter_enroll_abit() RETURNS TRIGGER
AS $$
	DECLARE
		abit_name VARCHAR;
		abit_lastname VARCHAR;
		abit_fathername VARCHAR;
		abit_email VARCHAR;
		abit_course INTEGER;
		depart VARCHAR;
		facult VARCHAR;
		abit_score "numeric"(6, 3);
	BEGIN
		SELECT abiturient.first_name, abiturient.last_name, abiturient.fathers_name, abiturient.email
		FROM statements, abiturient
		WHERE statements.id_abiturient = abiturient."id" AND
					statements."id" = NEW.id_statement
		INTO abit_name, abit_lastname, abit_fathername, abit_email;
		
		SELECT statements.course, department.department_name, faculty.short_name, statements.score
		FROM statements, department_priority, faculty, department
		WHERE department_priority.id_department = department."id" AND
					department_priority.id_statement = statements."id" AND
					department.id_faculty = faculty."id" AND
					statements."id" = NEW.id_statement
		INTO abit_course, depart, facult, abit_score;
		
		RAISE NOTICE E'SEND LETTER;\nsend_to=%;\ntext="Шановний(на) %\\nВас зараховано на %, %, % із вступним балом %. Вам потрібно буде з*явитися в деканаті протігом тижня з дня надходження цього листа для підписання документів.\\n\\nЗ повагою, Деканат";
			', abit_email, concat(abit_name, ' ', abit_lastname, ' ', abit_fathername), abit_course, depart, facult, abit_score;
		
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER generate_letter_enroll_abit_trigger
	AFTER INSERT
	ON enrolled_abiturient
	FOR EACH ROW
EXECUTE FUNCTION generate_letter_enroll_abit();