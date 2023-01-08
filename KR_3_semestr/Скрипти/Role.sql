CREATE ROLE abiturient NOLOGIN;

GRANT INSERT ON abiturient, "document", department_priority, statements, zno_result TO abiturient;
GRANT SELECT ON statements, department_priority, department, faculty, enrolled_abiturient TO abiturient;

GRANT EXECUTE ON PROCEDURE is_enroled(INTEGER) TO abiturient;
GRANT EXECUTE ON PROCEDURE is_scholarship(INTEGER) TO abiturient;
GRANT EXECUTE ON FUNCTION get_statements(INTEGER) TO abiturient;
GRANT EXECUTE ON FUNCTION get_id_enrolled_abit(INTEGER) TO abiturient;

CREATE ROLE abit_138 LOGIN PASSWORD 'abit138password';
GRANT abiturient TO abit_138;



CREATE ROLE selection_committee NOLOGIN;

GRANT INSERT ON enrolled_abiturient TO selection_committee;
GRANT SELECT ON enrolled_abiturient, statements TO selection_committee;

GRANT EXECUTE ON FUNCTION get_id_enrolled_abit(INTEGER) TO selection_committee;
GRANT EXECUTE ON PROCEDURE enroll_abit(INTEGER, BOOLEAN) TO selection_committee;

CREATE ROLE selection_committee_26 LOGIN PASSWORD 'SC26pass';
GRANT selection_committee TO selection_committee_26;



CREATE ROLE dean NOLOGIN;

GRANT SELECT ON enrolled_abiturient, statements, abiturient, department_priority, department TO dean;
GRANT EXECUTE ON PROCEDURE formation_of_order(INTEGER) TO dean;

CREATE ROLE dean_4 LOGIN PASSWORD 'DeanJoe112233';
GRANT dean TO dean_4;