------------------------------------------------------------------
-----Staging Data------Schema
-------------------------------------------------------------------

use stg_db_bright;
go

---staging dimensions

if object_id('stg_db_bright.dbo.dim_payement_method', 'u') is null
begin
create table stg_db_bright.dbo.dim_payement_method
(
	payment_method_id int identity(1,1) primary key,
	type varchar(255)
);
end
go

----truncate table
truncate table stg_db_bright.dbo.dim_payement_method

----inseriting data into staging dim
insert into stg_db_bright.dbo.dim_payement_method
select distinct payment_method
from stg_db_bright.dbo.Bright_Raw_data
go

select * from stg_db_bright.dbo.dim_payement_method
