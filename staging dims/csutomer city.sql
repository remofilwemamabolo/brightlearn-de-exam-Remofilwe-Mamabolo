------------------------------------------------------------------ 
-----Staging Data------Schema
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.dim_customer_city', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_customer_city ( 
    customer_city_id int identity(1,1) primary key, 
    customer_city varchar(255) not null,
    customer_province_id int not null,
    constraint uq_customer_city_province unique (customer_city, customer_province_id)
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_customer_city 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_customer_city (customer_city, customer_province_id)
select distinct raw.customer_city, prov.customer_province_id
from stg_db_bright.dbo.bright_raw_data raw
join stg_db_bright.dbo.dim_customer_province prov on raw.customer_province = prov.customer_province
where raw.customer_city is not null and ltrim(rtrim(raw.customer_city)) <> '';
go 

select * from stg_db_bright.dbo.dim_customer_city
