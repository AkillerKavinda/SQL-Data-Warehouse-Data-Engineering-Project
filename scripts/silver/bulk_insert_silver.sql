create or alter procedure silver.load_silver
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
		print 'starting silver layer load';
		print '================================================';

		/*==================================================
                          crm tables
		==================================================*/
		print '------------------------------------------------';
		print 'loading crm tables (bronze -> silver)';
		print '------------------------------------------------';

		----------------------------------------------------
		-- crm customer
		----------------------------------------------------
		set @start_time = getdate();

		truncate table silver.crm_cust_info;

		insert into silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		select
			cst_id,
			cst_key,
			ltrim(rtrim(cst_first_name)) as cst_firstname,
			ltrim(rtrim(cst_last_name)) as cst_lastname,
			case 
				when cst_marital_status in ('M','Married') then 'married'
				when cst_marital_status in ('S','Single') then 'single'
				else 'n/a'
			end as cst_marital_status,
			case 
				when cst_gndr in ('M','Male') then 'male'
				when cst_gndr in ('F','Female') then 'female'
				else 'n/a'
			end as cst_gndr,
			try_convert(date, cst_create_date) as cst_create_date
		from bronze.crm_cust_info;

		set @end_time = getdate();
		print '>> crm_cust_info load duration: ' 
			+ cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- crm product
		----------------------------------------------------
		set @start_time = getdate();

		truncate table silver.crm_prd_info;

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
			left(prd_key, 5) as cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			case 
				when prd_line = 'R' then 'road'
				when prd_line = 'M' then 'mountain'
				when prd_line = 'S' then 'standard'
				when prd_line = 'T' then 'touring'
				else 'n/a'
			end as prd_line,
			cast(prd_start_dt as date),
			cast(prd_end_dt as date)
		from bronze.crm_prd_info;

		set @end_time = getdate();
		print '>> crm_prd_info load duration: ' 
			+ cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- crm sales
		----------------------------------------------------
		set @start_time = getdate();

		truncate table silver.crm_sales_details;

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
			try_convert(date, sls_order_dt) as sls_order_dt,
			try_convert(date, sls_ship_dt) as sls_ship_dt,
			try_convert(date, sls_due_dt) as sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		from bronze.crm_sales_details;

		set @end_time = getdate();
		print '>> crm_sales_details load duration: ' 
			+ cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		/*==================================================
                          erp tables
		==================================================*/
		print '------------------------------------------------';
		print 'loading erp tables (bronze -> silver)';
		print '------------------------------------------------';

		----------------------------------------------------
		-- erp location
		----------------------------------------------------
		set @start_time = getdate();

		truncate table silver.erp_loc_a101;

		insert into silver.erp_loc_a101 (cid, cntry)
		select
			cid,
			cntry
		from bronze.erp_loc_a101;

		set @end_time = getdate();
		print '>> erp_loc_a101 load duration: ' 
			+ cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- erp customer
		----------------------------------------------------
		set @start_time = getdate();

		truncate table silver.erp_cust_az12;

		insert into silver.erp_cust_az12 (cid, bdate, gen)
		select
			cid,
			try_convert(date, bdate),
			case 
				when gen in ('M','Male') then 'male'
				when gen in ('F','Female') then 'female'
				else 'n/a'
			end
		from bronze.erp_cust_az12;

		set @end_time = getdate();
		print '>> erp_cust_az12 load duration: ' 
			+ cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- erp product category
		----------------------------------------------------
		set @start_time = getdate();

		truncate table silver.erp_px_cat_g1v2;

		insert into silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
		select
			id,
			cat,
			subcat,
			maintenance
		from bronze.erp_px_cat_g1v2;

		set @end_time = getdate();
		print '>> erp_px_cat_g1v2 load duration: ' 
			+ cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		----------------------------------------------------
		-- end total batch timer
		----------------------------------------------------
		set @batch_end_time = getdate();

		print '================================================';
		print 'silver layer load completed successfully';
		print '================================================';

		print 'batch start time: ' + cast(@batch_start_time as nvarchar);
		print 'batch end time: ' + cast(@batch_end_time as nvarchar);

		print 'total load time (seconds): ' 
			+ cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar);

		print '================================================';

	end try

	begin catch
		print '================================================';
		print 'error occurred during silver layer load';
		print 'error message: ' + error_message();
		print 'error number: ' + cast(error_number() as nvarchar);
		print 'error state: ' + cast(error_state() as nvarchar);
		print '================================================';
	end catch

end;

exec silver.load_silver;