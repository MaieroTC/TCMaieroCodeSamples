<!---
  Orginization Name: The Sun Valley Group, Inc.
  File Name: 
  Purpose: 
  Accessed from: 
  Author: TC Maiero
  Date:
  Modifications by:
  Modified on: 
  Modification details:
--->
    
<!--- TCM  - Main Header  --->
<cfinclude template="/MM/MainHeader.cfm">
<cfsetting showdebugoutput="YES">  

<!--- TCM - Need Both Jquery things to work --->
<script src="/MM/js/lib/jquery-3.3.1.min.js"></script>
<script src="/MM/js/lib/jquery-ui-1.12.1/jquery-ui.min.js"></script>
<link rel ="stylesheet" type="text/css" href="/MM/js/lib/jquery-ui-1.12.1/jquery-ui.min.css">
<!--- TCM - End Jquery inserts ---> 

<cfobject component = "MM.Accounting.DailyImport.models.AxCustomerFunctions" name = "CustomerInfo">
<cfobject component = "MM.Accounting.DailyImport.models.AxInvoiceImport" name = "DailySales">
<cfobject component = "MM.Accounting.DailyImport.Services.AxDailyImportService" name = "AxServices">
<cfobject component = "MM.Accounting.DailyImport.Services.AxCustomerImportService" name = "AxCustomerServices">
<cfobject component = "MM.Accounting.DailyImport.Controllers.AxDailyImportController" name = "AxController">


<cfif IsDefined('form.getInvoiceHeader')>
    <cfset invoice = DailySales.InvoiceHeaderGetTotalByDay(form.date)>
    <cfdump var = "#invoice#">
</cfif>

<cfif IsDefined('form.getInvoiceDetails')>
    <cfset invoice = DailySales.InvoiceDetailGetTotalByDay(form.date)>
    <cfdump var = "#invoice#">
</cfif>


<cfif IsDefined('form.getSourceType')>
    <cfset invoice = DailySales.SourceTypeByInvoiceGetTotalByDay(form.date)>
    <cfdump var = "#invoice#">
</cfif>


<cfif IsDefined('form.getInvoiceBillAs')>
    <cfset invoice = DailySales.InvoiceBillAsGetTotalByDay(form.date)>
    <cfdump var = "#invoice#">
</cfif>

<cfif IsDefined('form.getDailySalesTotal')>
    <cfset invoice = DailySales.GetDirectSalesJournalTotals(form.date)>
    <cfdump var = "#invoice#">
</cfif>

<cfif IsDefined("form.getAxImportInfo")>
    <cfset info = DailySales.AxImportDailySalesInfo(form.date)>
    <cfoutput>
        #ArrayLen(info[2])#
    </cfoutput>
    <cfdump var = "#info#">
</cfif>

<cfif IsDefined("form.getAxImportInfoTotal")>
    <cfset info = DailySales.GetAxImportTotal(form.date)>
    <cfdump var = "#info#">
</cfif>


<cfif IsDefined('form.getCustomer')>
    <cfif form.getCustomer eq ''>
        <cfset form.getCustomer = 'ALL'>
    </cfif>
    <cfset customer = CustomerInfo.AxCustomerImportInformation(form.customerNumber)>
    <cfdump var = "#customer#">
</cfif>

<cfif IsDefined("form.checkAxImport")>
    <cfset axChecks = AxServices.GetAxImportValidationData(form.date)>
    <cfdump var = "#axChecks#">
</cfif>

<cfif IsDefined("form.getAxImport")>
    <cfset axData = AxServices.GetAxImportData(form.date)>
    <cfdump var = "#axData#">
</cfif>

<cfif IsDefined("getCustomerServ")>
    <cfset axCust = AxCustomerServices.GetAxCustomerData(form.customerNumber)>
    <cfdump var = "#axCust#">
</cfif>

<cfif IsDefined("form.checkAxImportCont")>
    <cfset info = AxController.ValidateAxInvoiceInfo(form.date)>
    <cfdump var = "#info#">
</cfif>

<cfif IsDefined("form.getAxImportCont")>
    <cfset info = AxController.GetAxInvoiceImportInfo(form.date, false)>
    <cfdump var = "#info#">
