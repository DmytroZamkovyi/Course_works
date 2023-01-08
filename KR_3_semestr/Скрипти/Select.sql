-- Мінімальний бал по предметам
SELECT zno_result.id_subject, MIN(zno_result."result")
FROM zno_result
GROUP BY zno_result.id_subject
ORDER BY zno_result.id_subject;

-- Максимальний бал по предметам
SELECT zno_result.id_subject, MAX(zno_result."result")
FROM zno_result
GROUP BY zno_result.id_subject
ORDER BY zno_result.id_subject;

-- Середній бал по предметам
SELECT zno_result.id_subject, AVG(zno_result."result")
FROM zno_result
GROUP BY zno_result.id_subject
ORDER BY zno_result.id_subject;

-- Витягнути всі паспорта
SELECT *
FROM "document"
WHERE "document".short_description = 'Паспорт';

-- Всі кафедри та відповідні їм факультети
SELECT faculty.full_name, faculty.short_name, department.department_name
FROM department, faculty
WHERE department.id_faculty = faculty."id"
ORDER BY faculty.full_name;

-- Всі результати атестатів по абітурієнтам
SELECT abiturient."id", abiturient.certificate_score
FROM abiturient
ORDER BY abiturient."id";

-- Кількість поданих заяв на різні курси
SELECT statements.course, COUNT(statements.course)
FROM statements
GROUP BY statements.course;

-- "Популярність" спеціальностей по поданим заявам
SELECT statements.id_specialty, COUNT(statements.id_specialty)
FROM statements
GROUP BY statements.id_specialty
ORDER BY count DESC, statements.id_specialty;

-- Вибірірка ПІБ абітурієнта, предмет та результат ЗНО по цьому предмету
SELECT ROW_NUMBER() over(ORDER BY(abiturient."id")), concat(abiturient.first_name, ' ', abiturient.last_name, ' ', abiturient.fathers_name) AS "ПІБ", zno_list.subject_name, zno_result."result"
FROM zno_result, abiturient, zno_list
WHERE zno_result.id_abiturient = abiturient."id" AND
			zno_result.id_subject = zno_list."id";

-- Вибірка всіх документів по студентам
SELECT "document"."id", concat(abiturient.first_name, ' ', abiturient.last_name, ' ', abiturient.fathers_name), "document".short_description, "document".document_url
FROM "document", abiturient
WHERE "document".id_abiturient = abiturient."id";

-- Вибірка всіх даних для зворотнього зв'язку із студентами
SELECT abiturient.first_name, abiturient.last_name, abiturient.fathers_name, abiturient.email, '+' || abiturient.phone_number AS "phone_number"
		FROM statements, abiturient
		WHERE statements.id_abiturient = abiturient."id";

-- "Популярність" кафедр
SELECT department.department_name, COUNT(department_priority.id_department)
FROM department_priority, department, statements
WHERE department_priority.id_statement = statements."id" AND
			department."id" = department_priority.id_department
GROUP BY department.department_name
ORDER BY count DESC;

-- "Популярність" факультетів
SELECT faculty.full_name, COUNT(faculty.full_name)
FROM department_priority, department, statements, faculty
WHERE department_priority.id_statement = statements."id" AND
			department."id" = department_priority.id_department AND
			faculty."id" = department.id_faculty
GROUP BY faculty.full_name
ORDER BY count DESC;

-- Кількість людей, які склали даний предмет на прохідний бал
SELECT zno_list.subject_name, COUNT(zno_list.subject_name)
FROM zno_result, zno_list
WHERE zno_list."id" = zno_result.id_subject AND
			zno_result."result" > zno_list.min_score
GROUP BY zno_list.subject_name;

-- "Популярність" предметів ЗНО
SELECT zno_list.subject_name, COUNT(zno_list.subject_name)
FROM zno_result, zno_list
WHERE zno_list."id" = zno_result.id_subject
GROUP BY zno_list.subject_name
ORDER BY count DESC;

-- Рейтинг студентів які отримують стипендію
SELECT concat(abiturient.first_name, ' ', abiturient.last_name, ' ', abiturient.fathers_name), statements.score
FROM enrolled_abiturient, statements, abiturient
WHERE enrolled_abiturient.id_statement = statements."id" AND
			abiturient."id" = statements.id_abiturient AND
			enrolled_abiturient.scholarship
ORDER BY statements.score DESC;

-- Предмет і кількість людей, які "завалили" його
SELECT zno_list.subject_name, COUNT(zno_list.subject_name)
FROM zno_result, zno_list
WHERE zno_list."id" = zno_result.id_subject AND
			NOT zno_result."result" > zno_list.min_score
GROUP BY zno_list.subject_name;

-- Інформація про зарахованих абітурієнтів
SELECT statements."id", concat(abiturient.first_name, ' ', abiturient.last_name, ' ', abiturient.fathers_name) AS "ПІБ", abiturient.certificate_score, specialty.specialty_name, statements.priorities, statements.score, statements.course
FROM statements, abiturient, specialty, enrolled_abiturient
WHERE statements.id_abiturient = abiturient."id" AND
			statements.id_specialty = specialty."id" AND 
			enrolled_abiturient.id_statement = statements."id"
ORDER BY statements.course, statements.priorities, statements.score, abiturient.certificate_score;

-- "Популярність" кафедр серед зарахованих абітурієнтів
SELECT specialty."id", specialty.specialty_name, COUNT(specialty.specialty_name)
FROM enrolled_abiturient, statements, abiturient, specialty
WHERE enrolled_abiturient.id_statement = statements."id" AND
			statements.id_abiturient = abiturient."id" AND
			statements.id_specialty = specialty."id"
GROUP BY specialty."id", specialty.specialty_name
ORDER BY count DESC;

-- Абітурієнт та відповідний йому середній бал ЗНО та середній бал атестату
SELECT concat(abiturient.first_name, ' ', abiturient.last_name, ' ', abiturient.fathers_name) AS "ПІБ", abit.certificate_score, abit.zno_res
FROM (SELECT abiturient."id", abiturient.certificate_score, AVG(zno_result."result") AS zno_res
			FROM abiturient, zno_list, zno_result
			WHERE zno_list."id" = zno_result.id_subject AND
						zno_result.id_abiturient = abiturient."id"
			GROUP BY abiturient."id", abiturient.certificate_score) AS abit, abiturient
WHERE abit."id" = abiturient."id";