USE [Pdm]
GO

/****** Object:  StoredProcedure [DevelopmentEfforts].[DevEffortsSaveUpdates]    Script Date: 07/11/2024 4:57:11 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [DevelopmentEfforts].[DevEffortsSaveUpdates] (
    @usr_acct       VARCHAR(8),
	@proj_cde       VARCHAR(15),
	@bus_unit_idn	VARCHAR(2),
	@inactive_dte	VARCHAR(30),
	@proj_cmnt		VARCHAR(80),
	@proj_dsc		VARCHAR(30),
	@function       VARCHAR(80),
	@users [DevelopmentEfforts].[DevEffortsUsersUDT] READONLY	
)
AS
BEGIN

	DECLARE @exists_ind	 CHAR(1)
		   ,@err_msg     VARCHAR(8000)
		   ,@admin_user  VARCHAR(8)
		   ,@auth_user   VARCHAR(8)
		   ,@error_code  VARCHAR(60)

    DECLARE @AdminRpt AS TABLE
    (
        admn_acct VARCHAR(8),
        crud_typ  VARCHAR(8)
    );

    DECLARE @AuthRpt TABLE (
        auth_acct VARCHAR(8),
        crud_typ  VARCHAR(8)
    );


/*******************************************************************************
**                 Handle null values of project parameters
*******************************************************************************/

	SELECT @proj_cde= ISNULL(@proj_cde	, '')
		,@proj_cmnt	= ISNULL(@proj_cmnt	, '')
		,@proj_dsc	= ISNULL(@proj_dsc	, '')

/*******************************************************************************
**                    Identify users sent in from UI/ API
*******************************************************************************/

	/** load administrator report data **/
	IF EXISTS (SELECT 1 FROM @users)
	BEGIN
		INSERT @AdminRpt (admn_acct, crud_typ)
		SELECT NULLIF(userAcct, '')
			  ,NULLIF(action, '')
		FROM @users
		WHERE isSecureUser = 1
	END

	/** user account for newly added admin user **/
	SELECT TOP 1 @admin_user = admn_acct
    FROM @AdminRpt
    WHERE UPPER(crud_typ) = 'NEW';

	/** load authorized user report data **/
	IF EXISTS (SELECT 1 FROM @users)
	BEGIN
		INSERT @AuthRpt (auth_acct, crud_typ)
		SELECT NULLIF(userAcct	, '')
			  ,NULLIF(action	, '')
		FROM @users
		WHERE isSecureUser = 0
	END

	/** user account for newly added auth user **/
	SELECT TOP 1 @auth_user = auth_acct
    FROM @AuthRpt
    WHERE UPPER(crud_typ) = 'NEW';

