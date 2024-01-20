#Who prefers energy drink more? (male/female/non-binary?
select gender,f.Consume_frequency,round(count(d.Respondent_ID)/sum(count(d.Respondent_ID)) over(partition by gender)*100,2) from dim_repondents d
join fact_survey_responses f on f.Respondent_ID=d.Respondent_ID
group by gender,f.Consume_frequency
order by gender;
#Which age group prefers energy drinks more?
select Age,f.Consume_frequency,round(count(d.Respondent_ID)/sum(count(d.Respondent_ID)) over(partition by Age)*100,2) from dim_repondents d
join fact_survey_responses f on f.Respondent_ID=d.Respondent_ID
group by Age,f.Consume_frequency
order by Age;
#Which type of marketing reaches the most Youth (15-30)?
select age,f.Marketing_channels,count(d.Respondent_ID)/sum(count(d.Respondent_ID)) over(partition by age)*100  from dim_repondents d
join fact_survey_responses f on f.Respondent_ID=d.Respondent_ID
where age='15-18'
group by age,f.Marketing_channels;
#What are the preferred ingredients of energy drinks among respondents?
select Ingredients_expected,round(count(Respondent_ID)/sum(count(Respondent_ID)) over()*100,2)  from fact_survey_responses f
group by Ingredients_expected;
#What packaging preferences do respondents have for energy drinks?
select Packaging_preference,round(count(Respondent_ID)/sum(count(Respondent_ID)) over()*100,2) from fact_survey_responses f
group by Packaging_preference;
#Who are the current market leaders?
select Current_brands ,round(count(Respondent_ID)/sum(count(Respondent_ID)) over()*100,2) from fact_survey_responses
group by Current_brands;


#What are the primary reasons consumers prefer those brands over ours?
select Reasons_for_choosing_brands,round(count(Respondent_ID)/sum(count(Respondent_ID)) over()*100,2) from fact_survey_responses
group by Reasons_for_choosing_brands;
#Which marketing channel can be used to reach more customers
select Marketing_channels,round(count(Respondent_ID)/sum(count(Respondent_ID)) over()*100,2) from fact_survey_responses
group by Marketing_channels;
#Where do respondents prefer to purchase energy drinks?
select Purchase_location,round(count(Respondent_ID)/sum(count(Respondent_ID)) over()*100,2) from fact_survey_responses
group by Purchase_location;
#What do people think about our brand? (overall rating)
select Taste_experience,round(count(Respondent_ID)/sum(count(Respondent_ID)) over()*100,2) from fact_survey_responses
group by Taste_experience;
#Which cities do we need to focus more on?
with cte as(select city,Consume_frequency,(count(f.Respondent_ID)/sum(count(f.Respondent_ID)) over(partition by city))*100 as per from fact_survey_responses f
join dim_repondents d on d.Respondent_ID=f.Respondent_ID
join dim_cities c on c.City_ID=d.City_ID

group by City,Consume_frequency)
select city,sum(per) as p from cte

 where Consume_frequency='2-3 times a week' or Consume_frequency='Daily'
  group by city
  order by p desc;
 

#What are the typical consumption situations for energy drinks among respondents
select Typical_consumption_situations,count(Respondent_ID)/sum(count(Respondent_ID)) over()*100 as per from fact_survey_responses
group by Typical_consumption_situations;
#What factors influence respondents' purchase decisions, such as price range and limited edition packaging?
select Limited_edition_packaging, count(Respondent_ID)/sum(count(Respondent_ID)) over()*100 from fact_survey_responses
group by Limited_edition_packaging;
select Price_range,count(Respondent_ID)/sum(count(Respondent_ID)) over()*100 from fact_survey_responses
group by Price_range;
#Which area of business should we focus more on our product development?
select Reasons_for_choosing_brands,count(Respondent_ID)/sum(count(Respondent_ID)) over()*100 from fact_survey_responses
group by Reasons_for_choosing_brands;
#Which cities do we need to focus more on?
with cte as(select city,Consume_frequency,(count(f.Respondent_ID)/sum(count(f.Respondent_ID)) over(partition by city))*100 as per from fact_survey_responses f
join dim_repondents d on d.Respondent_ID=f.Respondent_ID
join dim_cities c on c.City_ID=d.City_ID

group by City,Consume_frequency)
select city,sum(per) as p from cte

 where Consume_frequency='2-3 times a week' or Consume_frequency='Daily'
  group by city
  order by p desc;
