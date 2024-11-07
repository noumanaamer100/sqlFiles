USE [Pdm]
GO

/****** Object:  View [DevelopmentEfforts].[DevelopmentEffortSecure]    Script Date: 07/11/2024 4:47:47 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [DevelopmentEfforts].[DevelopmentEffortSecure]
AS
SELECT    [proj_cde]
        , [usr_acct]
        , [admin_ind]
		, [cre_dte]
		, [cre_acct]
		, [mod_dte]
		, [mod_acct]
		, [exp_dte]
FROM    [speed_2max].[dbo].[development_effort_secure]
;
GO


