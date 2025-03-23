/*
===============================================================
Description:  
This script defines a stored procedure `bronze.load_bronze` that loads data into the Bronze layer 
of a data warehouse from CSV files. The script follows these steps:

1. Truncates existing tables in the Bronze schema to ensure fresh data.
2. Loads data using the `BULK INSERT` command from specified CSV files.
3. Tracks load times for each dataset and logs progress messages.
4. Implements error handling to catch and display any issues encountered.

Usage:
- Execute the stored procedure using:  
  ```sql
  EXEC bronze.load_bronze;
*/


create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime, @end_time datetime, @start_time_batch datetime, @end_time_batch datetime;

	begin try
		set @start_time_batch = GETDATE();
		print '========================================';
		print 'Loading Bronze Layer';
		print '========================================';

		print'--------------------------------------';
		print 'Loading Crm tables';
		print '-------------------------------------';

		set @start_time = getdate()

		print '>> Truncating Table: bronze.crm_cust_info';
		print '>> Inserting Data Into: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;
		bulk insert bronze.crm_cust_info
		from 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		); 

		set @end_time = GETDATE();
		print '>> Load Durations: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
		print '>> ----------------------';

		set @start_time = GETDATE();

		print '>> Truncating Table: bronze.crm_prd_info';
		print '>> Inserting Data Into: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		bulk insert bronze.crm_prd_info
		from 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		); 

		set @end_time = GETDATE();
		print '>> Load Durations: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
		print '>> ----------------------';

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.crm_sales_details';
		print '>> Inserting Data Into: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		bulk insert bronze.crm_sales_details
		from 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		); 
		set @end_time = GETDATE();
		print '>> Load Durations: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
		print '>> ----------------------';
	

		print'--------------------------------------';
		print 'Loading erp tables';
		print '-------------------------------------';

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_cust_az12';
		print '>> Inserting Data Into: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;
		bulk insert bronze.erp_cust_az12
		from 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\datasets\source_erp\cust_az12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		); 
		set @end_time = GETDATE();
		print '>> Load Durations: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
		print '>> ----------------------';

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_loc_a101';
		print ' >> Inserting Data Into: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		bulk insert bronze.erp_loc_a101
		from 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\datasets\source_erp\loc_a101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		); 
		set @end_time = GETDATE();
		print '>> Load Durations: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
		print '>> ----------------------';

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_px_cat_g1v2';
		print '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\datasets\source_erp\px_cat_g1v2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		); 
		set @end_time = GETDATE();
		print '>> Load Durations: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
		print '>> ----------------------';
	
		set @end_time_batch = GETDATE();
		print '=======================================';
		print 'Loading Bronze Layer is Comleted';
		print '>> Load Duration of the whole bronze layer: ' + cast(datediff(second, @start_time_batch, @end_time_batch) as nvarchar) + ' seconds';
		print '=======================================';
	end try
	begin catch
		print '=================================================';
		print 'ERROR OCCURED DURING LOADING BROZNZE LAYER';
		print 'Error message ' + error_message();
		print 'Error message ' + cast(error_number() as nvarchar);
		print 'Error message ' + cast(error_state() as nvarchar);
		print '=================================================';
	end catch
end