SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Carlo Ace Sagad
-- Create date: 05/12/2024
-- Description: Inserts data into the Academic.Course table.    
-- =============================================
CREATE PROCEDURE [Project3].[Load_Course]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
		DECLARE @RowCount INT;

    
    INSERT INTO Academic.Course
        (CourseName, Credits, CourseDescription, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    SELECT DISTINCT
        
        LEFT(Old.[Course (hr, crd)], CHARINDEX('(', Old.[Course (hr, crd)]) - 1) AS CourseName,
        CASE 
            WHEN TRY_CAST(SUBSTRING(Old.[Course (hr, crd)], CHARINDEX('(', Old.[Course (hr, crd)]) + 1, CHARINDEX(',', Old.[Course (hr, crd)]) - CHARINDEX('(', Old.[Course (hr, crd)]) - 1) AS DECIMAL(3,1)) IS NOT NULL 
            THEN TRY_CAST(SUBSTRING(Old.[Course (hr, crd)], CHARINDEX('(', Old.[Course (hr, crd)]) + 1, CHARINDEX(',', Old.[Course (hr, crd)]) - CHARINDEX('(', Old.[Course (hr, crd)]) - 1) AS DECIMAL(3,1))
            ELSE 0.0
        END AS Credits,
        Old.[Description] AS CourseDescription,
        @GroupMemberUserAuthorizationKey AS UserAuthorizationKey,
        @CurrentTime AS DateAdded,
        @CurrentTime AS DateOfLastUpdate
    FROM
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Old
    WHERE
        CHARINDEX('(', Old.[Course (hr, crd)]) > 0 AND
        CHARINDEX(',', Old.[Course (hr, crd)]) > 0;
        
    SELECT @RowCount = COUNT(*) FROM [Academic].[Department];
    
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Inserts data into the Academic.Course table.',
        @WorkFlowStepTableRowCount = @RowCount,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;
        
    PRINT 'Course data load complete.'
END
GO
