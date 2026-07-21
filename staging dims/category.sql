------------------------------------------------------------------
-----Staging Data------Schema
-------------------------------------------------------------------

use stg_db_bright;
go

---staging dimensions

if object_id('stg_db_bright.dbo.dim_category', 'u') is null
begin
create table stg_db_bright.dbo.dim_category
(
	category_id int identity(1,1) primary key,
	category varchar(255) not null
);
end
go

----truncate table
truncate table stg_db_bright.dbo.dim_category

----inseriting data into staging dim
insert into stg_db_bright.dbo.dim_category
select distinct category
from stg_db_bright.dbo.Bright_Raw_data
where category is not null and ltrim(rtrim(category)) <> ''; 
go

select * from stg_db_bright.dbo.dim_category


