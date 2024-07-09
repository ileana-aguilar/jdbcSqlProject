SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Ileana Aguilar
-- Create date: May 11, 2024
-- Description: Inserts workflow step details into the [Process].[WorkflowSteps] table,
-- including description, row count, start and end time, user authorization key, and then prints a confirmation message.
-- =============================================
CREATE PROCEDURE [Process].[usp_TrackWorkFlows]
    @StartTime DATETIME2,
    @WorkFlowDescription NVARCHAR(100),
    @WorkFlowStepTableRowCount INT,
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [Process].[WorkflowSteps]
    (
        WorkFlowStepDescription, 
        WorkFlowStepTableRowCount, 
        StartingDateTime, 
        UserAuthorizationKey
    )
    VALUES
    (
        @WorkFlowDescription, 
        @WorkFlowStepTableRowCount, 
        @StartTime, 
        @UserAuthorizationKey
    );


    PRINT 'Workflow step details inserted successfully.';
END;
GO
