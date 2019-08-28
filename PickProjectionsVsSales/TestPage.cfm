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

<cfobject component = "MM.FarmnetCommon.Attributes.BaseFlowerTypeFunctions" name = "FlowerTypes">
<cfobject component = "MM.FarmnetCommon.Inventory.InventoryAging.BaseInventoryAgingFunctions" name = "InvAging">
<cfobject component = "MM.FarmnetCommon.Skus.cfc.BaseSkuFunctions" name = "SkuFunc">
<cfobject component = "MM.FarmnetCommon.Inventory.Projections.BaseProjectionFunctions" name = "Projections">
<cfobject component = "MM.FarmnetCommon.Orders.cfc.OrderItemFunctions" name = "OrderItems">
<cfobject component = "MM.PickProjectionsVsSales.cfc.GetStartingInventory" name = "GetInv">
<cfobject component = "MM.PickProjectionsVsSales.cfc.GetUniqueAttributes" name = "GetActiveTypes">
<cfobject component = "MM.PickProjectionsVsSales.reports.controllers.PickVsSalesProjectionsController" name = "ReportController">
<cfobject component = "MM.PickProjectionsVsSales.reports.controllers.PicksVsSalesGradeControllers" name = "GradeController">



<cfif IsDefined('form.getTypes')>
    <cfset types = DeSerializeJSON(FlowerTypes.GetAllFlowerTypes())>
    <cfdump var = "#types[2]#">
</cfif>

<cfif IsDefined('form.getActiveTypes')>
    <cfset types = GetActiveTypes.GetActiveFlowerTypes(form.startDate, form.endDate)>
    <cfdump var = "#types[2]#">
</cfif>


<cfif IsDefined('form.getStartingInventoryBySku')>
    <cfset inv = DeSerializeJSON(InvAging.GetIngrediantInventoryAging(form.sku))>
    <cfdump var = "#DeSerializeJSON(inv[2])#">
</cfif>


<cfif IsDefined('form.getStartingInventoryByType')>
    <cfset inv = GetInv.GetStartingInventoryByDivisionByType()>
    <cfdump var = "#inv[2]#">
</cfif>

<cfif IsDefined('form.getPickProjections')>
    <cfset pickProjections = Projections.GetPickProjectionsByDateRangeAndFlowerTypeByDay(form.startDate, form.endDate, form.floType)>
    <cfdump var = "#pickProjections[2]#">
</cfif>


<cfif IsDefined('form.getSaleProjections')>
    <cfset saleProjections = Projections.GetSaleProjectionsByDateRangeAndFlowerTypeByDay(form.startDate, form.endDate, form.floType, form.guessOrders)>
    <cfdump var = "#saleProjections[2]#">
</cfif>

<cfif isDefined('form.testPickVsSalesProjectionsController')>
    <cfset controllerTesting = ReportController.BuildPickvsSalesProjectionsData(form.startDate, form.endDate)>
    <cfdump var = "#controllerTesting#">
</cfif>

<!--- TC - Dill Downs --->
<cfif IsDefined('form.getVarieties')>
    <cfset varieties = FlowerTypes.GetAllFlowerVaritiesByType(form.flowerType)>
    <cfdump var = "#varieties[2]#">
</cfif>

<cfif IsDefined('form.getActiveVarieties')>
    <cfset varieties = GetActiveTypes.GetActiveFlowerVarieties(form.startDate, form.endDate, form.flowerType)>
        
    <cfdump var = "#varieties[2]#">    
</cfif>

<cfif IsDefined("form.getStartingInventoryByVariety")>
    <cfset startingInventory = GetInv.GetStartingInventoryByDivisionVariety(form.flowerType, form.flowerVariety)>
        
    <cfdump var = "#startingInventory[2]#">    
</cfif>


<cfif IsDefined("form.getVarietySaleProjections")>
    <cfset salesProjections = Projections.GetSaleProjectionsByDateRangeAndFlowerVarietyByDay(form.startDate, form.endDate, form.flowerType, form.flowerVariety, form.guessOrders)>
        
    <cfdump var = "#salesProjections[2]#">    
</cfif>


<cfif IsDefined("form.getPickVarietyProjections")>
    <cfset pickProjections = Projections.GetPickProjectionsByDateRangeAndFlowerVarietyByDay(form.startDate, form.endDate, form.flowerType, form.flowerVariety)>
        
    <cfdump var = "#pickProjections[2]#">
</cfif>

<cfif IsDefined("form.testPickVsSalesProjectionsVarietyController")>
    <cfset pickProjections = ReportController.BuildPickvsSalesProjectionsVarietyData(form.startDate, form.endDate, form.flowerType)>
        
    <cfdump var = "#pickProjections[2]#">
</cfif>

