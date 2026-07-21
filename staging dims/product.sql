------------------------------------------------------------------ 
-----Staging Data------Schema: dim_city
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.dim_product', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_product ( 
    product_id int identity(1,1) primary key, -- surrogate key used for fact joins
    sku varchar(100) not null,                -- your business key from raw data
    product_name varchar(255) not null, 
    supplier_id int not null, 
    category_id int not null,
    constraint uq_product_sku unique (sku)   -- guarantees each SKU only appears once
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_product 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_product (sku, product_name, supplier_id, category_id)
select distinct 
    raw.sku, -- pulls the raw business key identifier
    raw.product_name, 
    sup.supplier_id, 
    cat.category_id  
from stg_db_bright.dbo.bright_raw_data raw 
join stg_db_bright.dbo.dim_category cat on raw.category = cat.category
join stg_db_bright.dbo.dim_supplier sup on raw.supplier = sup.supplier_name 
where raw.sku is not null and ltrim(rtrim(raw.sku)) <> '' 
  and raw.product_name is not null and ltrim(rtrim(raw.product_name)) <> '';
go 

select * from stg_db_bright.dbo.dim_product