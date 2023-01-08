CREATE TABLE ZNO_list (
    id SERIAL,
    subject_name VARCHAR(40) NOT NULL,
    min_score INTEGER NOT NULL
);

CREATE TABLE abiturient (
    id SERIAL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    fathers_name VARCHAR(40),
    birthday DATE NOT NULL,
    phone_number BIGINT NOT NULL UNIQUE,
    email VARCHAR(40) NOT NULL UNIQUE,
    certificate_score NUMERIC(6, 3) NOT NULL,
    quota SMALLINT,
    is_conditions BOOLEAN NOT NULL,
    is_dormitory BOOLEAN NOT NULL
);

CREATE TABLE specialty (
    id SERIAL,
    specialty_name VARCHAR(100) NOT NULL
);

CREATE TABLE faculty (
    id SERIAL,
    full_name VARCHAR(60) NOT NULL,
    short_name VARCHAR(5) NOT NULL,
    phone_number BIGINT NOT NULL UNIQUE
);

CREATE TABLE ZNO_result (
    id SERIAL,
    id_abiturient INTEGER,
    id_subject INTEGER,
    result NUMERIC(6, 3) NOT NULL
);

CREATE TABLE document (
    id SERIAL,
    id_abiturient INTEGER,
    short_description VARCHAR(40) NOT NULL,
    document_url VARCHAR(255) NOT NULL
);

CREATE TABLE statements (
    id SERIAL,
    id_abiturient INTEGER,
    id_specialty INTEGER,
    priorities SMALLINT,
    score NUMERIC(6, 3) NOT NULL,
    course SMALLINT NOT NULL
);

CREATE TABLE department (
    id SERIAL,
    id_faculty INTEGER,
    department_name VARCHAR(255) NOT NULL,
    phone_number BIGINT NOT NULL UNIQUE
);

CREATE TABLE enrolled_abiturient (
    id SERIAL,
    id_statement INTEGER,
    scholarship BOOLEAN NOT NULL
);

CREATE TABLE department_priority (
    id SERIAL,
    id_department INTEGER,
    id_statement INTEGER,
    priorities SMALLINT
);