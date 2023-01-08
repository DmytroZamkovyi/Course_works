SELECT * FROM statements WHERE statements.score > 150;
explain (costs off) SELECT * FROM statements WHERE statements.score > 150;

CREATE INDEX ON zno_result USING hash (id_subject);
SELECT * FROM statements WHERE statements.score > 150;
explain (costs off) SELECT * FROM statements WHERE statements.score > 150;