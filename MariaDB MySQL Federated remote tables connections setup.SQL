--Code tested on MariaDB Server version: 10.3.23-MariaDB-0+deb10u1
select version();

--0. Log into mariadb and check if FEDERATED engine is available

show engines;

-- 1. install the federatdb plugin

INSTALL SONAME 'ha_federatedx';

-- check again, and see if the FEDERATED engine is available
show engines; 

-- 2. create server, like db link in SQL Server
CREATE SERVER server_name
FOREIGN DATA WRAPPER mysql
OPTIONS (USER 'username', PASSWORD 'password', HOST 'host', PORT portNumber, DATABASE 'dbName');

-- 3. before select, need to create the table definition in current db
-- option 1, using the server we just created
create table federated_table_name (col1 datatype, col2 datatype.... )  -- same structure as the linked table
ENGINE=FEDERATED 
connection='server_name/table_name';


-- option 2, using the connection string directly
create table federated_table_name (col1 datatype, col2 datatype.... ) 
ENGINE=FEDERATED 
CONNECTION='mysql://username:password@host:port/dbName/tableName';


-- 4. Now we can select from the skeleton table, which points to the remote table, on another server.
select * from federated_table_name

