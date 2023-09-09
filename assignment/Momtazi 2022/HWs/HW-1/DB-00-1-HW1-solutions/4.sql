--A
select s.name, count(*) cnt
from friends
         join students s on friends.student_id = s.id
group by student_id
order by cnt desc;

--B
select distinct (dg1.student_id)
from db_grades dg1,
     friends,
     db_grades dg2
where dg1.student_id = friends.student_id
  and dg2.student_id = friends.friend_id
  and dg1.grade < 10
  and dg2.grade > 10;

--create view for next 2 questions
create view friends_grades as
select dg1.student_id as studnet_id1, dg1.grade as grade1, dg2.student_id as studnet_id2, dg2.grade as grade2
from db_grades dg1,
     friends,
     db_grades dg2
where dg1.student_id = friends.student_id
  and dg2.student_id = friends.friend_id;

  --C
select distinct(studnet_id1)
from friends_grades
where grade2 < 10
  and studnet_id1 not in (select studnet_id1 from friends_grades where grade2 >= 10);

  --D
  select distinct(studnet_id1)
from friends_grades
where grade2 > grade1
  and studnet_id1 in (select studnet_id1 from friends_grades where grade2 < grade1);

  --E
  select var_pop(grade)
from db_grades
where grade < 10;
