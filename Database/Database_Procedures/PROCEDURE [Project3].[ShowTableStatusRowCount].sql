SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Bin Xie
-- Create Date: May 13, 2024
-- Description: Shows the status and row count of each table in Project3
-- =============================================
CREATE PROCEDURE [Project3].[ShowTableStatusRowCount]
    @GroupMemberUserAuthorizationKey INT,
    @TableStatus VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    
    
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Shows the status and row count of each table in Project3',
        @WorkFlowStepTableRowCount = 0,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    -- Fetch and display row counts from Academic schema tables
    SELECT UserAuthorizationKey = @GroupMemberUserAuthorizationKey, TableStatus = @TableStatus, TableName = 'Academic.Department', COUNT(*) FROM [Academic].[Department];
    SELECT UserAuthorizationKey = @GroupMemberUserAuthorizationKey, TableStatus = @TableStatus, TableName = 'Academic.Course', COUNT(*) FROM [Academic].[Course];
    SELECT UserAuthorizationKey = @GroupMemberUserAuthorizationKey, TableStatus = @TableStatus, TableName = 'Academic.Instructor', COUNT(*) FROM [Academic].[Instructor];
    SELECT UserAuthorizationKey = @GroupMemberUserAuthorizationKey, TableStatus = @TableStatus, TableName = 'Academic.Class', COUNT(*) FROM [Academic].[Class];

    -- Fetch and display row counts from Facilities schema tables
    SELECT UserAuthorizationKey = @GroupMemberUserAuthorizationKey, TableStatus = @TableStatus, TableName = 'Facilities.BuildingLocation', COUNT(*) FROM [Facilities].[BuildingLocation];
    SELECT UserAuthorizationKey = @GroupMemberUserAuthorizationKey, TableStatus = @TableStatus, TableName = 'Facilities.RoomLocation', COUNT(*) FROM [Facilities].[RoomLocation];

    -- Fetch and display row counts from Administrative schema tables
    SELECT UserAuthorizationKey = @GroupMemberUserAuthorizationKey, TableStatus = @TableStatus, TableName = 'Administrative.ModeOfInstruction', COUNT(*) FROM [Administrative].[ModeOfInstruction];
    PRINT 'Each row of each table has been successfully counted.'
END;
GO
