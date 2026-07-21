if not exists( select * from sys.databases where name = 'dwh_db_bright')
begin
create database dwh_db_bright
end;