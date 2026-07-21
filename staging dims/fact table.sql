------------------------------------------------------------------ 
-----Staging Data------Schema fact_sales
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
------------------------------------------------------------------ 
-----Staging Data------Schema fact_sales 
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.fact_sales', 'u') is null 
begin 
create table stg_db_bright.dbo.fact_sales ( 
    sales_id int identity(1,1) primary key, 
    date_id int not null, 
    payment_method_id int not null, 
    store_id int not null, 
    product_id int not null, 
    customer_id int not null, 
    cashier_name varchar(255) null, 
    quantity int not null, 
    unit_price decimal(18,2) not null, 
    cost_price decimal(18,2) not null, 
    transaction_amount decimal(18,2) not null, 
    transaction_discount decimal(18,2) not null, 
    line_amount decimal(18,2) not null 
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.fact_sales 
go 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.fact_sales ( 
    date_id, 
    payment_method_id, 
    store_id, 
    product_id, 
    customer_id, 
    cashier_name, 
    quantity, 
    unit_price, 
    cost_price, 
    transaction_amount, 
    transaction_discount, 
    line_amount 
) 
select 
    d.date_id, 
    p.payment_method_id,
    s.store_id, 
    prod.product_id, 
    cust.customer_id, 
    raw.cashier_name, 
    cast(raw.qty as int) as quantity, 
    cast(raw.unit_price as decimal(18,2)) as unit_price, 
    cast(raw.cost_price as decimal(18,2)) as cost_price, 
    cast(raw.transaction_amount as decimal(18,2)) as transaction_amount, 
    cast(raw.transaction_discount as decimal(18,2)) as transaction_discount, 
    cast(raw.line_amount as decimal(18,2)) as line_amount 
from stg_db_bright.dbo.bright_raw_data raw 
join stg_db_bright.dbo.dim_date d on try_convert(date, raw.transaction_date) = d.transaction_date 
-- updated to use your corrected table name 'dim_payment_method'
join stg_db_bright.dbo.dim_payment_method p on raw.payment_method = p.type 
join stg_db_bright.dbo.dim_province s_prov on raw.store_province = s_prov.store_province 
join stg_db_bright.dbo.dim_city s_city on raw.store_city = s_city.store_city and s_city.province_id = s_prov.province_id 
join stg_db_bright.dbo.dim_store s on raw.store_name = s.store_name and s.city_id = s_city.city_id 
join stg_db_bright.dbo.dim_product prod on raw.sku = prod.sku 
join stg_db_bright.dbo.dim_customer_province c_prov on raw.customer_province = c_prov.customer_province 
join stg_db_bright.dbo.dim_customer_city c_city on raw.customer_city = c_city.customer_city and c_city.customer_province_id = c_prov.customer_province_id 
join stg_db_bright.dbo.dim_customer cust on raw.customer_first_name = cust.customer_first_name 
                                        and raw.customer_last_name = cust.customer_last_name 
                                        and cust.customer_city_id = c_city.customer_city_id; 
go 

select * from stg_db_bright.dbo.fact_sales

