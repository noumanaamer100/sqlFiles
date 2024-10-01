USE [Pdm]
GO

/****** Object:  View [DevelopmentEfforts].[DevelopmentEffortSecure]    Script Date: 30/09/2024 2:07:46 pm ******/
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


