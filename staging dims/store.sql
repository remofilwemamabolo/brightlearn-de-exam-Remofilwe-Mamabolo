------------------------------------------------------------------ 
-----Staging Data------Schema: dim_store
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.dim_store', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_store ( 
    store_id int identity(1,1) primary key, 
    store_name varchar(255) not null,
    city_id int not null,
    store_manager varchar(255) not null
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_store 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_store (store_name, city_id,store_manager)
select distinct raw.store_name, city.city_id, store_manager
from stg_db_bright.dbo.bright_raw_data raw
join stg_db_bright.dbo.dim_city city on raw.store_city = city.store_city
where raw.store_name is not null and ltrim(rtrim(raw.store_name)) <> '';
go 

select * from stg_db_bright.dbo.dim_store