</cfif>

<cfif IsDefined("form.getAxImportLateFeeCont")>
    <cfset info = AxController.GetAxInvoiceImportInfo(form.date, true)>
    <cfdump var = "#info#">
</cfif>

<cfif IsDefined("form.getCustomerCont")>
    <cfset info = AxController.GetAxCustomerImportInfo(form.customerNumber)>
    <cfdump var = "#info#">
</cfif>

<!---***************************************** TC - PAGE*********************** --->

<!--- TC - ****************Invoice Functions ***************************--->
<h2>Base Ax Import Invoice Functions</h2>

<form name="getInvoiceHeader" action="TestPage.cfm" method='POST'>
    <strong>Get Invoice Header Total</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getInvoiceHeader" value="Submit"/>
</form>

<form name="getInvoiceDetails" action="TestPage.cfm" method='POST'>
    <strong>Get Invoice Details Total</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getInvoiceDetails" value="Submit"/>
</form>

<form name="getSourceType" action="TestPage.cfm" method='POST'>
    <strong>Get Source Type by Invoice Total</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getSourceType" value="Submit"/>
</form>


<form name="getInvoiceBillAs" action="TestPage.cfm" method='POST'>
    <strong>Get Invoice Bill As Total</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getInvoiceBillAs" value="Submit"/>
</form>


<form name="getDailySalesTotal" action="TestPage.cfm" method='POST'>
    <strong>Get Daily Sales Total</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getDailySalesTotal" value="Submit"/>
</form>

<form name="getAxImportInfoTotal" action="TestPage.cfm" method='POST'>
    <strong>Get Axapta Import Info Total</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getAxImportInfoTotal" value="Submit"/>
</form>

<form name="getAxImportInfo" action="TestPage.cfm" method='POST'>
    <strong>Get Axapta Import Info</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getAxImportInfo" value="Submit"/>
</form>

<!--- TC - ***************Customer functions ******************** --->
<h2>Base Ax Customer Functions</h2>
<form name="getCustomer" action="TestPage.cfm" method='POST'>
    <strong>Get Customer Info</strong><br />
    Customer:<input type="text" name = "customerNumber" /> <br />
    <input type = "submit" name="getCustomer" value="Submit"/>
</form>

<!--- TC - *************View Models****************************** --->
<h2>Ax Invoice Import View Models</h2>
<form name="checkAxImport" action="TestPage.cfm" method='POST'>
    <strong>Check Ax Import Data</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="checkAxImport" value="Submit"/>
</form>

<form name="getAxImport" action="TestPage.cfm" method='POST'>
    <strong>Get Ax Import Data</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getAxImport" value="Submit"/>
</form>

<form name="getCustomerServ" action="TestPage.cfm" method='POST'>
    <strong>Get Customer Info</strong><br />
    Customer:<input type="text" name = "customerNumber" maxlength="6"/> <br />
    <input type = "submit" name="getCustomerServ" value="Submit"/>
</form>

<!--- TC - *************Controllers****************************** --->
<h2>Ax Invoice Import Controllers</h2>
<form name="checkAxImportCont" action="TestPage.cfm" method='POST'>
    <strong>Check Ax Import Controller</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="checkAxImportCont" value="Submit"/>
</form>

<form name="getAxImportCont" action="TestPage.cfm" method='POST'>
    <strong>Get Ax Import Data Controller</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getAxImportCont" value="Submit"/>
</form>

<form name="getAxImportLateFeeCont" action="TestPage.cfm" method='POST'>
    <strong>Get Ax Late Fee Import Data Controller</strong><br />
    Day:<input type="date" name = "date" /> <br />
    <input type = "submit" name="getAxImportLateFeeCont" value="Submit"/>
</form>


<form name="getCustomerCont" action="TestPage.cfm" method='POST'>
    <strong>Get Customer Info Controller</strong><br />
    Customer:<input type="text" name = "customerNumber" maxlength="6"/> <br />
    <input type = "submit" name="getCustomerCont" value="Submit"/>
</form>

<cfinclude template="/MM/MainFooter.cfm">
