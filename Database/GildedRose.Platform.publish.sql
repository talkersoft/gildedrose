﻿/*
Deployment script for GildedRose.Platform

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "GildedRose.Platform"
:setvar DefaultFilePrefix "GildedRose.Platform"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = AUTO, OPERATION_MODE = READ_WRITE, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating [webProcessLogin]...';


GO
CREATE LOGIN [webProcessLogin]
    WITH PASSWORD = N'HappyGoJoyBaby7732';


GO
PRINT N'Creating [webProcessUser]...';


GO
CREATE USER [webProcessUser] FOR LOGIN [webProcessLogin];


GO
REVOKE CONNECT TO [webProcessUser];


GO
PRINT N'Creating [webProcessRole]...';


GO
CREATE ROLE [webProcessRole]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [inventory]...';


GO
CREATE SCHEMA [inventory]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [logs]...';


GO
CREATE SCHEMA [logs]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [operations]...';


GO
CREATE SCHEMA [operations]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [dbo].[Address]...';


GO
CREATE TYPE [dbo].[Address]
    FROM NVARCHAR (100) NOT NULL;


GO
PRINT N'Creating [dbo].[AuditDate]...';


GO
CREATE TYPE [dbo].[AuditDate]
    FROM DATETIME2 (0) NOT NULL;


GO
PRINT N'Creating [dbo].[AuditUser]...';


GO
CREATE TYPE [dbo].[AuditUser]
    FROM INT NOT NULL;


GO
PRINT N'Creating [dbo].[City]...';


GO
CREATE TYPE [dbo].[City]
    FROM NVARCHAR (100) NOT NULL;


GO
PRINT N'Creating [dbo].[Email]...';


GO
CREATE TYPE [dbo].[Email]
    FROM NVARCHAR (255) NOT NULL;


GO
PRINT N'Creating [dbo].[Phone]...';


GO
CREATE TYPE [dbo].[Phone]
    FROM NVARCHAR (255) NOT NULL;


GO
PRINT N'Creating [dbo].[PostalCode]...';


GO
CREATE TYPE [dbo].[PostalCode]
    FROM NVARCHAR (10) NOT NULL;


GO
PRINT N'Creating [dbo].[PWD]...';


GO
CREATE TYPE [dbo].[PWD]
    FROM NVARCHAR (255) NOT NULL;


GO
PRINT N'Creating [dbo].[State]...';


GO
CREATE TYPE [dbo].[State]
    FROM NVARCHAR (2) NOT NULL;


GO
PRINT N'Creating [inventory].[Categories]...';


GO
CREATE TABLE [inventory].[Categories] (
    [Id]          INT               IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100)    NOT NULL,
    [IsLegendary] BIT               NOT NULL,
    [Created]     [dbo].[AuditDate] NOT NULL,
    [CreatedBy]   [dbo].[AuditUser] NOT NULL,
    [Modified]    [dbo].[AuditDate] NULL,
    [ModifiedBy]  [dbo].[AuditUser] NULL,
    CONSTRAINT [PK_CategoryIdentifier] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [inventory].[Categories].[UIX_inventory_category_name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_inventory_category_name]
    ON [inventory].[Categories]([Name] ASC);


GO
PRINT N'Creating [inventory].[Items]...';


GO
CREATE TABLE [inventory].[Items] (
    [Identifier] UNIQUEIDENTIFIER  NOT NULL,
    [Name]       NVARCHAR (100)    NOT NULL,
    [Category]   INT               NOT NULL,
    [ShelfLife]  INT               NOT NULL,
    [IsDeleted]  BIT               NOT NULL,
    [Created]    [dbo].[AuditDate] NOT NULL,
    [CreatedBy]  [dbo].[AuditUser] NOT NULL,
    [Modified]   [dbo].[AuditDate] NULL,
    [ModifiedBy] [dbo].[AuditUser] NULL,
    CONSTRAINT [PK_ItemIdentifier] PRIMARY KEY CLUSTERED ([Identifier] ASC)
);


GO
PRINT N'Creating [inventory].[Items].[UIX_inventory_item_name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_inventory_item_name]
    ON [inventory].[Items]([Name] ASC);


GO
PRINT N'Creating [inventory].[Items].[IX_Items_lookup]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Items_lookup]
    ON [inventory].[Items]([Identifier] ASC)
    INCLUDE([Name], [Category]) WHERE IsDeleted = 0;


GO
PRINT N'Creating [inventory].[ItemsOnHand]...';


GO
CREATE TABLE [inventory].[ItemsOnHand] (
    [Identifier]     UNIQUEIDENTIFIER  NOT NULL,
    [ItemIdentifier] UNIQUEIDENTIFIER  NOT NULL,
    [InitialQuality] INT               NOT NULL,
    [StockDate]      DATETIME2 (7)     NOT NULL,
    [Sold]           BIT               NOT NULL,
    [Created]        [dbo].[AuditDate] NOT NULL,
    [CreatedBy]      [dbo].[AuditUser] NOT NULL,
    CONSTRAINT [PK_ItemOnHandIdentifier] PRIMARY KEY CLUSTERED ([Identifier] ASC)
);


GO
PRINT N'Creating [logs].[ApiLog]...';


GO
CREATE TABLE [logs].[ApiLog] (
    [Id]              INT                IDENTITY (1, 1) NOT NULL,
    [Message]         NVARCHAR (MAX)     NULL,
    [MessageTemplate] NVARCHAR (MAX)     NULL,
    [Level]           NVARCHAR (128)     NULL,
    [TimeStamp]       DATETIMEOFFSET (7) NOT NULL,
    [Exception]       NVARCHAR (MAX)     NULL,
    [Properties]      XML                NULL,
    [LogEvent]        NVARCHAR (MAX)     NULL,
    CONSTRAINT [PK_ApiLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [logs].[SQLException]...';


GO
CREATE TABLE [logs].[SQLException] (
    [Id]            INT             IDENTITY (1, 1) NOT NULL,
    [ProcedureName] NVARCHAR (100)  NOT NULL,
    [ErrorMessage]  NVARCHAR (4000) NULL,
    [ErrorNumber]   INT             NULL,
    [ErrorLine]     INT             NULL,
    [ErrorSeverity] INT             NULL,
    [ErrorState]    INT             NULL,
    [ErrorDate]     DATETIME        NOT NULL,
    CONSTRAINT [PK_SQLException] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'Creating [logs].[SQLException].[IX_SQLException_ErrorDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_SQLException_ErrorDate]
    ON [logs].[SQLException]([ErrorDate] ASC);


GO
PRINT N'Creating [logs].[SQLException].[IX_SQLException_ProcedureName]...';


GO
CREATE NONCLUSTERED INDEX [IX_SQLException_ProcedureName]
    ON [logs].[SQLException]([ProcedureName] ASC);


GO
PRINT N'Creating [operations].[Patrons]...';


GO
CREATE TABLE [operations].[Patrons] (
    [Identifier] UNIQUEIDENTIFIER   NOT NULL,
    [FirstName]  NVARCHAR (100)     NOT NULL,
    [LastName]   NVARCHAR (100)     NOT NULL,
    [Address1]   [dbo].[Address]    NOT NULL,
    [Address2]   [dbo].[Address]    NOT NULL,
    [City]       [dbo].[City]       NOT NULL,
    [State]      [dbo].[State]      NOT NULL,
    [PostalCode] [dbo].[PostalCode] NOT NULL,
    [Phone]      [dbo].[Phone]      NOT NULL,
    [Email]      [dbo].[Email]      NOT NULL,
    [IsDeleted]  BIT                NOT NULL,
    [Created]    [dbo].[AuditDate]  NOT NULL,
    [CreatedBy]  [dbo].[AuditUser]  NOT NULL,
    [Modified]   [dbo].[AuditDate]  NULL,
    [ModifiedBy] [dbo].[AuditUser]  NULL,
    CONSTRAINT [PK_PatronIdentifier] PRIMARY KEY CLUSTERED ([Identifier] ASC)
);


GO
PRINT N'Creating [operations].[Patrons].[UIX_inventory_item_name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_inventory_item_name]
    ON [operations].[Patrons]([LastName] ASC, [FirstName] ASC);


GO
PRINT N'Creating unnamed constraint on [inventory].[Categories]...';


GO
ALTER TABLE [inventory].[Categories]
    ADD DEFAULT getutcdate() FOR [Created];


GO
PRINT N'Creating unnamed constraint on [inventory].[Items]...';


GO
ALTER TABLE [inventory].[Items]
    ADD DEFAULT getutcdate() FOR [Created];


GO
PRINT N'Creating unnamed constraint on [inventory].[ItemsOnHand]...';


GO
ALTER TABLE [inventory].[ItemsOnHand]
    ADD DEFAULT 0 FOR [Sold];


GO
PRINT N'Creating unnamed constraint on [inventory].[ItemsOnHand]...';


GO
ALTER TABLE [inventory].[ItemsOnHand]
    ADD DEFAULT getutcdate() FOR [Created];


GO
PRINT N'Creating [logs].[DF_SQLException_ErrorDate]...';


GO
ALTER TABLE [logs].[SQLException]
    ADD CONSTRAINT [DF_SQLException_ErrorDate] DEFAULT (getutcdate()) FOR [ErrorDate];


GO
PRINT N'Creating unnamed constraint on [operations].[Patrons]...';


GO
ALTER TABLE [operations].[Patrons]
    ADD DEFAULT getutcdate() FOR [Created];


GO
PRINT N'Creating [inventory].[FK_Items_Category]...';


GO
ALTER TABLE [inventory].[Items]
    ADD CONSTRAINT [FK_Items_Category] FOREIGN KEY ([Category]) REFERENCES [inventory].[Categories] ([Id]);


GO
PRINT N'Creating [inventory].[FK_ItemsOnHand_Items]...';


GO
ALTER TABLE [inventory].[ItemsOnHand]
    ADD CONSTRAINT [FK_ItemsOnHand_Items] FOREIGN KEY ([ItemIdentifier]) REFERENCES [inventory].[Items] ([Identifier]);


GO
PRINT N'Creating [inventory].[ItemsView]...';


GO
CREATE VIEW [inventory].[ItemsView]
	AS 
SELECT 
	   i.[Identifier]
      ,i.[Name]
      ,i.[ShelfLife]
      ,oh.[InitialQuality]
      ,i.[IsDeleted]
	  ,c.[IsLegendary]
	  ,oh.StockDate
      ,i.[Created]
      ,i.[CreatedBy]
      ,i.[Modified]
      ,i.[ModifiedBy]
	  ,c.[Id] as CategoryId
      ,c.[Name] as CategoryName
  FROM 
	[inventory].[ItemsOnHand] oh
  INNER JOIN
	[inventory].[Items] i
  ON
	oh.ItemIdentifier = i.Identifier
  INNER JOIN 
	[inventory].[Categories] c 
  ON
	c.Id = i.Category
  WHERE
	oh.Sold = 0;
GO
PRINT N'Creating [inventory].[getItemIdentifierByName]...';


GO
CREATE FUNCTION [inventory].[getItemIdentifierByName](@ItemName VARCHAR(100))
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	RETURN(SELECT 
				Identifier
			FROM 
				inventory.Items
			WHERE
				[Name] = @ItemName);
END
GO
PRINT N'Creating [inventory].[getCategoryIdByName]...';


GO
CREATE FUNCTION [inventory].[getCategoryIdByName](@CategoryName VARCHAR(100))
RETURNS INT
AS
BEGIN
	RETURN(SELECT 
				Id
			FROM 
				inventory.Categories
			WHERE
				[Name] = @CategoryName);
END
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

DECLARE @Categories TABLE (
    [Id] INT NOT NULL, 
    [Name] NVARCHAR(100) NOT NULL, 
	[IsLegendary] BIT NOT NULL,
    [CreatedBy] [AuditUser] NOT NULL
);

 
INSERT INTO 
	@Categories ([Id], [Name], [IsLegendary], [CreatedBy]) 
VALUES
(1, 'Weapon', 0, 0),
(2, 'Food', 0, 0),
(3, 'Sulfuras', 1, 1),
(4, 'Backstage Passes', 0, 0),
(5, 'Conjured', 0, 0),
(6, 'Potion', 0, 0),
(7, 'Misc', 0, 0),
(8, 'Armor', 0, 0);

 
-- Merge Statement Used to ensure list of items maintained in the table variable are persisted into the database
MERGE inventory.Categories AS t
USING @Categories as s
	on 	(t.[Id] = s.[Id])
WHEN NOT MATCHED BY TARGET
    THEN INSERT ([Name], [IsLegendary], [CreatedBy])
        VALUES (s.[Name], [IsLegendary], s.CreatedBy)
WHEN MATCHED
    THEN UPDATE 
	SET 
		t.[Name] = s.[Name],
		t.[IsLegendary] = s.[IsLegendary]
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

DECLARE @Items TABLE (
    [Identifier] UNIQUEIDENTIFIER NOT NULL, 
    [Name] NVARCHAR(100) NOT NULL, 
    [Category] INT NOT NULL, 
	[ShelfLife] INT NOT NULL,
	[IsDeleted] BIT NOT NULL,
    [CreatedBy] [AuditUser] NOT NULL
);

 
INSERT INTO 
	@Items ([Identifier] ,[Name] ,[Category] ,[ShelfLife] ,[IsDeleted] ,[CreatedBy]) 
VALUES
	('f3205dfd-55fe-4cd5-8070-b259e9db2f7b', 'Sword', inventory.getCategoryIdByName('Weapon'), 30, 0, 1),
	('35096084-af46-4e40-932e-655aab9bac00', 'Axe', inventory.getCategoryIdByName('Weapon'), 40, 0, 1),
	('e12e2698-79b6-4f15-bfa2-a1fab047aa27', 'Halberd', inventory.getCategoryIdByName('Weapon'), 60, 0, 1),
	('dddd657e-9617-4c82-bdc5-0ab53b5a6398', 'Aged Brie', inventory.getCategoryIdByName('Food'), 50, 0, 1),
	('02223851-8f9a-4b55-a925-e59be7855413', 'Aged Milk', inventory.getCategoryIdByName('Food'), 20, 0, 1),
	('e52e05f0-aba1-44e8-8003-435bb20bd660', 'Mutton', inventory.getCategoryIdByName('Food'), 10, 0, 1),
	('eea3072c-1579-469a-81c9-f2ba6302a0ca', 'Hand of Ragnaros', inventory.getCategoryIdByName('Sulfuras'), 80, 0, 1),
	('e2055eae-6d1f-45a9-9701-7c5fbf563e20', 'I am Murloc', inventory.getCategoryIdByName('Backstage Passes'), 20, 0, 1),
	('960fa030-70ac-4ff7-8ad8-07cea6ca84ce', 'Raging Ogre', inventory.getCategoryIdByName('Backstage Passes'), 10, 0, 1),
	('95a79f27-61e1-4c70-8039-0fdd703fc6e9', 'Giant Slayer', inventory.getCategoryIdByName('Conjured'), 15, 0, 1),
	('8686e4d9-a43c-4c46-bb72-81e9454609c6', 'Storm Hammer', inventory.getCategoryIdByName('Conjured'), 20, 0, 1),
	('3884fae6-6dd9-4e4f-bc04-bcb90f18dae7', 'Belt of Giant Strength', inventory.getCategoryIdByName('Conjured'), 20, 0, 1),
	('fc22fba7-7f78-4ac5-a155-d89a40a1940a', 'Cheese', inventory.getCategoryIdByName('Food'), 5, 0, 1),
	('f1ab5859-cd8a-46b2-9520-dd631cbde700', 'Potion of Healing', inventory.getCategoryIdByName('Potion'), 10, 0, 1),
	('a5091448-6848-4247-8d85-2ee5a6a8defb', 'Bag of Holding', inventory.getCategoryIdByName('Misc'), 10, 0, 1),
	('58c1acc3-0ce7-4a06-86f3-5052d223e48d', 'TAFKAL80ETC Concert', inventory.getCategoryIdByName('Backstage Passes'), 15, 0, 1),
	('49ca5c68-4fbd-4ef6-9fe8-e086c6ef81e6', 'Elixir of the Mongoose', inventory.getCategoryIdByName('Potion'), 5, 0, 1),
	('88bdb452-e23d-4b70-b07e-c9f3f3f0d1a9', '+5 Dexterity Vest', inventory.getCategoryIdByName('Armor'), 10, 0, 1),
	('15298b70-b493-43a8-b01e-2cccf5514a89', 'Full Plate Mail', inventory.getCategoryIdByName('Armor'), 50, 0, 1),
	('4bb48e57-245a-419e-880c-1b701dbb35c2', 'Wooden Shield', inventory.getCategoryIdByName('Armor'), 10, 0, 1);

 
-- Merge Statement Used to ensure list of items maintained in the table variable are persisted into the database
MERGE inventory.Items AS t
USING @Items as s
	on 	(t.[Identifier] = s.[Identifier])
WHEN NOT MATCHED BY TARGET
    THEN INSERT ([Identifier], [Name], [Category], [ShelfLife], [IsDeleted], [CreatedBy])
        VALUES (s.[Identifier], s.[Name], s.[Category], s.[ShelfLife], s.[IsDeleted], s.[CreatedBy])
WHEN MATCHED
    THEN UPDATE SET 
		t.[Identifier] = s.[Identifier], 
		t.[Name] = s.[Name],
		t.Category = s.Category,
		t.ShelfLife = s.ShelfLife, 
		t.IsDeleted = s.IsDeleted
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

DECLARE @ItemsOnHand TABLE (
	[Identifier] UNIQUEIDENTIFIER NOT NULL, 
    [ItemIdentifier] UNIQUEIDENTIFIER NOT NULL,
	[InitialQuality] INT NOT NULL,
	[StockDate] DATETIME2 NOT NULL,
    [CreatedBy] [AuditUser] NOT NULL
);

 
INSERT INTO 
	@ItemsOnHand ([Identifier] ,[ItemIdentifier] ,[InitialQuality], [StockDate] ,[CreatedBy]) 
VALUES
	('C3289840-3B10-439F-9BC0-DCFB808BDFFE', inventory.getItemIdentifierByName('Bag of Holding'), 50, GETDATE(), 1),
	('72E15B2E-2062-435E-81FE-A1D815C636F5', inventory.getItemIdentifierByName('I am Murloc'), 10, GETDATE(), 1),
	('91871496-0CA2-4395-B35E-5E20FF201E23', inventory.getItemIdentifierByName('Full Plate Mail'), 50, GETDATE(), 1),
	('0715E0BC-6410-4CDF-9F37-2E8910B3D0FD', inventory.getItemIdentifierByName('Elixir of the Mongoose'), 7, GETDATE(), 1),
	('337D9931-BD01-461E-A251-E6765D7705AD', inventory.getItemIdentifierByName('Mutton'), 10, GETDATE(), 1),
	('05154EBA-6960-4B28-9F5A-F56FC4D68FC9', inventory.getItemIdentifierByName('Cheese'), 5, GETDATE(), 1),
	('10ED98DF-7940-47CD-9037-7B1AB6F3108F', inventory.getItemIdentifierByName('Belt of Giant Strength'), 40, GETDATE(), 1),
	('6E2FD542-B102-4C44-83E3-3F7C19BF9A44', inventory.getItemIdentifierByName('Giant Slayer'), 50, GETDATE(), 1),
	('04E968B1-7DC1-46EE-9717-6F6132E0690F', inventory.getItemIdentifierByName('Sword'), 50, GETDATE(), 1),
	('7FB55244-5DCE-4A4D-A063-EEEEC489537B', inventory.getItemIdentifierByName('Raging Ogre'), 10, GETDATE(), 1),
	('8CC6609B-3907-4999-8D65-AA2BE873A95B', inventory.getItemIdentifierByName('Halberd'), 40, GETDATE(), 1),
	('C36F2D57-F8CA-4D4B-9908-5485B794D4CC', inventory.getItemIdentifierByName('Hand of Ragnaros'), 80, GETDATE(), 1),
	('E3C0CABA-5302-4897-886A-BB5C58C90D69', inventory.getItemIdentifierByName('Aged Milk'), 20, GETDATE(), 1),
	('03C2B461-4254-43AF-BD21-AC677D3F4C87', inventory.getItemIdentifierByName('Potion of Healing'), 10, GETDATE(), 1),
	('C55E76E7-7FCB-4A95-BF74-9685B78430D5', inventory.getItemIdentifierByName('Storm Hammer'), 50, GETDATE(), 1),
	('CF3FB7DC-1220-4E57-9405-968C20D737CA', inventory.getItemIdentifierByName('Axe'), 50, GETDATE(), 1),
	('64BD78B2-C6F7-4EBC-87B4-2C7961F91D2D', inventory.getItemIdentifierByName('+5 Dexterity Vest'), 20, GETDATE(), 1),
	('9B523CEB-5329-48A7-9355-45B7AB523842', inventory.getItemIdentifierByName('Aged Brie'), 10, GETDATE(), 1),
	('AEB878B0-7EEE-485D-B088-7ADDD96613FC', inventory.getItemIdentifierByName('Wooden Shield'), 30, GETDATE(), 1),
	('46637321-E10D-4E77-AAC0-4399840032A8', inventory.getItemIdentifierByName('TAFKAL80ETC Concert'), 20, GETDATE(), 1)



-- Merge Statement Used to ensure list of items maintained in the table variable are persisted into the database
MERGE inventory.ItemsOnHand AS t
USING @ItemsOnHand as s
	on 	(t.[Identifier] = s.[Identifier])
WHEN NOT MATCHED BY TARGET
    THEN INSERT ([Identifier], [ItemIdentifier], [InitialQuality], [StockDate], [CreatedBy])
        VALUES (s.[Identifier], s.[ItemIdentifier], s.[InitialQuality], s.[StockDate], s.[CreatedBy])
WHEN MATCHED
    THEN UPDATE SET 
		t.[Identifier] = s.[Identifier], 
		t.[ItemIdentifier] = s.[ItemIdentifier],
		t.[InitialQuality] = s.[InitialQuality],
		t.[StockDate] = s.[StockDate]
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

GRANT CONNECT TO [webProcessRole]
GO
GRANT 
	EXECUTE, 
	SELECT,
	INSERT,
	UPDATE,
	DELETE, 
	VIEW DEFINITION ON 
Schema::[dbo] TO [webProcessRole];
GO
GRANT 
	EXECUTE, 
	SELECT,
	INSERT,
	UPDATE,
	DELETE, 
	VIEW DEFINITION ON 
Schema::[inventory] TO [webProcessRole];
GO
GRANT 
	EXECUTE, 
	SELECT,
	INSERT,
	UPDATE,
	DELETE, 
	VIEW DEFINITION ON 
Schema::[logs] TO [webProcessRole];

EXEC sp_addrolemember 'webProcessRole', 'webProcessUser';

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
