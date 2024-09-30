USE [Pdm]
GO

/****** Object:  UserDefinedTableType [DevelopmentEfforts].[DevEffortsUsersUDT]    Script Date: 30/09/2024 12:07:39 pm ******/
CREATE TYPE [DevelopmentEfforts].[DevEffortsUsersUDT] AS TABLE(
	[secure_admin] [bit] NOT NULL,
	[user_account] [varchar](8) NOT NULL,
	[crud_action] [varchar](8) NOT NULL
)
GO


