------------------------------------------------------------------
-----Staging Data------Schema
-------------------------------------------------------------------

use stg_db_bright;
go

---staging dimensions

if object_id('stg_db_bright.dbo.dim_cashier', 'u') is null
begin
create table stg_db_bright.dbo.dim_cashier
(
	cashier_id int identity(1,1) primary key,
	fullname varchar(255)
);
end
go

----truncate table
truncate table stg_db_bright.dbo.dim_cashier

----inseriting data into staging dim
insert into stg_db_bright.dbo.dim_cashier
select distinct cashier_name
from stg_db_bright.dbo.Bright_Raw_data
go

select * from stg_db_bright.dbo.dim_cashier
