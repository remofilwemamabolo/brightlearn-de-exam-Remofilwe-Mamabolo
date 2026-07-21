------------------------------------------------------------------ 
-----Staging Data------Schema 
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.dim_date', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_date ( 
    date_id int identity(1,1) primary key, 
    transaction_date date not null, 
    month_name varchar(255) not null 
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_date 

-- clean raw data delete rows where the transaction date is empty, blank space, or unconvertible
delete from stg_db_bright.dbo.Bright_Raw_data
where transaction_date is null 
   or ltrim(rtrim(transaction_date)) = ''
   or try_convert(date, transaction_date) is null;
go

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_date(transaction_date, month_name) 
select distinct 
    try_convert(date, transaction_date), 
    datename(month, try_convert(date, transaction_date))
from stg_db_bright.dbo.Bright_Raw_data 
where try_convert(date, transaction_date) is not null; 
go 

select * from stg_db_bright.dbo.dim_date