#Which age do we need to focus more on?
with cte as(select age,Consume_frequency,(count(f.Respondent_ID)/sum(count(f.Respondent_ID)) over(partition by age))*100 as per from fact_survey_responses f
join dim_repondents d on d.Respondent_ID=f.Respondent_ID
join dim_cities c on c.City_ID=d.City_ID

group by age,Consume_frequency)
select age,sum(per) as p from cte

 where Consume_frequency='2-3 times a week' or Consume_frequency='Daily'
  group by age
  order by p desc;
#Which gender do we need to focus more on?
with cte as(select gender,Consume_frequency,(count(f.Respondent_ID)/sum(count(f.Respondent_ID)) over(partition by gender))*100 as per from fact_survey_responses f
join dim_repondents d on d.Respondent_ID=f.Respondent_ID
join dim_cities c on c.City_ID=d.City_ID

group by gender,Consume_frequency)
select gender,sum(per) as p from cte

 where Consume_frequency='2-3 times a week' or Consume_frequency='Daily'
  group by gender
  order by p desc;
# now find potential consumer from city
with cte as(select city,age,gender,Consume_frequency,(count(f.Respondent_ID)/sum(count(f.Respondent_ID)) over(partition by city,age,gender))*100 as per from fact_survey_responses f
join dim_repondents d on d.Respondent_ID=f.Respondent_ID
join dim_cities c on c.City_ID=d.City_ID

group by City,age,gender,Consume_frequency)
select city,gender,age,sum(per) as p from cte
where Consume_frequency='2-3 times a week' or Consume_frequency='Daily' 
  group by city,age,gender
  order by p desc;


#Give me best marketing way for top 2city,in frquently energy drink condumer.
WITH cte AS (
    SELECT city,
           Consume_frequency,
           (COUNT(f.Respondent_ID) / SUM(COUNT(f.Respondent_ID)) OVER (PARTITION BY city)) * 100 AS per 
    FROM fact_survey_responses f
    JOIN dim_repondents d ON d.Respondent_ID = f.Respondent_ID
    JOIN dim_cities c ON c.City_ID = d.City_ID
    GROUP BY City, Consume_frequency
), ranked_cities AS (
    SELECT city,
           SUM(per) AS total_percentage
    FROM cte
    WHERE Consume_frequency = '2-3 times a week' OR Consume_frequency = 'Daily'
    GROUP BY city
    ORDER BY total_percentage DESC
    LIMIT 2
)
select city,f.Marketing_channels,count(d.Respondent_ID)/sum(count(d.Respondent_ID)) over(partition by city)*100  c from dim_repondents d
join fact_survey_responses f on f.Respondent_ID=d.Respondent_ID
join dim_cities c ON D.City_ID=c.City_ID
WHERE city IN (SELECT city FROM ranked_cities)
group  by city,f.Marketing_channels;

#Give me best marketing way for top 2 age group in frquently energy drink condumer.
WITH cte AS (
    SELECT age,
           Consume_frequency,
           (COUNT(f.Respondent_ID) / SUM(COUNT(f.Respondent_ID)) OVER (PARTITION BY age)) * 100 AS per 
    FROM fact_survey_responses f
    JOIN dim_repondents d ON d.Respondent_ID = f.Respondent_ID
    JOIN dim_cities c ON c.City_ID = d.City_ID
    GROUP BY age, Consume_frequency
), ranked_ages AS (
    SELECT age,
           SUM(per) AS total_percentage
    FROM cte
    WHERE Consume_frequency = '2-3 times a week' OR Consume_frequency = 'Daily'
    GROUP BY age
    ORDER BY total_percentage DESC
    LIMIT 2
)
SELECT age, f.Marketing_channels, count(d.Respondent_ID)/sum(count(d.Respondent_ID)) over(partition by age) * 100 AS c 
FROM dim_repondents d
JOIN fact_survey_responses f ON f.Respondent_ID = d.Respondent_ID
JOIN dim_cities c ON d.City_ID = c.City_ID
WHERE age IN (SELECT age FROM ranked_ages)
GROUP BY age, f.Marketing_channels;

