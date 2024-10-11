USE [Pdm]
GO

/****** Object:  UserDefinedTableType [DevelopmentEfforts].[DevEffortsUsersUDT]    Script Date: 08/10/2024 3:18:49 pm ******/
CREATE TYPE [DevelopmentEfforts].[DevEffortsUsersUDT] AS TABLE(
	[action] [varchar](8) NOT NULL,
	[userAcct] [varchar](8) NOT NULL,
	[isSecureUser] [bit] NOT NULL
)
GO


