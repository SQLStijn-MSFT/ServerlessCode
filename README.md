# ServerlessCode

<h1>Variables and Usage</h1>

<h2>Required Variables </h2>
@Storageaccount = your storage accountname <br>
@Filepath = the full filepath you want to embed in your query/view<br>
@Format = the format of the file you are using (Parquet/CSV/Delta)<br>

<h2>Optional Variables</h2>
@Datasource = Name of the datasource you are using (In development)<br>
@AmountOfWildcards = Amount of wildcardfolders you want to add after you filepath<br>
@CreateView = create a view or generate a query<br>
@SchemaName = Schemaname to use to create your view<br>
@ObjectName = Viewname you want to use for your view<br>
@FieldTerminator = Other than default field terminator when using CSV<br>
@Rowterminator = Other than default row terminator when using CSV<br>
@HeaderRow = CSV contains header row or not<br>
@Schema = Columnlist with datatypes defined<br>

<h2>SampleExecution</h2>

EXEC dbo.DynamicSQLForFilepath 'synapseinaday','Firstfolder/Secondpartition','PARQUET','test',0,0;<br>

EXEC dbo.DynamicSQLForFilepath 'synapseinaday','test','CSV';<br>

EXEC dbo.DynamicSQLForFilepath 'synapseinaday','test/theyear=2010/themonth=02','Delta','test',4,1,'dbo','test';<br>
