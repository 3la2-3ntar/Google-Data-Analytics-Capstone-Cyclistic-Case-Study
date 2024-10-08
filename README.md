# Google-Data-Analytics-Capstone-Cyclistic-Case-Study

## introduction
#### In this case study, I will perform many real-world tasks of a junior data analyst at a fictional company, Cyclistic. In order to answer the key business questions, I will follow the steps of the data analysis process: Ask,Prepare,Process,Anala,Share,Act
## Background
### Cyclistic
A bike-share program that features more than 5,800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use them to commute to work each day.   
  
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.  
  
Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno (the director of marketing and my manager) believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.  

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends.  

### Scenario
I am assuming to be a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, my team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, my team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve our recommendations, so they must be backed up with compelling data insights and professional data visualizations.

## Ask
### Business Task
Devise marketing strategies to convert casual riders to members.
### Analysis Questions
Three questions will guide the future marketing program:  
1. How do annual members and casual riders use Cyclistic bikes differently?  
2. Why would casual riders buy Cyclistic annual memberships?  
3. How can Cyclistic use digital media to influence casual riders to become members?  

Moreno has assigned me the first question to answer: How do annual members and casual riders use Cyclistic bikes differently?
## Prepare
### Data Source
I will use Cyclistic’s historical trip data to analyze and identify trends from Sep 2023 to Aug 2024 which can be downloaded from [divvy_tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html). The data has been made available by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement).  
  
This is public data that can be used to explore how different customer types are using Cyclistic bikes. But note that data-privacy issues prohibit from using riders’ personally identifiable information. This means that we won’t be able to connect pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.
### Data Organization
There are 12 files with naming convention of YYYYMM-divvy-tripdata and each file includes information for one month, such as the ride id, bike type, start time, end time, start station, end station, start location, end location, and whether the rider is a member or not. The corresponding column names are ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng and member_casual.

## Process
SQL Server is used to combine the various datasets into one dataset and clean it.    
Reason:  
A worksheet can only have 1,048,576 rows in Microsoft Excel because of its inability to manage large amounts of data. Because the Cyclistic dataset has more than 5.6 million rows, it is essential to use a platform like SQL Server that supports huge volumes of data.
### Combining the Data
SQL Server Query:
```
--combine all table to main table called last_12month_report--
--- Note: When we use union we can also remove duplicated values---
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

```

12 csv files are uploaded as tables in the dataset 'Cyclistic'. Another table named "last_12month_report" is created, containing 5,743,202 rows of data (with on duplicate values) for the entire year. 
### Data Exploration
SQL Server Query: 
```
selesct * from  last_12month_report;
```
Before cleaning the data, I am familiarizing myself with the data to find the inconsistencies.  

