<cfsetting showdebugoutput="NO">  
<cfobject component = "MM.Accounting.DailyImport.Controllers.AxDailyImportController" name = "AxController">

    
<cfset data = AxController.GetAxInvoiceImportInfo(url.theDate)>

<cfif data[1] eq true>
    <cfoutput>
        #SerializeJSON(data[2])#
    </cfoutput>
</cfif>
