DECLARE @Success BIT = 0;
DECLARE @Attempt INT = 1;
DECLARE @MaxAttempts INT = 10;

WHILE @Success = 0 BEGIN

	BEGIN TRY

	    --Replace this with a script that might eventually work
	    SELECT 1 / 0

	    SET @Success = 1;
	END TRY
	BEGIN CATCH
		DECLARE @Message NVARCHAR(MAX) = ERROR_MESSAGE() + ' - attempt ' + CAST(@Attempt as NVARCHAR(10));
		RAISERROR (@Message, 1, 1)
		SET @Attempt += 1;
		SET @Success = 0;
	END CATCH
	IF @Attempt > @MaxAttempts BEGIN
		RAISERROR ('Exceeded max attempts (%i)', 16, 1, @MaxAttempts)
		BREAK
	END
END
