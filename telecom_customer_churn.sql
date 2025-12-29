create database telecom_dataset_analysis;
use telecom_dataset_analysis;

*🧩 SECTION 1: BASIC SELECT + WHERE (Data understanding & filtering)*

--1️⃣ Display all customer records.
select * from telecom

2️⃣ Show only customerID, gender, tenure, and Churn.
select customerID, gender, tenure, Churn from telecom

3️⃣ Find all customers who have churned.
select customerid ,churn from telecom where churn='yes';

4️⃣ List customers with tenure less than 12 months.
select customerid ,tenure from telecom where tenure<12 ;

5️⃣ Find customers who pay more than ₹70 monthly charges.
select customerid ,monthlycharges from telecom where monthlycharges>70;

6️⃣ Show customers who are Senior Citizens and have churned.
--1)select SeniorCitizen ,customerid from telecom where churn='yes' and seniorcitizen=1 ---or--
--2)SELECT *FROM telecom WHERE SeniorCitizen = 1 AND Churn = 'Yes';

7️⃣ Find customers who have no dependents and no partner.
select customerid ,partner,dependents from telecom where partner='no' and dependents='no';

🧩 SECTION 2: ORDER BY + LIMIT (Ranking & sorting)

--8️⃣ List customers with the highest monthly charges first.
select customerid ,monthlycharges from telecom order by monthlycharges desc ---or--
SELECT *FROM telecom ORDER BY MonthlyCharges DESC;

9️⃣ Show top 10 customers paying the highest monthly charges.
select customerid ,monthlycharges from telecom order by monthlycharges desc limit 10;

🔟 Display customers with the lowest tenure.
select *from telecom order by tenure asc;

1️⃣1️⃣ Show 5 customers who stayed the longest with the company.
select *from telecom order by tenure desc limit 5;

1️⃣2️⃣ Sort churned customers by monthly charges (descending).
select customerid, monthlycharges from telecom where churn='yes' order by monthlycharges desc;

🧩 SECTION 3: AGGREGATE FUNCTIONS (Overall metrics)

1️⃣3️⃣ Find the total number of customers.
select count(*)as total_customers from telecom;

1️⃣4️⃣ Calculate the overall churn rate (%).
SELECT ROUND(100.0 * SUM(Churn='Yes') / COUNT(*),2) AS churn_rate FROM telecom;

 1️⃣5️⃣ Find the average monthly charges of all customers.
SELECT ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges FROM telecom; 

1️⃣6️⃣ Calculate average tenure of churned customers.
select round(avg(tenure),2)from telecom where churn='yes';

1️⃣7️⃣ Find the maximum and minimum monthly charges.
select max(monthlycharges),min(monthlycharges) from telecom;

SECTION 4: GROUP BY(Segmentation analysis)

1️⃣8️⃣ Count customers by gender.
select count(customerid),gender from telecom group by gender;
SELECT gender,COUNT(*) AS total_customers FROM telecom GROUP BY gender;

1️⃣9️⃣ Count customers by contract type.
select contract , count(*) as total_customers from telecom group by contract;

2️⃣0️⃣ Find churned customers count by contract type.
select contract , count(*) as total_customers from telecom where churn='yes' group by contract;

2️⃣1️⃣ Calculate average monthly charges for each contract.
select round(avg(monthlycharges),2),contract  from telecom group by contract;

2️⃣2️⃣ Find churn count by payment method.
select paymentmethod,count(churn) from telecom where churn='yes'group by paymentmethod;

--SECTION 5: GROUP BY + HAVING(Filtered aggregation – very important)

2️⃣3️⃣ Find contract types where more than 500 customers churned.
SELECT Contract, COUNT(*) AS churned_customers FROM telecom WHERE Churn = 'Yes'GROUP BY Contract HAVING COUNT(*) > 500;

️⃣4️⃣ Find payment methods with churn rate greater than 30%.
SELECT PaymentMethod,ROUND(100.0 * SUM( Churn = 'Yes') / COUNT(*),2) AS churn_rate FROM telecom GROUP BY PaymentMethod HAVING 100.0 * SUM( Churn = 'Yes' ) / COUNT(*) > 30;

2️⃣5️⃣ Show tenure groups where average monthly charges > 65.
SELECT CASE WHEN tenure <= 12 THEN '0–1 Year'WHEN tenure <= 24 THEN '1–2 Years'ELSE '2+ Years'END AS tenure_group,ROUND(AVG(MonthlyCharges),2) AS avg_bill FROM telecom GROUP BY tenure_group HAVING AVG(MonthlyCharges) > 65;--or--
SELECT FLOOR(tenure / 12) AS tenure_group,ROUND(AVG(MonthlyCharges), 2) AS avg_bill FROM telecom GROUP BY FLOOR(tenure / 12) HAVING AVG(MonthlyCharges) > 65;

2️⃣6️⃣ Find contracts where average tenure is less than 12 months.
select contract,round(avg(tenure),2) from telecom group by contract having avg(tenure)<12;

