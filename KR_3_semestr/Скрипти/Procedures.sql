-- Процедура, що повідомляє абітурієнта чи був він зарахований, та при ствердній відповіді надає більш детальну інформацію. Вхідні параметри: abit_id - ІД абітурієнта
CREATE OR REPLACE PROCEDURE is_enroled(IN abit_id INTEGER)
AS $$
	DECLARE
		enrol INTEGER := get_id_enrolled_abit(abit_id);
		specialty_id INTEGER;
		department_name VARCHAR;
		faculty_name VARCHAR;
		course INTEGER;
		score "numeric"(6, 3);
		priorities INTEGER;
	BEGIN
		IF (enrol IS NOT NULL) THEN
			SELECT statements.id_specialty, department.department_name, faculty.full_name, statements.course, statements.score, statements.priorities
			FROM statements, department_priority, department, faculty
			WHERE statements."id" = enrol AND
						statements."id" = department_priority.id_statement AND
						department_priority.id_department = department."id" AND
						department.id_faculty = faculty."id"
			INTO specialty_id, department_name, faculty_name, course, score, priorities;
			
			IF (priorities IS NULL) THEN
				RAISE NOTICE 'Вас було зараховано на спеціальність %, %, %, на % курс із балом % на контрактну форму навчання. Очікуйте на лист від приймальної комісії та публікації наказу про зарахування.', specialty_id, department_name, faculty_name, course, score;
			ELSE
				RAISE NOTICE 'Вас було зараховано на спеціальність %, %, %, на % курс із балом % по %-му пріоритету на бюджетну форму навчання. Очікуйте на лист від приймальної комісії та публікації наказу про зарахування.', specialty_id, department_name, faculty_name, course, score, priorities;
			END IF;
		ELSE
			RAISE NOTICE 'Вас ще не було зараховано';
		END IF;
	END;
$$ LANGUAGE plpgsql;

CALL is_enroled(9);
CALL is_enroled(8);
CALL is_enroled(5);



-- Процедура, що повідомляє користувача чи отримуватиме він стипендію при умові, що він був зарахований. Вхідні параметри: abit_id - ІД абітурієнта
CREATE OR REPLACE PROCEDURE is_scholarship(IN abit_id INTEGER)
AS $$
	DECLARE
		enrol INTEGER := get_id_enrolled_abit(abit_id);
		schollarship BOOLEAN;
	BEGIN
		IF (enrol IS NOT NULL) THEN
			SELECT enrolled_abiturient.scholarship
			FROM enrolled_abiturient
			WHERE enrolled_abiturient.id_statement = enrol
			INTO schollarship;
			
			IF (schollarship) THEN 
				RAISE NOTICE 'Ви отримуватимете стипендію';
			ELSE
				RAISE NOTICE 'Ви НЕ отримуватимете стипендію';
			END IF;
		ELSE
			RAISE NOTICE 'Вас ще не було зараховано';
		END IF;
	END;
$$ LANGUAGE plpgsql;

CALL is_scholarship(9);
CALL is_scholarship(5);
CALL is_scholarship(3);



-- Процедура, що дає можливість сформувати наказ про зарахування абітурієнтів на певний факультет. Вхідні параметри: department_id - ІД факультета
CREATE OR REPLACE PROCEDURE formation_of_order(department_id INTEGER) AS $$
	DECLARE
		abit_name VARCHAR;
		abit_surname VARCHAR;
		abit_fathername VARCHAR;
		res TEXT := E'\n';
	BEGIN	
		FOR abit_surname, abit_name, abit_fathername IN 
		SELECT abiturient.first_name, abiturient.last_name, abiturient.fathers_name
		FROM enrolled_abiturient, statements, abiturient, department_priority, department
		WHERE enrolled_abiturient.id_statement = statements."id" AND
					statements.id_abiturient = abiturient."id" AND
					enrolled_abiturient.id_statement = department_priority."id" AND
					department_priority.id_department = department."id" AND
					abiturient.is_conditions AND 
					department_priority.id_department = department_id
		ORDER BY abiturient.first_name, abiturient.fathers_name
		LOOP
			res := concat(res, abit_surname, ' ', abit_name, ' ', abit_fathername, E'\n');
		END LOOP;
		RAISE NOTICE 'Зарахувати на % наступних абітурієнтів:%', department.department_name FROM department WHERE department."id" = department_id, left(res, -1);
	END;
$$ LANGUAGE plpgsql;

CALL formation_of_order(2);



-- Процедура яка зараховує абітурієнта по заяві, якщо його не було зараховано до цього
CREATE OR REPLACE PROCEDURE enroll_abit(IN statement_id INTEGER, IN schoolarship BOOLEAN DEFAULT(FALSE)) AS $$
BEGIN
		IF EXISTS(SELECT *
							FROM enrolled_abiturient
							WHERE enrolled_abiturient.id_statement = statement_id)
		THEN
			RAISE NOTICE 'Абітурієнта за даною заявою вже було зараховано';
		ELSE
			IF NOT EXISTS(SELECT *
										FROM enrolled_abiturient, statements
										WHERE enrolled_abiturient.id_statement = statements."id" AND
													statements.id_abiturient = (SELECT statements.id_abiturient
																											FROM statements
																											WHERE statements."id" = statement_id))
			THEN
				INSERT INTO enrolled_abiturient (id_statement, scholarship) VALUES
				(statement_id, schoolarship);
				RAISE NOTICE 'Задану заяву було успішно зараховано';
			ELSE
				RAISE NOTICE 'Заданого абітурієнта вже було зараховано за іншою заявою';
			END IF;
		END IF;
	END;
$$ LANGUAGE plpgsql;

CALL enroll_abit(7);
CALL enroll_abit(10);
CALL enroll_abit(8);