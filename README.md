# ServerlessCode

<h1>Variables and Usage</h1>

Required Variables 
@Storageaccount = your storage accountname
@Filepath = the full filepath you want to embed in your query/view
@Format = the format of the file you are using (Parquet/CSV/Delta)

Optional Variables
@Datasource = Name of the datasource you are using (In development)
@AmountOfWildcards = Amount of wildcardfolders you want to add after you filepath
@CreateView = create a view or generate a query
@SchemaName = Schemaname to use to create your view
@ObjectName = Viewname you want to use for your view
@FieldTerminator = Other than default field terminator when using CSV
@Rowterminator = Other than default row terminator when using CSV
@HeaderRow = CSV contains header row or not
@Schema = Columnlist with datatypes defined

SampleExecution

EXEC dbo.DynamicSQLForFilepath 'synapseinaday','Firstfolder/Secondpartition','PARQUET','test',0,0;

EXEC dbo.DynamicSQLForFilepath 'synapseinaday','test','CSV';

EXEC dbo.DynamicSQLForFilepath 'synapseinaday','test/theyear=2010/themonth=02','Delta','test',4,1,'dbo','test';
