USE [Pdm]
GO

/****** Object:  UserDefinedTableType [DevelopmentEfforts].[DevEffortsUsersUDT]    Script Date: 07/11/2024 4:52:18 pm ******/
CREATE TYPE [DevelopmentEfforts].[DevEffortsUsersUDT] AS TABLE(
	[action] [varchar](8) NOT NULL,
	[userAcct] [varchar](8) NOT NULL,
	[isSecureUser] [bit] NOT NULL
)
GO


