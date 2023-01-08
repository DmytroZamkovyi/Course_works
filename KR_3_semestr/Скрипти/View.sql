-- Представлення короткої інформації про подані заяви
CREATE OR REPLACE VIEW statements_info AS
	SELECT statements."id", abiturient.first_name, abiturient.last_name, abiturient.certificate_score, specialty.specialty_name, statements.priorities, statements.score, statements.course
	FROM statements, abiturient, specialty
	WHERE statements.id_abiturient = abiturient."id" AND
				statements.id_specialty = specialty."id"
	ORDER BY statements.course, statements.priorities, statements.score, abiturient.certificate_score;

SELECT * FROM statements_info;



--- Представлення повної інформації про всі подані заяви
CREATE OR REPLACE VIEW statements_full_info AS
	SELECT department_priority."id", statements_info.first_name, statements_info.last_name, faculty.short_name, department.department_name, statements_info.specialty_name, statements_info.certificate_score, statements_info.priorities, statements_info.score, statements_info.course, department_priority.priorities AS department_priority
	FROM department_priority, department, faculty, statements_info
	WHERE department_priority.id_department = department."id" AND
				department.id_faculty = faculty."id" AND
				department_priority.id_statement = statements_info."id"
	ORDER BY statements_info.first_name, statements_info.last_name, statements_info.priorities, department_priority, department_priority."id";

SELECT * FROM statements_full_info;