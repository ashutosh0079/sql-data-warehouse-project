/*
===============================================================================
Data Cleaning Steps
===============================================================================
*/
--For table Crm_cust_info
--Checking for the NULLS or Duplicates
select cst_id,count(*) from bronze.crm_cust_info
group by cst_id having COUNT(*)>1 or cst_id is null;

-- Checking for the extra spaces
select cst_firstname from bronze.crm_cust_info
where cst_firstname !=TRIM(cst_firstname);

--For table Crm_prd_info  
--Check for prd_key and split it  
select prd_id,
replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt 
from bronze.crm_prd_info
where replace(SUBSTRING(prd_key,1,5),'-','_') not in (select distinct(ID) from bronze.erp_PX_CAT_G1V2);

--checking for unwanted spaces
select prd_nm from  bronze.crm_prd_info
where prd_nm!=TRIM(prd_nm)

--check for invalid date
select *,
LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as prd_end_dt
from bronze.crm_prd_info;