<cfif isDefined("form.getStartingInventoryByChannel")>
    <cfset getInventoryByChannel = InvAging.GetIngediantInventoryTotalsByInventoryChannel(form.flowerType)>
        
    <cfdump var ="#getInventoryByChannel#">
</cfif>

<cfif isDefined("form.getOrderStemInformation")>
    <cfset getOrderStems = ReportController.BuildPickvsSalesProjectionsOrderData(form.theDate, form.theDivision, form.theFlowerType, form.excludeTransfers)>
        
    <cfdump var = "#getOrderStems#">
</cfif>

<cfif isDefined('getPickProjectionsByGrade')>
    <cfset getProjectionsByTypeAndGrade = Projections.GetPickProjectionsByDateRangeFlowerTypeAndGrade(form.startDate, form.endDate, form.flowerType)>
    
    <cfdump var = "#getProjectionsByTypeAndGrade#">
</cfif>

<cfif isDefined('getPickProjectionsByGradeVariety')>
    <cfset getProjectionsByVarietyAndGrade = Projections.GetPickProjectionsByDateRangeFlowerVarietyAndGrade(form.startDate, form.endDate, form.flowerType, form.flowerVariety)>
        
    <cfdump var = "#getProjectionsByVarietyAndGrade#">
</cfif>

<cfif isDefined('getSaleProjectionsByGrade')>
    <cfset getSalesProjectionsByTypeAndGrade = Projections.GetSaleProjectionsByDateRangeFlowerTypeAndGrade(form.startDate, form.endDate, form.flowerType, form.guessOrders)>
        
    <cfdump var = '#getSalesProjectionsByTypeAndGrade#'>
</cfif>

<cfif isDefined('getStartingInventoryByGrade')>
    <cfset getStartingInventoryByTypeGrade = GetInv.GetAllStartingInventoryByDivisionTypeAndGrade(form.startDate, form.endDate, false)>
        
    <cfdump var = '#getStartingInventoryByTypeGrade#'>
</cfif>

<cfif isDefined('getStartingInventoryByGradeByType')>
    <cfset getStartingInventoryByTypeGrade = GetInv.GetGradeBreakoutForStartingInventoryByType(form.startDate, form.endDate, false, form.flowerType)>
        
    <cfdump var = '#getStartingInventoryByTypeGrade#'>
</cfif>

<cfif IsDefined("getGradeInfoController")>
    <cfset getGradeInfo = GradeController.GetGradeProjections(form.startDate, form.endDate, form.flowerType)>
        
    <cfdump var = "#getGradeInfo#">
</cfif>

<cfif IsDefined("getVarietiesByTypeandColor")>
    <cfset floVarieties = FlowerTypes.GetVarietiesByTypeAndColor(form.flowerType, form.colorCode)>

    <cfdump var = '#floVarieties#'>
</cfif>


<cfif IsDefined("form.getAllStartingInvByGradeVariety")>
    <cfset startingInv =  GetInv.GetAllStartingInventoryByDivisionTypeVariertyAndGrade(form.startDate, form.endDate, false, form.flowerType)>
        
    <cfdump var = "#startingInv#">
</cfif>

<cfif IsDefined("form.getStartingInvByGradeVariety")>
    <cfset startingInv =  GetInv.GetGradeBreakoutForStartingInventoryByTypeAndVariety(form.startDate, form.endDate, false, form.flowerType, form.flowerVariety)>
        
    <cfdump var = "#startingInv#">
</cfif>

<cfif IsDefined("form.getSaleProjectionsVarietyByGrade")>
    <cfset salesVarProj = Projections.GetSaleProjectionsByDateRangeFlowerTypeVarietyAndGrade(form.startDate, form.endDate, form.flowerType, form.flowerVariety, form.guessOrders)>
        
    <cfdump var = '#salesVarProj#'>
</cfif>

<cfif IsDefined("form.getVarietyInfoController")>
    <cfset gradeVarProj = GradeController.GetVarietyGradeProjectionsByTypeVareityAndDate(form.startDate, form.endDate, form.flowerType, form.flowerVariety)>
    
    <cfdump var = '#gradeVarProj#'>
</cfif>


<cfif IsDefined("form.getVarietyInfoByColorController")>
    <cfset gradeVarProj = GradeController.GetVarietyGradeProjectionsByColor(form.startDate, form.endDate, form.flowerType, form.colorCode)>
    
    <cfdump var = '#gradeVarProj#'>
</cfif>


<!---***************************************** TC - PAGE*********************** --->
<h2>Base Pick vs Sale</h2>

<form name="getTypes" action="TestPage.cfm" method='POST'>
    <strong>Get All Flower Types</strong><br />
    <input type = "submit" name="getTypes" value="Submit"/>
</form>

