USE [Pdm]
GO

/****** Object:  View [DevelopmentEfforts].[Users]    Script Date: 01/10/2024 12:47:22 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



------------------------------------
--create view
------------------------------------
CREATE   VIEW [DevelopmentEfforts].[Users]
AS 
	SELECT 
	wwid
	,usr_acct
	,idsid
	,proj_cde
	,last_nme
	,first_nme
	,mid_init
	,phn_nbr
	,bookname COLLATE SQL_Latin1_General_CP850_BIN as bookname
	,email_addr
	,curr_actv_ind
	,speed_usr_ind
	,int_ext_ind
	,cc_usr_ind
	,region
	,geographic_loc
	,dept_nme
	,intel_ste_cde
	,lst_login_dte
	,bus_unit_idn		
    FROM speed_2max.[dbo].[users]
GO


