
/****** Object:  UserDefinedFunction [db_admin].[fn_Get_API_Data]    Script Date: 2/05/2022 6:48:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT  db_admin.fn_Get_API_Data('https://reqres.in/api/users')



*/



create function [dbo].[fn_Get_API_Data] (@APIurl varchar(500))
RETURNS varchar(8000) AS
BEGIN

Declare @Object as Int;
Declare @ResponseText as varchar(8000);
 
 -- SET @APIurl = 'https://reqres.in/api/users'

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
Exec sp_OAMethod @Object, 'open', NULL, 'get',@APIurl, --Your Web Service Url (invoked)
                                                              'false'
Exec sp_OAMethod @Object, 'send'
Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
 
--Select @ResponseText
 
Exec sp_OADestroy @Object


RETURN @ResponseText

END
