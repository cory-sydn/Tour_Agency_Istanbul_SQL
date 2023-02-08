# Tour_Agency_Istanbul_SQL

Make sure your SQL server version and database management studio version is compatible.

```
SELECT @@VERSION
```
<br>
Firstly create database and tables by running "CreateTables.sql".


Run "ProcViewFunctionTrigger.sql" creates stored procedures, functions views and triggers for production version functionalities.


Run "DummyDataTesting.sql" for testing tour sale and invoice functionalities.


[sp_Registered Tourist Detection] trigger prevents double data entry for the same tourist and returns the tourist's informations.


All functionalities can be found at "Functionalities.sql".