/*********************************************************************************
**                              Validate data
*********************************************************************************/

	/** existence/duplicate checks **/
	IF EXISTS (SELECT * FROM [DevelopmentEfforts].[DevelopmentEffort] WHERE UPPER(proj_cde) = UPPER(@proj_cde))
		SET @exists_ind = 'Y'
	ELSE
		SET @exists_ind = 'N'

	SET @err_msg = ''
	SET @error_code = NULL

	IF UPPER(@function) = 'UPDATE' AND @exists_ind = 'N'
	BEGIN
		SET @err_msg = 'The project "' + @proj_cde + '" could not be found. This project was not updated.'
		SET @error_code = 'DATA_INTEGRITY_ERROR'
	END

	IF @err_msg = '' AND UPPER(@function) = 'NEW' AND @exists_ind = 'Y'
	BEGIN
		SET @err_msg = 'The project "' + @proj_cde + '" already exists. New record was not created.'
		SET @error_code = 'DUPLICATE_PROJECT_CODE'
	END

	/** demoted administrator check **/
	IF @err_msg = '' 
	AND @admin_user IS NOT NULL
	AND EXISTS
		(SELECT TOP 1 usr_acct 
		 FROM [DevelopmentEfforts].[DevelopmentEffortSecure]
		 WHERE proj_cde  = @proj_cde
		   AND usr_acct  = @admin_user
		   AND exp_dte	 > GETDATE()
		   AND admin_ind = 'N')
	BEGIN
		SELECT @err_msg = 'Authorized User "' + bookname + '" must be removed before being assigned as a Secure Administrator. 
		This project was not updated.'
		FROM [DevelopmentEfforts].[Users] WHERE usr_acct = @admin_user
		SET @error_code = 'INVALID_ADMINISTRATOR_ASSIGNMENT'
	END

	/** promoted user check **/
	IF @err_msg = '' 
	AND @auth_user IS NOT NULL
	AND EXISTS
		(SELECT TOP 1 usr_acct 
		FROM [DevelopmentEfforts].[DevelopmentEffortSecure]
		WHERE proj_cde  = @proj_cde
		  AND usr_acct  = @auth_user
		  AND exp_dte	> GETDATE()
		  AND admin_ind	= 'Y')
	BEGIN
		SELECT @err_msg = 'Secure Administrator "' + bookname + '" must be removed before being assigned as an Authorized User. 
		This project was not updated.'
		FROM [DevelopmentEfforts].[Users] WHERE usr_acct = @auth_user
		SET @error_code = 'INVALID_AUTHORIZED_USER_ASSIGNMENT'
	END

	/** report error **/
	IF @err_msg != '' 
	BEGIN
		IF UPPER(@function) = 'UPDATE'
			SET @function = 'detail init'
		ELSE
			SET @function = 'new init'

		SELECT @error_code AS error_code, @err_msg AS error_message
	END

	SET NOCOUNT ON

		BEGIN TRAN
		BEGIN TRY

/****************************************************************************************
**                                  Update project
****************************************************************************************/

			IF UPPER(@function) = 'UPDATE' AND @exists_ind = 'Y'
			BEGIN
				UPDATE [DevelopmentEfforts].[DevelopmentEffort]
				SET  inactive_dte	= @inactive_dte
					,bus_unit_idn	= @bus_unit_idn
					,proj_cmnt		= @proj_cmnt
					,proj_dsc		= @proj_dsc
				WHERE UPPER(proj_cde) = UPPER(@proj_cde)

/****************************************************************************************
**                              Administrator list update
****************************************************************************************/

				/** add administrator **/
				IF @admin_user IS NOT NULL
				BEGIN
					IF EXISTS
						(SELECT TOP 1 usr_acct 
						FROM [DevelopmentEfforts].[DevelopmentEffortSecure]
						WHERE proj_cde = @proj_cde
						  AND usr_acct = @admin_user)
					BEGIN
						UPDATE [DevelopmentEfforts].[DevelopmentEffortSecure]
						SET  admin_ind	= 'Y'
							,exp_dte	= DATEADD(mm, 6, GETDATE())
							,mod_dte	= GETDATE()
							,mod_acct	= @usr_acct
						WHERE proj_cde = @proj_cde
						AND usr_acct = @admin_user
					END ELSE BEGIN
						INSERT [DevelopmentEfforts].[DevelopmentEffortSecure]
							(proj_cde
							,usr_acct
							,admin_ind
							,exp_dte
							,cre_dte
							,cre_acct
							,mod_dte
							,mod_acct
							)
						SELECT @proj_cde
							,@admin_user AS usr_acct
							,'Y'         AS admin_ind
							,DATEADD(mm, 6, GETDATE()) AS exp_dte
							,GETDATE()   AS cre_dte
							,@usr_acct   AS cre_acct
							,GETDATE()   AS mod_dte
							,@usr_acct   AS mod_acct
					END
				END

				/** confirm administrator **/
				UPDATE [DevelopmentEfforts].[DevelopmentEffortSecure]
				SET  admin_ind	= 'Y'
					,exp_dte	= DATEADD(mm, 6, GETDATE())
					,mod_dte	= GETDATE()
					,mod_acct	= @usr_acct
				FROM [DevelopmentEfforts].[DevelopmentEffortSecure] AS admin
				JOIN @AdminRpt AS rpt 
				ON rpt.admn_acct = admin.usr_acct
				AND UPPER(rpt.crud_typ)  = 'CHANGED'
				WHERE admin.proj_cde = @proj_cde
				AND admin.admin_ind = 'Y'

				/** delete administrator **/
				UPDATE [DevelopmentEfforts].[DevelopmentEffortSecure]
				SET  admin_ind	= 'Y'
					,exp_dte	= GETDATE()
					,mod_dte	= GETDATE()
					,mod_acct	= @usr_acct
				FROM [DevelopmentEfforts].[DevelopmentEffortSecure] AS admin
				JOIN @AdminRpt AS rpt 
				ON rpt.admn_acct = admin.usr_acct
				AND UPPER(rpt.crud_typ)  = 'DELETED'
				WHERE admin.proj_cde = @proj_cde
				AND admin.admin_ind = 'Y'


