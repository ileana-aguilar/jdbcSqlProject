SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Carlo Ace Sagad
-- Create date: 05/12/2024
-- Description: Inserts data into the Administrative.ModeOfInstruction table.    
-- =============================================
CREATE PROCEDURE [Project3].[Load_ModeOfInstruction]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    DECLARE @RowCount INT;
    
    
    INSERT INTO Administrative.ModeOfInstruction
        (InstructionType, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
  
SELECT DISTINCT
        Old.[Mode of Instruction]  AS InstructionType,
        @GroupMemberUserAuthorizationKey AS UserAuthorizationKey,
        @CurrentTime AS DateAdded,
        @CurrentTime AS DateOfLastUpdate
    FROM
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Old;
        
    SELECT @RowCount = COUNT(*) FROM Administrative.ModeOfInstruction
         
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Inserts data into the Administrative.ModeOfInstruction table.',
        @WorkFlowStepTableRowCount = @RowCount,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    
    PRINT 'Mode of instruction data load complete.'

    
END
GO
