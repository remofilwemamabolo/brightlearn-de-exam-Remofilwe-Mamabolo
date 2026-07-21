------------------------------------------------------------------ 
-----Staging Data------Schema: dim_city
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.dim_city', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_city ( 
    city_id int identity(1,1) primary key, 
    store_city varchar(255) not null,
    province_id int not null,
    constraint uq_city_province unique (store_city, province_id) 
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_city 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_city (store_city, province_id)
select distinct raw.store_city, prov.province_id
from stg_db_bright.dbo.bright_raw_data raw
-- fixed mapping: raw column matches to province_name
join stg_db_bright.dbo.dim_province prov on raw.store_province = prov.province_name
where raw.store_city is not null and ltrim(rtrim(raw.store_city)) <> '';
go 

select * from stg_db_bright.dbo.dim_city
