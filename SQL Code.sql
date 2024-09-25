--combine all tables to main table called last_12month_report--

select * into last_12month_report
from (
select * from april_2024
union                       ---when we use union we can also remove duplicated values---
select * from aug_2024
union 
select * from dec_2023
union 
select * from feb_2024
union 
select * from jan_2024
union 
select * from jul_2024
union 
select * from jun_2024
union 
select * from mar_2024
union 
select * from may_2024
union 
select * from nov_2023
union 
select * from oct_2023
union 
select * from sep_2023
) A 


SELECT COUNT(*) - COUNT(ride_id) ride_id,
 COUNT(*) - COUNT(rideable_type) rideable_type,
 COUNT(*) - COUNT(started_at) started_at,
 COUNT(*) - COUNT(ended_at) ended_at,
 COUNT(*) - COUNT(start_station_name) start_station_name,
 COUNT(*) - COUNT(start_station_id) start_station_id,
 COUNT(*) - COUNT(end_station_name) end_station_name,
 COUNT(*) - COUNT(end_station_id) end_station_id,
 COUNT(*) - COUNT(start_lat) start_lat,
 COUNT(*) - COUNT(start_lng) start_lng,
 COUNT(*) - COUNT(end_lat) end_lat,
 COUNT(*) - COUNT(end_lng) end_lng,
 COUNT(*) - COUNT(member_casual) member_casual
FROM last_12month_report;


    
                                                                                                        ----Data Cleaning----


           ---Calculate length of ride_id----
SELECT LEN(ride_id)  length_ride_id, COUNT(ride_id) AS no_of_rows
FROM last_12month_report
GROUP BY LEN(ride_id)

                                          ----Removing Null Values-----
select * into nut_null_table
 from last_12month_report
  where ride_id is not null 
  and rideable_type is not null
	and started_at  is not null
	and ended_at is not null
	and start_station_name is not null	
	and start_station_id is not null
	and end_station_name is not null
	and end_station_id is not null
	and start_lat is not null
	and start_lng is not null
	and end_lat is not null
	and end_lng is not null
	and member_casual is not null
	and ride_length is not null
	and  weekday is not null
  and LEN(ride_id)=16 ;          ---- we used it to select ride_id with 16 characters only


----Combining all columns in one table to use it in tablue for visualization----
    SELECT     ride_id,rideable_type as bike_type,started_at,ended_at, 
                     start_station_name, end_station_name, 
                     start_lat, start_lng, end_lat, end_lng, member_casual as user_type,
 
                      ---Add a new column called ride_length to calculate trips duration----
                           cast(DATEDIFF(MINUTE, started_at, ended_at) as bigint) AS  ride_length,
---create a new column called season to improve our analysis ----
 
    case when DATENAME(month,started_at) like 'January' or DATENAME(month,started_at)  like 'February' or DATENAME(month,started_at) like 'December'
	                    then 'Winter'
		when DATENAME(month,started_at) like 'March' or DATENAME(month,started_at) like 'April' or DATENAME(month,started_at) like 'May' 
		then 'Spring'
			when DATENAME(month,started_at) like 'June' or DATENAME(month,started_at) like 'July' or DATENAME(month,started_at) like 'August'
			then 'Summer'
					when DATENAME(month,started_at) like 'September' or DATENAME(month,started_at) like 'October' or DATENAME(month,started_at) like 'Novemebr'
					 then 'Autum'
 end as Season,
			
						
---create a new column called weekday to improve our analysis ----


 Case when(DATEPART(dw,started_at) in (1,2,3,4,5)) then 'Weekdays'
		         else 'Weekends'
		         end as weekday,

---crate a new column called time_of_ay to improve our analysis ----

case when cast(started_at as time) >='06:00' and cast(started_at as time) <'12:00' then 'Morning'
		       when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
	                      when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
		        else 'Night'
		                       End as Time_of_day,
                                   
                into final_table
from not_null_table


           ---------------- Data Analysis---------------

	---- Avg Rides_length by user_type ----
Select user_type  , avg(ride_length) AS "average of trip"
from final_table
group by  user_type  ;

	---- Avg Rides_length by bike-type ----
Select  bike_type,avg(ride_length) AS "average of trip"
from final_table
group by bike_type;

                                                  ----Rides per month----
 select count(*) as no_of_rides,DATENAME(month,started_at)+ '  ' + CAST(datepart(year,started_at)as varchar) as year_month from final_table
 group by DATENAME(month,started_at)+ ' '+ CAST(datepart(year,started_at)as varchar) 
 order by 1
 
 
                                                    -----RIDES BY SEASON------
 SELECT distinct DATENAME(month,started_at) as Month,count(started_at) as number_of_rides, user_type,season
  group by DATENAME(month,started_at), user_type, season 
					 


					 ------RIDES BY day of week------
	Select weekday,bike_type,member_casual, count(weekday) as number_of_rides
              from final_table
	group by weekday, bike_type, user_type
	order by 1 


                                        ------RIDES BY TIME OF DAY AND WEEKDAY ----------

Select   weekday, count(weekday) as number_of_rides, user_type,time_of_day
from final_table
group by weekday , user_type, time_of_day;
order by weekday 

				---------- RIDES BY MONTH AND TIME--------------
Select  DATENAME(mm,started_at) as Month_name, count(weekday) as number_of_rides, user_type,Time_of_day
from final_table
group by DATENAME(mm,started_at), user_type, Time_of_day
order by Month_name


-	                                   ----RIDES BY BIKE_TYPE AND USER_TYPE------
select user_type,count(ride_id) as number_of_rides,bike_type 
from final_table
group by user_type, bike_type
	


   
  

  


