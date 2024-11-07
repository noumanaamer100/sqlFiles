USE [Pdm]
GO

/****** Object:  StoredProcedure [DevelopmentEfforts].[UserSelectorData]    Script Date: 07/11/2024 4:58:17 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [DevelopmentEfforts].[UserSelectorData] (
    @PageSize INT = NULL,
    @Page INT = NULL,
    @bookname NVARCHAR(MAX) = NULL, -- Accepting NULL by default
    @wwid NVARCHAR(MAX) = NULL, -- Accepting NULL by default
    @strSpeedUserInd NVARCHAR(1) = NULL, -- Can be 'Y', 'N', or NULL
    @strCurrActiveInd NVARCHAR(1) = NULL -- Can be 'Y', 'N', or NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        RTRIM(usr_acct) AS usrAcct,
        wwid,
        RTRIM(bookname) AS bookname,
        CASE 
            WHEN speed_usr_ind = 'Y' THEN CAST(1 AS BIT)
            WHEN speed_usr_ind = 'N' THEN CAST(0 AS BIT)
            ELSE NULL 
        END AS isSpeedUser,
        CASE 
            WHEN curr_actv_ind = 'Y' THEN CAST(1 AS BIT)
            WHEN curr_actv_ind = 'N' THEN CAST(0 AS BIT)
            ELSE NULL 
        END AS isActiveUser
    FROM 
        [DevelopmentEfforts].DevEffortsUsers
    WHERE 
        wwid > 0
        AND bookname <> ''
        AND (@bookname IS NULL OR UPPER(bookname) LIKE UPPER(@bookname) + '%')
        AND (@wwid IS NULL OR CAST(wwid AS NVARCHAR(MAX)) LIKE @wwid + '%')
        AND (@strSpeedUserInd IS NULL OR speed_usr_ind = @strSpeedUserInd)
        AND (@strCurrActiveInd IS NULL OR curr_actv_ind = @strCurrActiveInd)
    ORDER BY 
        bookname
    OFFSET @PageSize * (@Page - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO


