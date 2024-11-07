Use [Pdm]

/*
Test cases for Save Api

- Creating a new Project
- Creating a new Project but that project already created in DB
- Updating an existing project in which only project details exist no users
- Updating a project which does not exist in DB
- Adding a secure user to a project which does not exist in DB
- Adding one secure user 
- Adding one auth user
- Adding secure user which is already added as auth user
- Adding auth user which is already added as secure user
- Add secure user but it was already there as secure user
- Add auth user but it was already there as auth user
- Add a secure user which is already added as secure user
- Add a auth user which is already added as auth user
- Deleting one user
- Deleting multiple users
- Deleting secure and auth user at the same time
- Update/Confirm one user
- Update/Confirm multiple users
- New user, Delete user(s) & Updating user(s) in one request

- Testing of Changed in which project details changed, a user is confirmed, a user is deleted, a new user is added
*/

/*******************************************************************************
**                             Test Cases
*******************************************************************************/

/*Creating a new project*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'P8',
    @inactive_dte = '2024-10-20 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure',
    @proj_dsc = 'Testing',
    @function = 'New',
    @users = @userTable;

/*Creating a new project in which description and comment are null*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP2',
    @bus_unit_idn = 'P8',
    @inactive_dte = '2024-10-20 00:00:00.000',
    @proj_cmnt = '',
    @proj_dsc = null,
    @function = 'New',
    @users = @userTable;

/*Creating a new project which already exits in DB*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'P8',
    @inactive_dte = '2024-10-20 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedures',
    @proj_dsc = 'Testingg',
    @function = 'New',
    @users = @userTable;

/*Updating a project which has project details only*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'P8',
    @inactive_dte = '2024-10-20 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure updated',
    @proj_dsc = 'Testing updated',
    @function = 'Update',
    @users = @userTable;

/*Updating a project which has project details only (Updating business unit this time)*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Updating a project which does not exist in DB*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSPEmpty',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Adding a secure user to a project which does not exist in DB*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('New', '12284717', 1);

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSPEmpty',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Adding a secure user to a project*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('New', '12284718', 1);

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Adding an auth user to a project*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('New', '12284717', 0);

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'testNew',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2025-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Delete secure user*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('Deleted', '12231602', 1);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Delete auth user*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('Deleted', '12219139', 0),
	   ('Deleted', '12231603', 0),
	   ('Deleted', '12098375', 0);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Delete secure and auth user*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('Deleted', '12219139', 0),
	   ('Deleted', '12231603', 0),
	   ('Deleted', '12284718', 1);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Deleting a user and adding same user in same grid in same request*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('Deleted', '12219139', 0),
	   ('New', '12219139', 0);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Adding secure user but that user is already as auth user*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('New', '12231602', 1);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Adding auth user but that user is already as secure user*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('New', '12284717', 0);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Confirm a secure user*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('Changed', '12284717', 1);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Confirm multiple users*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('Changed', '12284717', 1),
	   ('Changed', '12231602', 0);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Add new user, delete user and confirm user at the same time*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('Deleted', '12098375', 0),
	   ('Deleted', '12231602', 0),
	   ('Changed', '12284717', 1),
	   ('New', '12219139', 0),
	   ('Changed', '12284718', 1);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'XI',
    @inactive_dte = '2024-10-24 00:00:00.000',
    @proj_cmnt = 'Testing Stored Procedure update',
    @proj_dsc = 'Testing update',
    @function = 'Update',
    @users = @userTable;

/*Make every possible change at the same time*/
DECLARE @userTable [DevelopmentEfforts].[DevEffortsUsersUDT];

INSERT INTO @userTable ([action], [userAcct], [isSecureUser])
VALUES ('Deleted', '12098375', 0),
	   ('Deleted', '12231602', 1),
	   ('Changed', '12231602', 1),
	   ('Changed', '12284717', 1),
	   ('New', '12231603', 0);
	   

EXEC [DevelopmentEfforts].[DevEffortsSaveUpdates]
    @usr_acct = '12284717',
    @proj_cde = 'TestSP1',
    @bus_unit_idn = 'L6',
    @inactive_dte = '2024-11-24 00:00:00.000',
    @proj_cmnt = 'Stored Procedure final change...',
    @proj_dsc = 'Testing SP',
    @function = 'Update',
    @users = @userTable;


	
