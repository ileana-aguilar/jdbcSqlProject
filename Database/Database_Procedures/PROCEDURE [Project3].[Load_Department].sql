SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Ileana Aguilar
-- Create date: May 11, 2024
-- Description: Inserts data into the Academic.Department table and updates workflow step with row count.
-- =============================================
CREATE PROCEDURE [Project3].[Load_Department]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    DECLARE @RowCount INT;

    
    INSERT INTO [Academic].[Department]
        (DepartmentName, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    SELECT DISTINCT
        LEFT(Old.[Course (hr, crd)], CHARINDEX(' ', Old.[Course (hr, crd)]) - 1) AS DepartmentName,
        @GroupMemberUserAuthorizationKey AS UserAuthorizationKey,
        @CurrentTime AS DateAdded,
        @CurrentTime AS DateOfLastUpdate
    FROM
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Old
    WHERE
        CHARINDEX(' ', Old.[Course (hr, crd)]) > 0;  

    
    SELECT @RowCount = COUNT(*) FROM [Academic].[Department];

    
    EXEC [Process].[usp_TrackWorkFlows] 
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Inserts data into the Academic.Department table.',
        @WorkFlowStepTableRowCount = @RowCount,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    PRINT 'Department data load complete.';
END
GO