Observations:  
1. The table below shows the all column names and their data types.

   ![image](https://user-images.githubusercontent.com/125132307/226139161-c5209861-7542-4ad6-8d9a-ce0115086e4d.png)  ???

3. The following table shows number of __null values__ in each column.
    SQL server Query:

```
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
FROM `2022_tripdata.combined_data`;
``` 
   
   ![image](https://github.com/user-attachments/assets/67170da5-8ed2-43e0-9a62-290aba63a2eb).png) 

   Note that some columns have same number of missing values. This may be due to missing information in the same row i.e. station's name and id for the same station 
   and latitude and longitude for the same ending station.  
5. As ride_id has no null values, let's use it to check for length.
SQL server Query: 
```
SELECT LEN(ride_id) as length_ride_id, COUNT(ride_id) AS no_of_rows
FROM last_12month_report
GROUP BY LEN(ride_id);
  ```
   ![image](https://github.com/user-attachments/assets/43dcd3f3-1707-4432-9d9e-1c20fc0d759c.png)???

  We have 3865 rows in ride_id which has less than 16. We should remove.
8. The __started_at__ and __ended_at__ shows start and end time of the trip in YYYY-MM-DD hh:mm:ss datetime2 format. New column ride_length can be created to find the total trip duration. There are trips which has duration longer than a day and other trips having less than a minute duration or having end time earlier than start time so need to remove them. Other columns weekday , time of day and seaosn can also be helpful in analysis of trips at different times in a year.

### Data Cleaning

1. All the rows having missing values are deleted.  
2. 4 more columns ride_length for duration of the trip, weekday, time of day and season are added.  
3. Trips with duration less than a minute and longer than a day are excluded.
4. Total 1,706,118 rows are removed in this step.
  
## Analyze and Share
SQL  Server Query:
```

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
```
Data Visualization: [Tableau](https://public.tableau.com/views/CasestudyundercapstoneprojectofGoogleDataAnalyticsCertificate/Totalrides?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)  
The data is stored appropriately and is now prepared for analysis. I queried multiple relevant tables for the analysis and visualized them in Tableau.  
The analysis question is: How do annual members and casual riders use Cyclistic bikes differently?  

First of all, member and casual riders are compared by the type of bikes they are using.  

![image](https://user-images.githubusercontent.com/125132307/226692931-ecd2eb32-ffce-481a-b3c2-a6c3b4f3ceb7.png)
  
The members make 59.7% of the total while remaining 40.3% constitutes casual riders. Each bike type chart shows percentage from the total. Most used bike is classic bike followed by the electric bike. Docked bikes are used the least by only casual riders. 
  
Next the number of trips distributed by the months, days of the week and hours of the day are examined.  
  
![image](https://user-images.githubusercontent.com/125132307/230122705-2f157258-e673-4fc5-bbed-88050b6aae68.png)
![image](https://user-images.githubusercontent.com/125132307/230122935-8d0889c3-f0ff-43ce-94ab-393f2e230bee.png)
  
__Months:__ When it comes to monthly trips, both casual and members exhibit comparable behavior, with more trips in the spring and summer and fewer in the winter. The gap between casuals and members is closest in the month of july in summmer.   
__Days of Week:__ When the days of the week are compared, it is discovered that casual riders make more journeys on the weekends while members show a decline over the weekend in contrast to the other days of the week.  
__Hours of the Day:__ The members shows 2 peaks throughout the day in terms of number of trips. One is early in the morning at around 6 am to 8 am and other is in the evening at around 4 pm to 8 pm while number of trips for casual riders increase consistently over the day till evening and then decrease afterwards.  
  
We can infer from the previous observations that member may be using bikes for commuting to and from the work in the week days while casual riders are using bikes throughout the day, more frequently over the weekends for leisure purposes. Both are most active in summer and spring.  
  
Ride duration of the trips are compared to find the differences in the behavior of casual and member riders.  
  
![image](https://user-images.githubusercontent.com/125132307/230164787-3ea46ee9-aa5f-486b-9dd1-8f43dfce8e1c.png)  
![image](https://user-images.githubusercontent.com/125132307/230164889-1c7943d2-7ada-411b-adc7-a043eb480ba1.png)
  
Take note that casual riders tend to cycle longer than members do on average. The length of the average journey for members doesn't change throughout the year, week, or day. However, there are variations in how long casual riders cycle. In the spring and summer, on weekends, and from 10 am to 2 pm during the day, they travel greater distances. Between five and eight in the morning, they have brief trips.
  
These findings lead to the conclusion that casual commuters travel longer (approximately 2x more) but less frequently than members. They make longer journeys on weekends and during the day outside of commuting hours and in spring and summer season, so they might be doing so for recreation purposes.    
  
To further understand the differences in casual and member riders, locations of starting and ending stations can be analysed. Stations with the most trips are considered using filters to draw out the following conclusions.  
  
![image](https://user-images.githubusercontent.com/125132307/230248445-3fe69cbb-30a9-42c6-b5e8-ab433a620ff3.png)  
  
Casual riders have frequently started their trips from the stations in vicinity of museums, parks, beach, harbor points and aquarium while members have begun their journeys from stations close to universities, residential areas, restaurants, hospitals, grocery stores, theatre, schools, banks, factories, train stations, parks and plazas.  
  
![image](https://user-images.githubusercontent.com/125132307/230253219-4fb8a2ed-95e3-4e52-a359-9d86945b7a75.png)
  
Similar trend can be observed in ending station locations. Casual riders end their journay near parks, museums and other recreational sites whereas members end their trips close to universities, residential and commmercial areas. So this proves that casual riders use bikes for leisure activities while members extensively rely on them for daily commute.  
  
Summary:
  
|Casual|Member|
|------|------|
|Prefer using bikes throughout the day, more frequently over the weekends in summer and spring for leisure activities.|Prefer riding bikes on week days during commute hours (8 am / 5pm) in summer and spring.|
|Travel 2 times longer but less frequently than members.|Travel more frequently but shorter rides (approximately half of casual riders' trip duration).|
|Start and end their journeys near parks, museums, along the coast and other recreational sites.|Start and end their trips close to universities, residential and commercial areas.|  
  
## Act
After identifying the differences between casual and member riders, marketing strategies to target casual riders can be developed to persuade them to become members.  
Recommendations:  
1. Marketing campaigns might be conducted in spring and summer at tourist/recreational locations popular among casual riders.
2. Casual riders are most active on weekends and during the summer and spring, thus they may be offered seasonal or weekend-only memberships.
3. Casual riders use their bikes for longer durations than members. Offering discounts for longer rides may incentivize casual riders and entice members to ride for longer periods of time.