/****************************************************************************************
**                             Authorized user list update
****************************************************************************************/

				/** add authorized user **/
	  			IF @auth_user IS NOT NULL
				BEGIN
					IF EXISTS
						(SELECT TOP 1 usr_acct 
						FROM [DevelopmentEfforts].[DevelopmentEffortSecure]
						WHERE proj_cde = @proj_cde
						AND usr_acct = @auth_user)
					BEGIN
						UPDATE [DevelopmentEfforts].[DevelopmentEffortSecure]
						SET  admin_ind	= 'N'
							,mod_dte	= GETDATE()
							,mod_acct	= @usr_acct
							,exp_dte	= DATEADD(mm, 6, GETDATE())
						WHERE proj_cde = @proj_cde
						AND usr_acct = @auth_user
					END ELSE BEGIN
						INSERT [DevelopmentEfforts].[DevelopmentEffortSecure]
							(proj_cde
							,usr_acct
							,admin_ind
							,cre_dte
							,cre_acct
							,mod_dte
							,mod_acct
							,exp_dte
							)
						SELECT @proj_cde
							,@auth_user AS usr_acct
							,'N'         AS admin_ind
							,GETDATE()   AS cre_dte
							,@usr_acct   AS cre_acct
							,GETDATE()   AS mod_dte
							,@usr_acct   AS mod_acct
							,DATEADD(mm, 6, GETDATE()) AS exp_dte
					END
				END

				/** confirm authorized user **/
				/*
				SELECT '@auth_rpt' [@auth_rpt], * FROM @auth_rpt
				*/

				UPDATE [DevelopmentEfforts].[DevelopmentEffortSecure]
				SET  admin_ind	= 'N'
					,exp_dte  = DATEADD(mm, 6, GETDATE())
					,mod_dte  = GETDATE()
					,mod_acct = @usr_acct
				FROM [DevelopmentEfforts].[DevelopmentEffortSecure] AS auth
				JOIN @AuthRpt AS rpt 
				  ON rpt.auth_acct = auth.usr_acct
				 AND UPPER(rpt.crud_typ)  = 'CHANGED'
				WHERE auth.proj_cde = @proj_cde

				/** delete authorized user **/
				UPDATE [DevelopmentEfforts].[DevelopmentEffortSecure]
				SET  admin_ind	= 'N'
					,exp_dte	= GETDATE()
					,mod_dte	= GETDATE()
					,mod_acct	= @usr_acct
				FROM [DevelopmentEfforts].[DevelopmentEffortSecure] AS auth
				JOIN @AuthRpt AS rpt 
				  ON rpt.auth_acct = auth.usr_acct
				 AND UPPER(rpt.crud_typ)  = 'DELETED'
				WHERE auth.proj_cde = @proj_cde
			END

/****************************************************************************************
**                                    Create project
****************************************************************************************/

			IF UPPER(@function) = 'NEW' AND @exists_ind = 'N'
				INSERT [DevelopmentEfforts].[DevelopmentEffort] 
					(proj_cde, inactive_dte, bus_unit_idn, proj_cmnt, proj_dsc)
					VALUES (@proj_cde, @inactive_dte, @bus_unit_idn, @proj_cmnt, @proj_dsc)

			COMMIT TRAN

	END TRY
    BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRAN;

		THROW;
	END CATCH

    SELECT '0'
        
    IF @@error != 0 SELECT @@error as error, 'Stored procedure DevEffortsSaveUpdates failure.' AS msg
        RETURN @@error
    SET NOCOUNT OFF

END
GO


