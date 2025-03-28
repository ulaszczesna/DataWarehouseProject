print ' >> Truncating Table: silver.crm_cust_info ';
truncate table  silver.crm_cust_info
print ' >> Inserting Data Into: silver.crm_cust_info ';
insert into silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_martial_status,
	cst_gndr,
	cst_create_date)
select 
cst_id,
cst_key, 
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
	case when upper(cst_martial_status) = 'S' then 'Single'
		 when upper(cst_martial_status) = 'M' then 'Married'
		 else 'n/a'
	end
cst_martial_status, -- Converting martial status into readable format and handeling nulls
	case when upper(cst_gndr) = 'F' then 'Female'
		 when upper(cst_gndr) = 'M' then 'Male'
		 else 'Unknown'
	end cst_gndr, -- Converting gender info into readable format and handeling nulls
cst_create_date
from (

select 
* ,
row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
where cst_id is not null
) t
where flag_last = 1 -- Selecting the most recent record per customer


print ' >> Truncating Table: silver.crm_prd_info ';
truncate table  silver.crm_cust_info
print ' >> Inserting Data Into: silver.crm_prd_info ';

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



print ' >> Truncating Table: silver.crm_sales_details ';
truncate table  silver.crm_cust_info
print ' >> Inserting Data Into: silver.crm_sales_details ';


insert into silver.crm_sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)

select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
case when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
	else cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt,
case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
	else cast(cast(sls_ship_dt as varchar) as date)
end as sls_ship_dt,
case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
	else cast(cast(sls_due_dt as varchar) as date)
end as sls_due_dt,
case when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price) 
		then sls_quantity * abs(sls_price)
	else sls_sales 
end as sls_sales, -- Recalculate sales if orginal value is missing or incorect

sls_quantity,
case when sls_price is null or sls_price <= 0 
		then abs(sls_sales) / nullif(sls_quantity, 0)
	else sls_price
end as sls_price -- Get missing price form by calculating it

from bronze.crm_sales_details


print ' >> Truncating Table: silver.erp_cust_az12 ';
truncate table  silver.crm_cust_info
print ' >> Inserting Data Into: silver.erp_cust_az12 ';

insert into silver.erp_cust_az12 (
		cib,
		bdate,
		gen
)

select 
case when cib like 'NAS%' then SUBSTRING(cib, 4, len(cib)) -- Remove 'NAS' prefix if present
	else cib
end as cib,
case when bdate > getdate() then null
	else bdate 
end as bdate, -- Set future birthdates to null
case when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
	 when upper(trim(gen)) in ('M', 'MALE') then 'Male'
	 else 'n/a'
end as gen -- Normalize gender values and handle unknown cases
from bronze.erp_cust_az12


print ' >> Truncating Table: silver.erp_loc_a101 ';
truncate table  silver.crm_cust_info
print ' >> Inserting Data Into: silver.erp_loc_a101 ';

insert into silver.erp_loc_a101 (
		cid,
		cntry)

select 
replace(cid, '-', '') cid,
case when trim(cntry) = 'DE' then 'Germany'
	 when trim(cntry) in ('US', 'USA') then 'United States'
	 when trim(cntry) = '' or cntry is null then 'n/a'
	 else trim(cntry)
end cntry -- Normalize and handle missing or blank country codes
from bronze.erp_loc_a101

print ' >> Truncating Table: silver.erp_cat_g1v2';
truncate table  silver.crm_cust_info
print ' >> Inserting Data Into: silver.erp_cat_g1v2 ';

insert into silver.erp_px_cat_g1v2 (
		id,
		cat,
		subcat,
		maintenance
		)

select 
id, 
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2
