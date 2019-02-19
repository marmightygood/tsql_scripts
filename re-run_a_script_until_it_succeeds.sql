
DECLARE @Success BIT = 0;
DECLARE @Attempt INT = 1;

WHILE @Success = 0 BEGIN

	BEGIN TRY

	    --Script to re-run goes here

	    SET @Success = 1;
	END TRY
	BEGIN CATCH
	    DECLARE @Message NVARCHAR(MAX);
	    SELECT @Message = CONVERT(VARCHAR(30), GETDATE(), 120) +  '' + ' - attempt ' + CAST(@Attempt as NVARCHAR(10));
			RAISERROR (@Message, 1, 1)
			SET @Attempt += 1;
			SET @Success = 0;
	END CATCH

END
