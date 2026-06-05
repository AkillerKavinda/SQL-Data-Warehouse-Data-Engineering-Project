create or alter procedure bronze.load_bronze
as
begin

	declare @start_time datetime, 
			@end_time datetime, 
			@batch_start_time datetime, 
			@batch_end_time datetime;

	begin try

		----------------------------------------------------
		-- start total batch timer
		----------------------------------------------------
		set @batch_start_time = getdate();

		print '================================================';
		print 'starting bronze layer load';
		print '================================================';

		/*==================================================
                          crm tables
		==================================================*/
		print '------------------------------------------------';
		print 'loading crm tables';
		print '------------------------------------------------';

		----------------------------------------------------
		-- crm customer
		----------------------------------------------------
		set @start_time = getdate();

		print '>> truncating table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;

		print '>> inserting data into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\kavin\Music\SQL-Data-Warehouse-Data-Engineering-Project\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- crm product
		----------------------------------------------------
		set @start_time = getdate();

		print '>> truncating table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;

		print '>> inserting data into: bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'C:\Users\kavin\Music\SQL-Data-Warehouse-Data-Engineering-Project\datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- crm sales
		----------------------------------------------------
		set @start_time = getdate();

		print '>> truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;

		print '>> inserting data into: bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from 'C:\Users\kavin\Music\SQL-Data-Warehouse-Data-Engineering-Project\datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		/*==================================================
                          erp tables
		==================================================*/
		print '------------------------------------------------';
		print 'loading erp tables';
		print '------------------------------------------------';

		----------------------------------------------------
		-- erp location
		----------------------------------------------------
		set @start_time = getdate();

		print '>> truncating table: bronze.erp_loca101';
		truncate table bronze.erp_loca101;

		print '>> inserting data into: bronze.erp_loca101';
		bulk insert bronze.erp_loca101
		from 'C:\Users\kavin\Music\SQL-Data-Warehouse-Data-Engineering-Project\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- erp customer
		----------------------------------------------------
		set @start_time = getdate();

		print '>> truncating table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;

		print '>> inserting data into: bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\kavin\Music\SQL-Data-Warehouse-Data-Engineering-Project\datasets\source_erp\CUST_AZ12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- erp product category
		----------------------------------------------------
		set @start_time = getdate();

		print '>> truncating table: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;

		print '>> inserting data into: bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\kavin\Music\SQL-Data-Warehouse-Data-Engineering-Project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- end total batch timer
		----------------------------------------------------
		set @batch_end_time = getdate();

		print '================================================';
		print 'bronze layer load completed successfully';
		print '================================================';

		print 'batch start time: ' + cast(@batch_start_time as nvarchar);
		print 'batch end time: ' + cast(@batch_end_time as nvarchar);

		print 'total load time (seconds): ' 
			+ cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar);

		print '================================================';

	end try

	begin catch
		print '================================================';
		print 'error occurred during bronze layer load';
		print 'error message: ' + error_message();
		print 'error number: ' + cast(error_number() as nvarchar);
		print 'error state: ' + cast(error_state() as nvarchar);
		print '================================================';
	end catch

end;