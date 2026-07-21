------------------------------------------------------------------
-----Staging Data------Schema
-------------------------------------------------------------------

use stg_db_bright;
go

---staging dimensions
---------province
if object_id('stg_db_bright.dbo.dim_province', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_province ( 
    province_id int identity(1,1) primary key, 
    store_province varchar(255) not null unique,
    region_id int not null
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_province 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_province
select distinct raw.store_province, reg.region_id
from stg_db_bright.dbo.bright_raw_data raw
join stg_db_bright.dbo.dim_region reg on raw.store_region = reg.store_region
where raw.store_province is not null and ltrim(rtrim(raw.store_province)) <> '';
go 

select * from stg_db_bright.dbo.dim_province