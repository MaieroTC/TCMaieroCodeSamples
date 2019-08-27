<cfsetting showdebugoutput="NO">  
<cfobject component = "MM.PickProjectionsVsSales.reports.controllers.PickVsSalesProjectionsController" name = "ReportController">
    
<cfset pickvsSalesData = ReportController.BuildPickvsSalesProjectionsData(url.startDate, url.endDate)>

<cfif pickvsSalesData[1] eq true>
    <cfoutput>
        #SerializeJSON(pickvsSalesData[2])#
    </cfoutput>
</cfif>
