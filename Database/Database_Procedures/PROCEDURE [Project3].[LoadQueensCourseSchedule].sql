SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Taruna Mangar
-- Create date: May 14, 2024
-- Description: Inserts data into the Project3 star schema
-- =============================================
CREATE PROCEDURE [Project3].[LoadQueensCourseSchedule]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    
    
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Inserts data into the Project3 star schema',
        @WorkFlowStepTableRowCount = 0,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

           
    EXEC [Project3].[DropForeignKeysFromStarSchemaData] @GroupMemberUserAuthorizationKey = 1; 

    
    EXEC [Project3].[ShowTableStatusRowCount]
        @GroupMemberUserAuthorizationKey = 5,  
        @TableStatus = N'Pre-truncate of tables';

    
    EXEC [Project3].[TruncateStarSchemaData] @GroupMemberUserAuthorizationKey = 4; 

    
    EXEC [Project3].[Load_Department] @GroupMemberUserAuthorizationKey = 1;
    EXEC [Project3].[Load_BuildingLocation] @GroupMemberUserAuthorizationKey = 4;
    EXEC [Project3].[Load_ModeOfInstruction] @GroupMemberUserAuthorizationKey = 3;
    EXEC [Project3].[Load_Course] @GroupMemberUserAuthorizationKey = 3;
    EXEC [Project3].[Load_RoomLocation] @GroupMemberUserAuthorizationKey = 2;
    EXEC [Project3].[Load_Instructor] @GroupMemberUserAuthorizationKey = 1;
    EXEC [Project3].[Load_Class] @GroupMemberUserAuthorizationKey = 1;
    
   
    
    EXEC [Project3].[AddForeignKeysToStarSchemaData] @GroupMemberUserAuthorizationKey = 4;

    
    EXEC [Project3].[ShowTableStatusRowCount]
        @GroupMemberUserAuthorizationKey = 5,  
        @TableStatus = N'Row Count after loading the star schema';

END;
GO
