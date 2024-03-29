Table: Calls
Column   Name Type
from_id  int
to_id    int
duration int

This table does not have a primary key, it may contain duplicates.
This table contains the duration of a phone call between from_id and to_id. from_id != to_id

Write an SQL query to report the number of calls and the total call duration between each pair of
distinct persons (person1, person2) where person1 < person2.
Return the result table in any order.
The query result format is in the following example.

Input:
Calls table:

from_id   to_id   duration
1         2         59
2         1         11
1         3         20
3         4         100
3         4         200
3         4         200
4         3         499

Output:

person1   person2   call_count    total_duration
1           2         2                 70
1           3         1                 20
3           4         4                  999

Explanation:
Users 1 and 2 had 2 calls and the total duration is 70 (59 + 11).
Users 1 and 3 had 1 call and the total duration is 20.
Users 3 and 4 had 4 calls and the total duration is 999 (100 + 200 + 200 + 499).


ANSWER :-

create table calls(
    from_id int,
    to_id int,
    duration int
);

insert into calls values(1,2,59);
insert into calls values(2,1,11);
insert into calls values(1,3,20);
insert into calls values(4,3,499);
insert into calls values(3,4,100);
insert into calls values(3,4,200);
insert into calls values(3,4,200);


## solution_1 :

SELECT
    LEAST(from_id, to_id) as person1,
    GREATEST(from_id, to_id) as person2,
    COUNT(*) as call_count,
    SUM(duration) as total_duration
FROM Calls
GROUP BY 1, 2

----------------------------------------------------------------------------------------------------------

## solution_2

select from_id as person1,to_id as person2,
    count(duration) as call_count, sum(duration) as total_duration
from (select * from Calls 
    
      union all
      
      select to_id, from_id, duration from Calls) t1
where from_id < to_id
group by person1, person2

----------------------------------------------------------------------------------------------------------

### solution_3

WITH caller as (
    select from_id as person1, to_id as person2, duration from Calls

    UNION ALL
    
    select to_id as person1, from_id as person2, duration from Calls
),

unique_caller as (
    select person1, person2, duration
    from caller
    where person1 < person2
)

select
    person1, person2, count(*) as call_count, sum(duration) as total_duration
from unique_caller
group by person1, person2

----------------------------------------------------------------------------------------------------------

## solution_4

# The simpler way is to use CASE so you get the unique combinations of col1 and col2 and then group by each combination:

SELECT 
  case when cal1 < cal2 then cal1 else cal2 end col1, 
  case when cal1 < cal2 then cal2 else cal1 end col2, 
  SUM(duration) duration
FROM tele 
GROUP BY col1, col2



