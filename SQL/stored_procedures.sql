-- Updates the processing status for a specific source folder

CREATE PROCEDURE metadata_usp
    @status VARCHAR(50),
    @sourcefoldername VARCHAR(50)
AS
BEGIN
    UPDATE metadata
    SET status = @status
    WHERE sourcefoldername = @sourcefoldername;
END;
GO


-- Resets all metadata records to ready

CREATE PROCEDURE Reset_status_sp
AS
BEGIN
    UPDATE metadata
    SET status = 'ready';
END;
GO
