SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Ileana Aguilar
-- Create date: May 12, 2024
-- Description: Inserts data into the Academic.Class table.    
-- =============================================
CREATE PROCEDURE [Project3].[Load_Class]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    DECLARE @RowCount INT;
    
    INSERT INTO Academic.Class
        (CourseId, ClassCode, Semester, Section, InstructorId, RoomLocationId, ModeOfInstructionId, Enrolled, MaxEnrollment, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    SELECT DISTINCT
        AC.CourseId,
        Old.[Code] AS ClassCode, 
        Old.Semester, 
        Old.Sec, 
        AI.InstructorId, 
        RL.RoomLocationId, 
        MOI.ModeOfInstructionId, 
        Old.Enrolled, 
        Old.[Limit],
        @GroupMemberUserAuthorizationKey AS UserAuthorizationKey,
        @CurrentTime AS DateAdded,
        @CurrentTime AS DateOfLastUpdate
    FROM 
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Old
    INNER JOIN 
        Academic.Course AC ON AC.CourseName = LEFT(Old.[Course (hr, crd)], CHARINDEX('(', Old.[Course (hr, crd)]) - 1) 
    INNER JOIN 
        Academic.Instructor AI ON AI.FullName = Old.Instructor  
    INNER JOIN 
        Facilities.RoomLocation RL ON RL.RoomNumber = SUBSTRING(Old.Location, PATINDEX('%[0-9]%', Old.Location), LEN(Old.Location))
    INNER JOIN 
        Administrative.ModeOfInstruction MOI ON MOI.InstructionType = Old.[Mode of Instruction]
    
    SELECT @RowCount = COUNT(*) FROM Academic.Class;
    
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Inserts data into the Academic.Class table.',
        @WorkFlowStepTableRowCount = @RowCount,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;
    
    PRINT 'Class data load complete.'

   
END
GO
