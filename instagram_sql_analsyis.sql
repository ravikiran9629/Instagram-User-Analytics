# task - A-1
select * from users 
order by created_at asc 
limit 5;

#task - A-2
select u.id,
       u.username 
from users u 
left join photos p on u.id=p.user_id 
     where p.id is NULL;

#task - A-3
select count(user_id) as no_of_likes,photo_id from likes group by photo_id order by no_of_likes desc limit 1  ;  
select u.id,
       u.username,
       p.image_url 
from users u 
join photos p on u.id=p.user_id 
where p.id =(select photo_id 
				from likes 
				group by photo_id 
				order by count(user_id) desc limit 1 ) ;

#task - A-4
select t.tag_name 
from tags t 
join photo_tags pt on t.id=pt.tag_id 
group by pt.tag_id 
order by count(pt.tag_id) desc limit 5	;

#task - A-5 
select dayname(created_at) as best_day_of_week from users  ;# getting day names using dayname fxn
# semi auto query
select dayname(created_at) as best_day_of_week,
       count(created_at) as no_of_registers
from users 
group by (dayname(created_at))  
order by count(created_at) desc limit 2 ;
#answer using dense_rank() window fuction
select best_day_of_week from 
    (
     select best_day_of_week,
            no_of_registers,
            dense_rank() over(order by no_of_registers desc) as ranking 
	from(
         select dayname(created_at) as best_day_of_week,
				count(created_at) as no_of_registers 
		from users 
        group by (dayname(created_at))
        ) as t1
	)
t2 where t2.ranking=1 ;

select dayname(created_at) as best_day_of_week,count(created_at) as no_of_registers,dense_rank() over(order by no_of_registers desc) as ranking  from users 
group by (dayname(created_at))
order by count(created_at);# error due to order of precedence

#task - B-1 
select u.id,nt.no_of_posts from users u left join (select count(id) no_of_posts,user_id from photos group by user_id ) nt on u.id=nt.user_id; # no of posts posted by each person
select count(id)/(select count(id) from users) from photos; #total photos/total users
select count(id)/count(distinct user_id) from photos ; # avg no of posts per user
#final answer
select  count(id)/count(distinct user_id) as avg_posts_per_user,
        count(id)/(select count(id) from users) as ratio_of_total_photos_to_total_users 
from photos;


#task - B-2
select count(photo_id) as liked_posts,
       user_id
from likes 
group by user_id
having liked_posts=(select count(id) from photos) 
order by liked_posts desc;                              # answer without join


select nl.liked_posts ,nl.user_id from 
(select count(photo_id) as liked_posts,user_id,photo_id from likes group by user_id order by liked_posts desc) nl 
join photos p on nl.photo_id=p.id where nl.liked_posts=(select count(id) from photos);