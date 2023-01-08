ALTER TABLE zno_list
ADD CONSTRAINT zno_list_min_score
CHECK(zno_list.min_score BETWEEN 100 AND 200);

ALTER TABLE abiturient
ADD CONSTRAINT abiturient_phone_number
CHECK(abiturient.phone_number BETWEEN 100000000000 AND 999999999999),
ADD CONSTRAINT abiturient_score
CHECK(abiturient.certificate_score BETWEEN 100 AND 200),
ADD CONSTRAINT abiturient_age
CHECK(EXTRACT(YEAR FROM AGE(CURRENT_DATE, DATE '2005-11-22')) > 15);

ALTER TABLE faculty
ADD CONSTRAINT faculty_phone_number
CHECK(faculty.phone_number BETWEEN 100000000000 AND 999999999999);

ALTER TABLE zno_result
ADD CONSTRAINT zno_result_result
CHECK(zno_result.result BETWEEN 100 AND 200);

ALTER TABLE statements
ADD CONSTRAINT statements_score
CHECK(statements.score BETWEEN 100 AND 200);

ALTER TABLE department
ADD CONSTRAINT department_phone_number
CHECK(department.phone_number BETWEEN 100000000000 AND 999999999999);