<form name = "getActiveTypes" action= "TestPage.cfm" method="POST">
    <strong>Get Active Types</strong><br />
    From:<input type="date" name = "startDate" /> <br />
    To:<input type="date" name = "endDate" /><br />
    <input type = "submit" name="getActiveTypes" value="Submit"/>
</form>


<form name="getStartingInventoryBySku" action="TestPage.cfm" method='POST'>
    <strong>Get Inventory Aging by Sku. For all type All</strong><br />
    <input type = "text" name="sku"/>
    <input type = "submit" name="getStartingInventoryBySku" value="Submit"/>
</form>

<form name="getStartingInventoryByType" action="TestPage.cfm" method='POST'>
    <strong>Get Total InvAging By Type</strong><br />
    <!--- TC - testGetFlowerType2 --->
    <input type = "submit" name="getStartingInventoryByType" value="Submit"/>
</form>

<form name="getPickProjections" action="TestPage.cfm" method='POST'>
    <strong>Get Pick Projections By Date Range and Flower Type</strong><br />
    From:<input type="date" name = "startDate" /> <br />
    To:<input type="date" name = "endDate" /><br />
    FlowerType:<input type="text" name="floType" />
    <input type = "submit" name="getPickProjections" value="Submit"/>
</form>

<form name="getSaleProjections" action="TestPage.cfm" method='POST'>
    <strong>Get Sale Variety Projections By Date Range and Flower Type</strong><br />
    From:<input type="date" name = "startDate" /> <br />
    To:<input type="date" name = "endDate" /><br />
    FlowerType:<input type="text" name="floType" /><br />
    Guess Orders Only:
    <select name = "guessOrders">
        <option value = "true">
            True
        </option>
        <option value = "false" selected>
            False
        </option>
    </select>
    
    <input type = "submit" name="getSaleProjections" value="Submit"/>
</form>


<form name = "testPickVsSalesProjectionsController" action= "TestPage.cfm" method="POST">
    <strong>Test Pick Vs Sales Report Controller(All Data by type)</strong><br />
    From:<input type="date" name = "startDate" /> <br />
    To:<input type="date" name = "endDate" /><br />
    <input type = "submit" name="testPickVsSalesProjectionsController" value="Submit"/>
</form>

<!--- TC - Drill Down Test --->
<h2>Drill Downs</h2>
<form name = "getVarieties" action= "TestPage.cfm" method="POST">
    <strong>Get Varieties</strong><br />
    Flower Type:<input type="text" name="flowerType"><br />
    <input type = "submit" name="getVarieties" value="Submit"/>
</form>

<form name = "getActiveVarieties" action= "TestPage.cfm" method="POST">
    <strong>Get Active Varieties</strong><br />
    Flower Type:<input type="text" name="flowerType"><br />
    From:<input type="date" name = "startDate" /> <br />
    To:<input type="date" name = "endDate" /><br />
    <input type = "submit" name="getActiveVarieties" value="Submit"/>
</form>

<form name="getStartingInventoryByVariety" action="TestPage.cfm" method='POST'>
    <strong>Get Total InvAging By Variety</strong><br />
    <!--- TC - testGetFlowerType2 --->
    Flower Type:<input type="text" name="flowerType" /><br />
    Flower Variety:<input type="text" name="flowerVariety" /><br />
    <input type = "submit" name="getStartingInventoryByVariety" value="Submit"/>
</form>

<form name="getVarietySaleProjections" action="TestPage.cfm" method='POST'>
    <strong>Get Sale variety Projections By Date Range and Flower Type</strong><br />
    From:<input type="date" name = "startDate" /> <br />
    To:<input type="date" name = "endDate" /><br />
    FlowerType:<input type="text" name="flowerType" /><br />
    FlowerVariety:<input type="text" name="flowerVariety" /><br />
    Guess Orders Only:
    <select name = "guessOrders">
        <option value = "true">
            True
        </option>
        <option value = "false" selected>
            False
        </option>
    </select>
    
    <input type = "submit" name="getVarietySaleProjections" value="Submit"/>
</form>

<form name="getPickVarietyProjections" action="TestPage.cfm" method='POST'>
    <strong>Get Pick Projections By Date Range and Flower Variety</strong><br />
    From:<input type="date" name = "startDate" /> <br />
    To:<input type="date" name = "endDate" /><br />
    FlowerType:<input type="text" name="flowerType" /><br />
    FlowerVariety:<input type="text" name="flowerVariety" /><br />
    <input type = "submit" name="getPickVarietyProjections" value="Submit"/>
</form>

<form name = "testPickVsSalesProjectionsVarietyController" action= "TestPage.cfm" method="POST">
    <strong>Test Pick Vs Sales By Color and Variety Report Controller</strong><br />
    From:<input type="date" name = "startDate" /> <br />
    To:<input type="date" name = "endDate" /><br />
    FlowerType:<input type="text" name="flowerType" /><br />
    <input type = "submit" name="testPickVsSalesProjectionsVarietyController" value="Submit"/>