---🧩 SECTION 6: CTE (Common Table Expressions)(Readable, step-wise logic)

2️⃣7️⃣ Create a CTE to calculate total customers and churned customers per contract.
WITH contract_churn AS (SELECT Contract,COUNT(*) AS total_customers,SUM(Churn = 'Yes') AS churned_customers FROM telecom GROUP BY Contract)SELECT * FROM contract_churn;

2️⃣8️⃣ From the above CTE, calculate churn percentage per contract.
WITH contract_churn AS (SELECT Contract,COUNT(*) AS total_customers,SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers FROM telecom GROUP BY Contract)
SELECT Contract,total_customers,churned_customers,ROUND(100.0 * churned_customers / total_customers, 2) AS churn_rate FROM contract_churn;

2️⃣9️⃣ Create a CTE to group customers by tenure buckets (0–6, 6–12, 1–2 yrs, 2+ yrs).
WITH tenure_groups AS (SELECT*,CASE WHEN tenure < 6 THEN '0-6 Months'WHEN tenure BETWEEN 6 AND 12 THEN '6-12 Months'WHEN tenure BETWEEN 13 AND 24 THEN '1-2 Years'ELSE '2+ Years'END AS tenure_bucket FROM telecom)
SELECT tenure_bucket,COUNT(*) AS total_customers FROM tenure_groups GROUP BY tenure_bucket ORDER BY CASE tenure_bucket WHEN '0-6 Months' THEN 1 WHEN '6-12 Months' THEN 2 WHEN '1-2 Years' THEN 3
WHEN '2+ Years' THEN 4 END;   --or--
SELECT CASE WHEN tenure < 6 THEN '0-6 Months'WHEN tenure BETWEEN 6 AND 12 THEN '6-12 Months'WHEN tenure BETWEEN 13 AND 24 THEN '1-2 Years'ELSE '2+ Years'END AS tenure_bucket,
COUNT(*) AS total_customers FROM telecom GROUP BY tenure_bucket;

3️⃣0️⃣ From the tenure CTE, find which tenure group churns the most.
WITH tenure_groups AS (SELECT*,CASE WHEN tenure < 6 THEN '0-6 Months'WHEN tenure BETWEEN 6 AND 12 THEN '6-12 Months'WHEN tenure BETWEEN 13 AND 24 THEN '1-2 Years'ELSE '2+ Years'END AS tenure_bucket FROM telecom)
select tenure_bucket ,COUNT(*) AS churned_customers FROM tenure_groups WHERE Churn = 'Yes' GROUP BY tenure_bucket ORDER BY churned_customers DESC;

SECTION 7: WINDOW FUNCTIONS(Advanced analytics – interview gold ⭐)

3️⃣1️⃣ Assign a row number to customers ordered by monthly charges.
SELECT customerID, MonthlyCharges, ROW_NUMBER() OVER (ORDER BY MonthlyCharges DESC) AS row_num FROM telecom;

3️⃣2️⃣ Rank customers based on monthly charges.
select customerid, monthlycharges, rank() over(order by monthlycharges desc) as rank_ from telecom;

3️⃣3️⃣ Show each customer’s monthly charges along with overall average (without collapsing rows).
SELECT customerID,MonthlyCharges,ROUND(AVG(MonthlyCharges) OVER (), 2) AS overall_avg_charges FROM telecom;

3️⃣4️⃣ Show average monthly charges per contract using window functions.
SELECT customerID,Contract,MonthlyCharges,ROUND(AVG(MonthlyCharges) OVER (PARTITION BY Contract),2) AS avg_contract_charges FROM telecom;

3️⃣5️⃣ For each customer, calculate difference between their charge and contract average.
select customerid,contract,monthlycharges,round(monthlycharges-avg(monthlycharges)over(partition by contract),2)as diff from telecom;

3️⃣6️⃣ Identify top 3 highest paying customers within each contract type.
SELECT *FROM (SELECT customerID,Contract,MonthlyCharges,ROW_NUMBER() OVER (PARTITION BY Contract ORDER BY MonthlyCharges DESC) AS rn FROM telecom) t WHERE rn <= 3;

🧩 SECTION 8: BUSINESS CASE QUERIES(Real-world thinking)

3️⃣7️⃣ Identify high-risk churn customers:Month-to-month contract ,Monthly charges above average ,Tenure less than 6 months
SELECT customerID,Contract,tenure,MonthlyCharges,Churn FROM telecom WHERE Contract = 'Month-to-month'AND tenure < 6 AND MonthlyCharges >(SELECT AVG(MonthlyCharges)FROM telecom);

3️⃣8️⃣ Find loyal customers:Tenure > 24 months,Not churned,Monthly charges below average
SELECT customerID,Contract,tenure,MonthlyCharges,Churn FROM telecom where tenure>24 and churn='no'and monthlycharges<(SELECT AVG(MonthlyCharges)FROM telecom);


