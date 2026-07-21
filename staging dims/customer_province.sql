------------------------------------------------------------------ 
-----Staging Data------Schema
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.dim_customer_province', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_customer_province ( 
    customer_province_id int identity(1,1) primary key, 
    customer_province varchar(255) not null unique
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_customer_province 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_customer_province (customer_province)
select distinct customer_province 
from stg_db_bright.dbo.bright_raw_data 
where customer_province is not null and ltrim(rtrim(customer_province)) <> '';
go 

select * from stg_db_bright.dbo.dim_customer_province
