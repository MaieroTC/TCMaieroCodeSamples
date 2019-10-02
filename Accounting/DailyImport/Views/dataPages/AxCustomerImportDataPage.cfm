<cfsetting showdebugoutput="NO">  
<cfobject component = "MM.Accounting.DailyImport.Controllers.AxDailyImportController" name = "AxController">

    
<cfset data = AxController.GetAxCustomerImportInfo(url.theCustomerNumber)>

<cfif data[1] neq 'ERROR'>
    <cfoutput>
        #SerializeJSON(data[2])#
    </cfoutput>
</cfif>
