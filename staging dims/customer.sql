------------------------------------------------------------------ 
-----Staging Data------Schema
------------------------------------------------------------------- 
use stg_db_bright; 
go 

---staging dimensions 
if object_id('stg_db_bright.dbo.dim_customer', 'u') is null 
begin 
create table stg_db_bright.dbo.dim_customer ( 
    customer_id int identity(1,1) primary key, 
    customer_first_name varchar(255) not null,
    customer_last_name varchar(255) not null,
    customer_email varchar(255) not null,
    customer_phone varchar(255) not null,
    customer_loyalty_tier varchar(255) not null,
    customer_since varchar(255) not null,
    customer_city_id int not null
); 
end 
go 

----truncate table 
truncate table stg_db_bright.dbo.dim_customer 

----inseriting data into staging dim 
insert into stg_db_bright.dbo.dim_customer (
    customer_first_name, 
    customer_last_name, 
    customer_email, 
    customer_phone, 
    customer_loyalty_tier, 
    customer_since, 
    customer_city_id
)
select distinct 
    raw.customer_first_name, 
    raw.customer_last_name, 
    raw.customer_email,case 
        when left(ltrim(raw.customer_phone), 1) = '0' then ltrim(raw.customer_phone)
        else '0' + ltrim(raw.customer_phone)
    end as customer_phone,
    raw.customer_loyalty_tier, 
    raw.customer_since,
    city.customer_city_id
from stg_db_bright.dbo.bright_raw_data raw
join stg_db_bright.dbo.dim_customer_province prov on raw.customer_province = prov.customer_province
join stg_db_bright.dbo.dim_customer_city city on raw.customer_city = city.customer_city and city.customer_province_id = prov.customer_province_id
where raw.customer_first_name is not null and ltrim(rtrim(raw.customer_first_name)) <> ''
  and raw.customer_last_name is not null and ltrim(rtrim(raw.customer_last_name)) <> ''
  and raw.customer_email is not null and ltrim(rtrim(raw.customer_email)) <> '';
go 

select * from stg_db_bright.dbo.dim_customer