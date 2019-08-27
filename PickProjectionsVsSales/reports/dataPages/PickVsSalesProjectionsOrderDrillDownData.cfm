<cfsetting showdebugoutput="NO">  
<cfobject component = "MM.PickProjectionsVsSales.reports.controllers.PickVsSalesProjectionsController" name = "ReportController">
    
<cfset pickvsSalesDataOrderDrillDown = ReportController.BuildPickvsSalesProjectionsOrderData(url.theSaleDate, url.theDivision, url.theFlowerType, url.excludeTransfers)>

<cfif pickvsSalesDataOrderDrillDown[1] eq true>
    <cfoutput>
        #SerializeJSON(pickvsSalesDataOrderDrillDown[2])#
    </cfoutput>
<cfelseIf pickvsSalesDataOrderDrillDown[1] eq false>
    <cfoutput>
        []
    </cfoutput>
</cfif>
