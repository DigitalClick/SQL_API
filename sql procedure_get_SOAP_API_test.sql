
/****** Object:  StoredProcedure [db_test_API].[SP_test_API_SOAP_By_ApplicationID]    Script Date: 2/05/2022 6:54:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[SP_SOAP_By_ApplicationID]
@ApplicationID nvarchar(100)
as
BEGIN


DECLARE @obj int,
        @url varchar(8000),
        @response varchar(8000),
        @requestHeader varchar(8000),
		@status varchar(50),
		@statusText varchar(1024),
        @requestBody xml,
		@host varchar(1000) = 'sagov-api.test.com.au',
		@SOAPAction varchar(1000) = 'http://test.dws.com.au/GetApplication',
		 @ret INT;

SET @url = 'https://sagov-api.test.com.au/JsonApiService.asmx'

--SET @requestBody = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">  <soap:Body>
--    <GetApplication xmlns="http://test.dws.com.au/">
--      <username>dhs_bit_api</username>
--      <password>Graphbagelrehiretriage0</password>
--      <applicationId>620dbe53ad9c5a29c8e5eabf</applicationId>
--    </GetApplication>
--  </soap:Body>
--</soap:Envelope>'

SET @requestBody = '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <GetApplication xmlns="http://test.dws.com.au/">
      <username>user_name</username>
      <password>password</password>
      <applicationId>'+@ApplicationID+'</applicationId>
    </GetApplication>
  </soap12:Body>
</soap12:Envelope>'



DECLARE @returnvalue nvarchar(4000)
EXEC sp_OACreate 'MSXML2.ServerXMLHttp', @obj OUT
--SELECT @obj obj
EXEC sp_OAMethod @obj, 'Open', NULL, 'POST', @url, false
EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'Host', @host
EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'Content-Type', 'text/xml; charset=utf-8'
EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'Connection', 'keep-alive'
EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'User-Agent', 'DHS - EDW' -- PostmanRuntime/7.29.0
EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'Accept', '*/*'
EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'Accept-Encoding', 'gzip, deflate, br'
EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'SOAPAction', @SOAPAction
--EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'Content-Length', '8000'
EXEC sp_OAMethod @obj, 'send', NULL, @requestBody

/*
DECLARE @hResult int
DECLARE @send NVARCHAR(4000) = 'send("' + REPLACE(@requestBody, '"', '''') + '")';
EXEC @hResult = sp_OAMethod @obj, @send 

--*/



EXEC @ret = sp_OAGetProperty @obj, 'status', @status OUT;
EXEC @ret = sp_OAGetProperty @obj, 'statusText', @statusText OUT;

/*
DECLARE @property varchar(255);  
EXEC @ret = sp_OAGetProperty @obj, 'HostName', @property OUT;  
IF @ret <> 0  
BEGIN  
   EXEC sp_OAGetErrorInfo @obj  
    RETURN  
END  
PRINT @property;  




--*/



EXEC sp_OAGetProperty @obj, 'responseText', @response OUT




--SELECT @response resp
print @response

SELECT  @requestBody RequestBody, @obj obj, @status [status] ,@statusText [statusText] ,@response [RESPONSE]

--Select * from db_admin.parseJSON(@response)


EXEC sp_OADestroy @obj


END