</form>

<form name="getStartingInventoryByChannel" action="TestPage.cfm" method='POST'>
    <strong>Get Sale variety Projections By Date Range and Flower Type</strong><br />
    FlowerType:<input type="text" name="flowerType" /><br />
    All Divisions:
    <select name = "allDivisions">
        <option value = "true">
            True
        </option>
        <option value = "false" selected>
            False
        </option>
    </select>
    
    <input type = "submit" name="getStartingInventoryByChannel" value="Submit"/>
</form>

<form name="getOrderStemInformation" action="TestPage.cfm" method="POST">
    <strong>Get Stems in Order</strong>
    Date:<input type="date" name = "theDate" /> <br />
    FlowerType:<input type="text" name="theFlowerType" /><br />
    Division:<input type="text" name="theDivision" /><br />
    Exclude Transfer Order:
    <select name = "excludeTransfers">
        <option value = "true">
            True
        </option>
        <option value = "false" selected>
            False
        </option>
    </select>
    <input type = "submit" name="getOrderStemInformation" value="Submit"/>
</form>


<h2>Grade Functions</h2>

<h3>Grade Type Functions</h3>
<strong>Get Pick Projection By Type & Grade</strong>
<form name="getPickProjectionsByGrade" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    <input type = "submit" name="getPickProjectionsByGrade" value="Submit"/>
</form>

<strong>Get Sales Projection By Type & Grade</strong>
<form name="getSaleProjectionsByGrade" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    Guess Orders Only:
    <select name = "guessOrders">
        <option value = "true">
            True
        </option>
        <option value = "false" selected>
            False
        </option>
    </select>
    <input type = "submit" name="getSaleProjectionsByGrade" value="Submit"/>
</form>

<strong>Get All Starting Inventory By Type & Grade</strong>
<form name="getStartingInventoryByGrade" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    <input type = "submit" name="getStartingInventoryByGrade" value="Submit"/>
</form>

<strong>Get Starting Inventory By Type & Grade</strong>
<form name="getStartingInventoryByGradeByType" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    <input type = "submit" name="getStartingInventoryByGradeByType" value="Submit"/>
</form>

<strong>Get Grade Info Controller</strong>
<form name="getGradeInfoController" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    <input type = "submit" name="getGradeInfoController" value="Submit"/>
</form>

<h3>Grade Variety and Color Functions</h3>
<strong>Get Pick Projection By Variety & Grade</strong>
<form name="getPickProjectionsByGradeVariety" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    FlowerVariety:<input type="text" name="flowerVariety" /><br />
    <input type = "submit" name="getPickProjectionsByGradeVariety" value="Submit"/>
</form>

<strong>Get Varieties by Color and Type</strong>
<form name="getVarietiesByTypeandColor" action="TestPage.cfm" method="POST">
    FlowerType:<input type="text" name="flowerType" /><br />
    Color Code:<input type="text" name="colorCode" /><br />
    <input type = "submit" name="getVarietiesByTypeandColor" value="Submit"/>
</form>

<strong>Get All Starting Inventory By Variety and Grades</strong>
<form name="getAllStartingInvByGradeVariety" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    <input type = "submit" name="getAllStartingInvByGradeVariety" value="Submit"/>
</form>

<strong>Get Starting Inventory By Type Variety and Grades</strong>
<form name="getStartingInvByGradeVariety" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    FlowerVariety:<input type="text" name="flowerVariety" /><br />
    <input type = "submit" name="getStartingInvByGradeVariety" value="Submit"/>
</form>

<strong>Get Sales Projections by Variety and Grade</strong>
<form name="getSaleProjectionsVarietyByGrade" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    FlowerVariety:<input type="text" name="flowerVariety" /><br />
    Guess Orders Only:
    <select name = "guessOrders">
        <option value = "true">
            True
        </option>
        <option value = "false" selected>
            False
        </option>
    </select>
    <input type = "submit" name="getSaleProjectionsVarietyByGrade" value="Submit"/>
</form>

<strong>Get Variety Info Controller</strong>
<form name="getVarietyInfoController" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    FlowerVariety:<input type="text" name="flowerVariety" /><br />
    <input type = "submit" name="getVarietyInfoController" value="Submit"/>
</form>

<strong>Get Varieties By Color Info Controller</strong>
<form name="getVarietyInfoByColorController" action="TestPage.cfm" method="POST">
    Start Date:<input type="date" name = "startDate" /> <br />
    End Date:<input type="date" name = "endDate" /> <br />
    FlowerType:<input type="text" name="flowerType" /><br />
    ColorCode:<input type="text" name="colorCode" /><br />
    <input type = "submit" name="getVarietyInfoByColorController" value="Submit"/>
</form>
<cfinclude template="/MM/MainFooter.cfm">
