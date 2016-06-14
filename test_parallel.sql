
create table table1 (id serial not null primary key, txt text);
create table table2 (id serial not null primary key, table1_id int not null references table1, txt text);

insert into table1 (txt)
select 'txt_' || n from generate_series(1, 10000000) n;


insert into table2 (table1_id, txt)
select n, 'other_txt_' || n from generate_series(1, 10000000) n;

create index on table2(table1_id);
create index on table2  using brin (table1_id);

set max_parallel_workers_per_gather = 0;
explain analyze
select count(*) from table1;

set max_parallel_workers_per_gather = 8;
explain analyze
select count(*) from table1;


set max_parallel_workers_per_gather = 0;
explain analyze
select * from table1 where txt = 'txt_9999';

set max_parallel_workers_per_gather = 8;
explain analyze
select * from table1 where txt = 'txt_9999';


/*
select * from
table1 t1
    inner join table2 t2 on t2.table1_id = t1.id
where t1.txt = 'txt_9999' and t2.txt = 'other_txt_9999';
*/
