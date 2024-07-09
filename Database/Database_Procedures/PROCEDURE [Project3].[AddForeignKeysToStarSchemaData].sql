SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Arrafi Talukder
-- Create Date: May 13, 2024
-- Description: Add foreign keys to star schema tables in Project3
-- =============================================
CREATE PROCEDURE [Project3].[AddForeignKeysToStarSchemaData]
    @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    
    
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Add foreign keys to star schema tables in Project3',
        @WorkFlowStepTableRowCount = 0,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;

    -- Foreign key between Class and Course
    ALTER TABLE [Academic].[Class] WITH CHECK ADD CONSTRAINT [FK_Class_Course] FOREIGN KEY ([CourseId]) REFERENCES [Academic].[Course] ([CourseId]);
    ALTER TABLE [Academic].[Class] CHECK CONSTRAINT [FK_Class_Course];

    -- Foreign key between Class and Instructor
    ALTER TABLE [Academic].[Class] WITH CHECK ADD CONSTRAINT [FK_Class_Instructor] FOREIGN KEY ([InstructorId]) REFERENCES [Academic].[Instructor] ([InstructorId]);
    ALTER TABLE [Academic].[Class] CHECK CONSTRAINT [FK_Class_Instructor];

    -- Foreign key between Class and RoomLocation
    ALTER TABLE [Academic].[Class] WITH CHECK ADD CONSTRAINT [FK_Class_RoomLocation] FOREIGN KEY ([RoomLocationId]) REFERENCES [Facilities].[RoomLocation] ([RoomLocationId]);
    ALTER TABLE [Academic].[Class] CHECK CONSTRAINT [FK_Class_RoomLocation];

    -- Foreign key between Class and ModeOfInstruction
    ALTER TABLE [Academic].[Class] WITH CHECK ADD CONSTRAINT [FK_Class_ModeOfInstruction] FOREIGN KEY ([ModeOfInstructionId]) REFERENCES [Administrative].[ModeOfInstruction] ([ModeOfInstructionId]);
    ALTER TABLE [Academic].[Class] CHECK CONSTRAINT [FK_Class_ModeOfInstruction];

 
    -- Foreign key between RoomLocation and Department
    ALTER TABLE [Facilities].[RoomLocation] WITH CHECK ADD CONSTRAINT [FK_RoomLocation_BuildingId] FOREIGN KEY ([BuildingId]) REFERENCES [Facilities].[BuildingLocation] ([BuildingId]);
    ALTER TABLE [Facilities].[RoomLocation] CHECK CONSTRAINT [FK_RoomLocation_BuildingId];


    PRINT 'Foreign key constraints added successfully.'
END;
GO
