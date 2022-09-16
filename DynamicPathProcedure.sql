CREATE PROCEDURE dbo.DynamicSQLForFilepath
	@Storageaccount varchar(100),
	@Filepath varchar(400),
	@Format varchar(40),
	@Datasource varchar(100)= NULL, 
	@AmountOfWildcards int NULL, 
 	@CreateView bit = NULL,
	@Schemaname varchar(20)=NULL,
	@ObjectName varchar(40) = NULL,
	@Fieldterminator varchar(20) = NULL, 
	@Rowterminator varchar(20) = NULL, 
	@HeaderRow bit = NULL,
	@schema varchar(max) = NULL
AS
BEGIN
-- Declare DynamicSQL variable
DECLARE @CMD varchar(MAX) 
-- Declare counter to loop WIldcards
DECLARE @c int = 1

-- Check if we need to create a view or just execute a query
	SET @CMD = 'SELECT
		*'

	IF @AmountOfWildcards > 0 OR @AmountOfWildcards is not null
	BEGIN
		
		--- Iterate all wildcards and add them as columns
		WHILE @c <= @AmountOfWildcards
		BEGIN
			SET @CMD = @CMD + ',result.filepath('+cast(@c as varchar(10))+') as FilePath'+cast(@c as varchar(10))+''
			SET @c = @c+1

		END
		SET @c = 1
		
		--- Add in Storage account and Filepath which will be hardcoded 
		SET @CMD = @CMD + '
		FROM 
			OPENROWSET(
				BULK''https://'+@storageaccount+'.dfs.core.windows.net/'+@Filepath+'/'
		

		--- Loop and add wildcards at the end of the path
		WHILE @c <= @AmountOfWildcards
		BEGIN
			SET @CMD = @CMD + '*/'
			SET @c = @c+1
		END

		-- Adding wildcards to read all files in the structure
		SET @CMD = @CMD + '**'''

		-- Adding 
		IF @Datasource IS NOT NULL
		BEGIN
			SET @CMD = @CMD + ',
			DATA_SOURCE = '+@Datasource
		END

		-- if the format is CSV we need to add Parser
		IF UPPER(@Format) = 'CSV'
		BEGIN

			SET @CMD = @CMD + ',
			FORMAT='''+@Format+''',
			PARSER_VERSION = ''2.0''
		'
			-- Check if we have a Fieldterminator
			IF @Fieldterminator IS NOT NULL
			BEGIN
			SET @CMD = @CMD + ',
			FIELDTERMINATOR = '''+@Fieldterminator+''''
			END

			-- Check if we have a Rowterminator
			IF @Rowterminator IS NOT NULL
			BEGIN
			SET @CMD = @CMD + ',
			ROWTERMINATOR = '''+@Rowterminator+''''
			END

			-- Check if we have a Headerrow
			IF @HeaderRow IS NOT NULL AND @HeaderRow = 1
			BEGIN
			SET @CMD = @CMD + ',
			HEADER_ROW = TRUE'
			END

		END

		ELSE
		BEGIN
		
		-- Add format to the command
		SET @CMD = @CMD + ',
			FORMAT='''+@Format+'''
		'
		END
	END

	-- Close off the Openrowset part
	SET @CMD = @CMD + '
	)'


	-- If a schema is specified use that
	IF @schema is not null
	BEGIN
	SET @CMD = @CMD +'WITH (
	'+@schema+'
	)'
	END

	-- If create view is specified add create view
	IF @CreateView = 1
	BEGIN

		IF @CreateView = 1 and @Schemaname is null
		BEGIN
		PRINT 'No schemaname provided for view'
		END
		ELSE
			IF @CreateView = 1 and @ObjectName is null
			BEGIN
			PRINT 'No objectname provided for view'
			END
		ELSE
		BEGIN
		SET @CMD = 'CREATE VIEW '+@Schemaname+'.'+@ObjectName+' 
		AS
		'+@CMD+' AS [result];'
		PRINT @CMD
		END
	END
	ELSE
	BEGIN
	SET @CMD = @CMD + 'AS [result];'
	PRINT @CMD
	END



END;

GO

