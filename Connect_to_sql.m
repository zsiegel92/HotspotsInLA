% datasource = 'dbname';
% username = 'username';
% password = 'pwd';
% driver = 'org.postgresql.Driver';
% url = 'jdbc:postgresql://host:port/dbname';
% conn = database(datasource,username,password,driver,url)



% To use the driver with the JDBC DriverManager, use com.mysql.jdbc.Driver as the class that
% implements java.sql.Driver

datasource = 'arrests';
instanceConnectionName = 'arrests';
username = 'root';
password = 'hotspots';
driver = 'com.mysql.jdbc.Driver';
jdbcUrl = sprintf('jdbc:mysql://google/%s?cloudSqlInstance=%s&socketFactory=com.google.cloud.sql.mysql.SocketFactory', datasource, instanceConnectionName);


% conn = database(datasource,username,password,driver,jdbcUrl)
conn = database(datasource,username,password,driver,jdbcUrl)