------------------------------------------------------------------
-----Staging Data------Schema
-------------------------------------------------------------------

use stg_db_bright;
go

---staging dimensions

if object_id('stg_db_bright.dbo.dim_subcategory', 'u') is null
begin
create table stg_db_bright.dbo.dim_subcategory
(
	subcategory_id int identity(1,1) primary key,
	subcategory varchar(255)
);
end
go

----truncate table
truncate table stg_db_bright.dbo.dim_subcategory

----inseriting data into staging dim
insert into stg_db_bright.dbo.dim_subcategory
select distinct sub_category
from stg_db_bright.dbo.Bright_Raw_data
go

select * from stg_db_bright.dbo.dim_subcategory


