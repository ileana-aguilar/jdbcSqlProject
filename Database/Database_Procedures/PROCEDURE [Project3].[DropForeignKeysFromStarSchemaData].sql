SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Ileana Aguilar
-- Create date: May 11, 2024
-- Description: Drops all foreign keys from star schema tables in Project3
-- =============================================
CREATE PROCEDURE [Project3].[DropForeignKeysFromStarSchemaData]
@GroupMemberUserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
     DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    
    
    EXEC [Process].[usp_TrackWorkFlows]
        @StartTime = @CurrentTime, 
        @WorkFlowDescription = 'Drops all foreign keys from star schema tables in Project3',
        @WorkFlowStepTableRowCount = 0,
        @UserAuthorizationKey = @GroupMemberUserAuthorizationKey;
        
        DECLARE @sql NVARCHAR(MAX) = N'';

        -- Collect commands to drop FKs from Academic schema
        SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
                + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
                + ' DROP CONSTRAINT ' + QUOTENAME(name) + '; '
        FROM sys.foreign_keys
        WHERE referenced_object_id IN (SELECT object_id FROM sys.objects WHERE schema_id = SCHEMA_ID('Academic'));

        -- Collect commands to drop FKs from Facilities schema
        SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
                + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
                + ' DROP CONSTRAINT ' + QUOTENAME(name) + '; '
        FROM sys.foreign_keys
        WHERE referenced_object_id IN (SELECT object_id FROM sys.objects WHERE schema_id = SCHEMA_ID('Facilities'));

        -- Collect commands to drop FKs from Administrative schema
        SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
                + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
                + ' DROP CONSTRAINT ' + QUOTENAME(name) + '; '
        FROM sys.foreign_keys
        WHERE referenced_object_id IN (SELECT object_id FROM sys.objects WHERE schema_id = SCHEMA_ID('Administrative'));

        -- Execute the SQL statements collected
        EXEC sp_executesql @sql;

        PRINT 'Foreign key constraints dropped successfully.'
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
