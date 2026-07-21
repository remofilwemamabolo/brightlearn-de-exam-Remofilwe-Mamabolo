if not exists( select * from sys.databases where name = 'stg_db_bright')
begin
create database stg_db_bright
end;