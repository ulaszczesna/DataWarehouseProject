-- Insert transformed product information into the Silver layer

insert into silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
select 
prd_id,
replace(SUBSTRING(prd_key, 1, 5), '-', '_') as cat_id, --Extract category id
SUBSTRING(prd_key, 7, len(prd_key)) as prd_key, --Extract product key
prd_nm,
isnull(prd_cost, 0) as prd_cost,
case upper(trim(prd_line))
	when 'M' then 'Mountain'
	when 'R' then 'Road'
	when 'S' then 'other Sales'
	when 'T' then 'touring'
	else 'n/a'
end as prd_line, --Map product line codes to descriptive values
cast(prd_start_dt as date) as prd_start_dt, 
cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 as date) 
as prd_end_dt -- Calculate end date as one day before the next start date for this product
from bronze.crm_prd_info




