SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Ileana Aguilar
-- Create date: May 12, 2024
-- Description: Inserts data into the Academic.Instructor table.
-- =============================================
CREATE PROCEDURE [Project3].[Load_Instructor]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    DECLARE @RowCount INT;

    
    INSERT INTO Academic.Instructor
        (LastName, FirstName, DepartmentsTaught, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    SELECT DISTINCT
        SUBSTRING(Old.Instructor, 1, CHARINDEX(',', Old.Instructor) - 1) AS LastName,
        LTRIM(SUBSTRING(Old.Instructor, CHARINDEX(',', Old.Instructor) + 1, LEN(Old.Instructor))) AS FirstName,
        COUNT(DISTINCT AD.DepartmentId) AS DepartmentsTaught,
        @GroupMemberUserAuthorizationKey AS UserAuthorizationKey,
        @CurrentTime AS DateAdded,
        @CurrentTime AS DateOfLastUpdate
    FROM 
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Old
    INNER JOIN 
        [Academic].[Department] AD ON LEFT(Old.[Course (hr, crd)], CHARINDEX(' ', Old.[Course (hr, crd)]) - 1) = AD.DepartmentName
    WHERE
        CHARINDEX(',', Old.Instructor) > 0
    GROUP BY
        SUBSTRING(Old.Instructor, 1, CHARINDEX(',', Old.Instructor) - 1),
        LTRIM(SUBSTRING(Old.Instructor, CHARINDEX(',', Old.Instructor) + 1, LEN(Old.Instructor)));

   
    SELECT @RowCount = COUNT(*) FROM Academic.Instructor;

   
    EXEC [Process].[usp_TrackWorkFlows] 
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Inserts data into the Academic.Instructor table.',
        @WorkFlowStepTableRowCount = @RowCount,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    PRINT 'Instructor data load complete.';
END
GO
