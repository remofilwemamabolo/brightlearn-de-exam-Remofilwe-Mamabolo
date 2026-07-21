------------------------------------------------------------------ 
-----Staging Data------Schema: dim_city
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.dim_product', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_product ( 
    product_id int identity(1,1) primary key, 
    sku varchar(100) not null,               
    product_name varchar(255) not null, 
    supplier_id int not null, 
    category_id int not null,
    stock_on_hand int not null,        
    reorder_threshold int not null,
    constraint uq_product_sku unique (sku)  
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_product 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_product (sku, product_name, supplier_id, category_id, stock_on_hand, reorder_threshold)
select distinct 
    raw.sku,
    raw.product_name, 
    sup.supplier_id, 
    cat.category_id,
    cast(raw.stock_on_hand as int),     
    cast(raw.reorder_threshold as int)
from stg_db_bright.dbo.bright_raw_data raw 
join stg_db_bright.dbo.dim_category cat on raw.category = cat.category
join stg_db_bright.dbo.dim_supplier sup on raw.supplier = sup.supplier_name 
where raw.sku is not null and ltrim(rtrim(raw.sku)) <> '' 
  and raw.product_name is not null and ltrim(rtrim(raw.product_name)) <> '' and raw.stock_on_hand is not null
  and raw.reorder_threshold is not null;
go 

select * from stg_db_bright.dbo.dim_product