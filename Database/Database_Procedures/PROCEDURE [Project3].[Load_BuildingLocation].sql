SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Arrafi Talukder
-- Create date: May 14, 2024
-- Description: Inserts data into the Facilities.BuildingLocation table.
-- =============================================
CREATE PROCEDURE [Project3].[Load_BuildingLocation]
    @GroupMemberUserAuthorizationKey INT 
    AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    DECLARE @RowCount INT;
    
        
    INSERT INTO [Facilities].[BuildingLocation]
        (BuildingName, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    SELECT DISTINCT
        LEFT(Old.[Location], CHARINDEX(' ', Old.[Location]) - 1) AS BuildingName,
        @GroupMemberUserAuthorizationKey AS UserAuthorizationKey,
        @CurrentTime AS DateAdded,
        @CurrentTime AS DateOfLastUpdate
    FROM
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Old
    WHERE
        CHARINDEX(' ', Old.[Location]) > 0;  
     
    SELECT @RowCount = COUNT(*) FROM [Facilities].[BuildingLocation];
    
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Inserts data into the Facilities.BuildingLocation table.',
        @WorkFlowStepTableRowCount = @RowCount,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey
    
    PRINT 'Building location data load complete.'

   
END
GO
