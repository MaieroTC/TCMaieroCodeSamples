<cfsetting showdebugoutput="NO">  
<cfobject component = "MM.Accounting.DailyImport.Controllers.AxDailyImportController" name = "AxController">

    
<cfset data = AxController.ValidateAxInvoiceInfo(url.theDate)>

<cfif data[1] eq true OR data[1] eq false>
    <cfoutput>
        #SerializeJSON(data)#
    </cfoutput>
</cfif>
