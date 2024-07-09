SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Taruna Mangar
-- Create date: May 12, 2024
-- Description: Inserts data into the Facilities.RoomLocation table.    
-- =============================================
CREATE PROCEDURE [Project3].[Load_RoomLocation]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    DECLARE @RowCount INT;
    
    
    INSERT INTO Facilities.RoomLocation
        (BuildingId, RoomNumber, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    SELECT DISTINCT
        BL.BuildingId AS BuildingId,
        RIGHT(Old.Location, LEN(Old.Location) - CHARINDEX(' ', Old.Location)) AS RoomNumber,
        @GroupMemberUserAuthorizationKey AS UserAuthorizationKey,
        @CurrentTime AS DateAdded,
        @CurrentTime AS DateOfLastUpdate
    FROM 
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Old
    INNER JOIN 
        Facilities.BuildingLocation BL ON BL.BuildingName = LEFT(Old.Location, CHARINDEX(' ', Old.Location) - 1)
    WHERE
        CHARINDEX(' ', Old.Location) > 0;

		SELECT @RowCount = COUNT(*) FROM Facilities.RoomLocation;
			
     EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Inserts data into the Facilities.RoomLocation table.',
        @WorkFlowStepTableRowCount = @RowCount,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;
        
    PRINT 'Room location data load complete.'

    
END
GO
