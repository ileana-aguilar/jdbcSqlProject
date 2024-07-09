SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Arrafi Talukder
-- Create Date: May 13, 2024
-- Description: Truncates each table in Project3 schema.
-- =============================================
CREATE PROCEDURE [Project3].[TruncateStarSchemaData]
@GroupMemberUserAuthorizationKey INT
AS
BEGIN
    
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    
    
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Truncates each table in Project3 schema.',
        @WorkFlowStepTableRowCount = 0,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    
    TRUNCATE TABLE [Academic].[Department];
    TRUNCATE TABLE [Academic].[Course];
    TRUNCATE TABLE [Academic].[Instructor];
    TRUNCATE TABLE [Academic].[Class];

    
    TRUNCATE TABLE [Facilities].[BuildingLocation];
    TRUNCATE TABLE [Facilities].[RoomLocation];

    
    TRUNCATE TABLE [Administrative].[ModeOfInstruction];

    PRINT 'All tables in Project3 schema have been truncated successfully.'
END;
GO
