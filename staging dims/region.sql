------------------------------------------------------------------
-----Staging Data------Schema
-------------------------------------------------------------------

use stg_db_bright;
go

---staging dimensions

if object_id('stg_db_bright.dbo.dim_region', 'u') is null
begin
create table stg_db_bright.dbo.dim_region
(
	region_id int identity(1,1) primary key,
	store_region varchar(255)
);
end
go

----truncate table
truncate table stg_db_bright.dbo.dim_region

----inseriting data into staging dim
insert into stg_db_bright.dbo.dim_region
select distinct store_region
from stg_db_bright.dbo.Bright_Raw_data
go

select * from stg_db_bright.dbo.dim_region


