<cfsetting showdebugoutput="NO">  
<cfobject component = "MM.PickProjectionsVsSales.reports.controllers.PickVsSalesProjectionsController" name = "ReportController">
    
<cfset pickvsSalesDataVarietyDrillDown = ReportController.BuildPickvsSalesProjectionsVarietyData(url.startDate, url.endDate, url.flowerType)>

<cfif pickvsSalesDataVarietyDrillDown[1] eq true>
    <cfoutput>
        #SerializeJSON(pickvsSalesDataVarietyDrillDown[2])#
    </cfoutput>
</cfif>
