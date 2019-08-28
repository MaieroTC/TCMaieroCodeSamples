/********************************************************
  Orginization Name: The Sun Valley Group, Inc.
  File Name: PicksVsSalesGradeControllers.cfc
  Purpose: 
  Accessed from: 
  Author: TC Maiero
  Date:
  Modifications by:
  Modified on: 
  Modification details:
  Parameters (Variables):
  Page Interactions:
********************************************************/
    
component{
    Query_to_JSON = createObject("component", "MM.component.cfc.CFQuerytoJSON");
    FloTypeFunctions = createObject("component", "MM.FarmnetCommon.Attributes.BaseFlowerTypeFunctions");
    StartInv = createObject("component", "MM.PickProjectionsVsSales.cfc.GetStartingInventory");
    ProjFunctions = createObject("component", "MM.FarmnetCommon.Inventory.Projections.BaseProjectionFunctions");
    GetTypeVar = createObject("component", "MM.PickProjectionsVsSales.cfc.GetUniqueAttributes");

    /**
     * GetGradeProjections - Will get grade projections for a specific 
     * @dateStart       {date} dateStart 
     * @dateEnd         {date} dateEnd 
     * @flowerType      {string} flowerType
     */
    public function GetGradeProjections(required dateStart, required dateEnd, required flowerType) returnFormat = "JSON"{
        try{
            // Return Array
            var gradeProjections = ArrayNew(1);
            
            // Need to create an array of structs to store all the data.
            gradeProjections[2] = ArrayNew(1);
            
            // Get Flower type Info
            var flowerInfo = FloTypeFunctions.GetActiveFlowerTypeInfo(flowerType);
            if(flowerInfo[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveFlowerTypeInfo',
                    detail = flowerInfo[2]
                );
            }
            
            // // Start to build the return array
            if(flowerinfo[1]){
                gradeProjections[2] = flowerInfo[2][1];
            }else{
                gradeProjections[1] = false;
                gradeProjections[2] = '[]'; 
                return gradeProjections;
            }
            
            // Get starting Inventory data added
            var startingInventory = StartInv.GetGradeBreakoutForStartingInventoryByType(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), false, flowerType);
            if(startingInventory[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetGradeBreakoutForStartingInventoryByType',
                    detail = startingInventory[2]
                );
            }
            
            gradeProjections[2].StartingInvByGrade = startingInventory[2];
            
            // Get Pick by grade Projections
            var pickProjections = ProjFunctions.GetPickProjectionsByDateRangeFlowerTypeAndGrade(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flowerType);
            if(pickProjections[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetPickProjectionsByDateRangeFlowerTypeAndGrade',
                    detail = pickProjections[2]
                );
            }
            
            gradeProjections[2].PickProjectionsByGrade = pickProjections[2];
            
            // Get Sales Projectsions
            var salesProjections = ProjFunctions.GetSaleProjectionsByDateRangeFlowerTypeAndGrade(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flowerType, false);
            if(salesProjections[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetSaleProjectionsByDateRangeFlowerTypeAndGrade',
                    detail = salesProjections[2]
                );
            }
            
            gradeProjections[2].SalesProjectionsByGrade = salesProjections[2];
            
            var guessSalesProjections = ProjFunctions.GetSaleProjectionsByDateRangeFlowerTypeAndGrade(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flowerType, true);
            if(guessSalesProjections[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetSaleProjectionsByDateRangeFlowerTypeAndGrade',
                    detail = guessSalesProjections[2]
                );
            }
            
            gradeProjections[2].GuessSalesProjectionsByGrade = salesProjections[2];
            
            gradeProjections[1] = true;
            
            return gradeProjections;
        }catch(any fe){
            var gradeProjections = ArrayNew(1);
            gradeProjections[1] = 'ERROR';
            gradeProjections[2] = SerializeJSON(fe);
            return gradeProjections;
        }catch(any e){
            var gradeProjections = ArrayNew(1);
            gradeProjections[1] = 'ERROR';
            gradeProjections[2] = SerializeJSON(e);
            return gradeProjections;
        }
    }
    
    /**
     * [GetVarietyGradeProjectionsByColor description]
     * @dateStart       {date} required [description]
     * @dateEnd         {date} required [description]
     * @flowerType      {string} required [description]
     * @colorCode       {string} required [description]
     */
    public function GetVarietyGradeProjectionsByColor(required dateStart, required dateEnd, required flowerType, required colorCode) returnFormat = 'JSON'{
        try{
            var gradeProjections = ArrayNew(1);
            var gradeProjections[2] = ArrayNew(1);
            
            // Build the list of varieties for the color code that are active.
            // Get the active varieties based on starting inventory
            var flowerVarieties = GetTypeVar.GetActiveFlowerVarietiesByColor(DateFormat(dateStart , "mm/dd/yyyy"),DateFormat(dateEnd , "mm/dd/yyyy"), flowerType, colorCode);
            if(flowerVarieties[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveFlowerVarietiesByColor',
                    detail = flowerVarieties[2]
                );
            }
        
            // Loop through the active variety list and get the grade projection info 
            for(flower in flowerVarieties[2]){
                var varietyGradeProj = THIS.GetVarietyGradeProjectionsByTypeVareityAndDate(DateFormat(dateStart , "mm/dd/yyyy"),DateFormat(dateEnd , "mm/dd/yyyy"), flowerType, flower.variety);
                if(varietyGradeProj[1] == 'ERROR'){
                    Throw(
                        type = 'functionError',
                        message = 'GetVarietyGradeProjectionsByTypeVareityAndDate',
                        detail = varietyGradeProj[2]
                    );
                }
                // Add to fincl array
                var appendArray = ArrayAppend(gradeProjections[2], varietyGradeProj[2]);
            }
            gradeProjections[1] = true;
        
            return gradeProjections;
        }catch(functionError fe){
            var gradeProjections = ArrayNew(1);
            gradeProjections[1] = 'ERROR';
            gradeProjections[2] = SerializeJSON(fe);
            writedump(fe);
            return gradeProjections; 
        }catch(any e){
            var gradeProjections = ArrayNew(1);
            gradeProjections[1] = 'ERROR';
            gradeProjections[2] = SerializeJSON(e);
            writedump(e);
            return gradeProjections;
        }
    }
    
    /**
     * Will get the grade breakout for a speicifc variety in a specific date range
     * @dateStart           {date} required
     * @dateEnd             {date} required
     * @flowerType          {string(3)} required 
     * @flowerVariety       {string(3)} required 

     */
    public function GetVarietyGradeProjectionsByTypeVareityAndDate(required dateStart, required dateEnd, required flowerType, required flowerVariety) returnFomat = "JSON"{
        try{
            // Return Arry
            var gradeProjections = ArrayNew(1);
            
            // Need to create a array to use array append
            gradeProjections[2] = ArrayNew(1);
            
            // Get Flower Info
            var flowerInfo = FloTypeFunctions.GetVarietyInfoByTypeAndVariety(flowerType, flowerVariety);
            if(flowerInfo[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetVarietyInfoByTypeAndVariety',
                    detail = flowerInfo[2]
                );
            }
            
            // Start building the Return array
            if(flowerInfo[1] == true){
                gradeProjections[2] = flowerInfo[2][1];
            }else{
                gradeProjections[1] = false;
                gradeProjections[2] = '[]'; 
                return gradeProjections;
            }
            
            // Get starting Inventory
            var startingInventory = StartInv.GetGradeBreakoutForStartingInventoryByTypeAndVariety(DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'), false, flowerType, flowerVariety);
            if(startingInventory[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetGradeBreakoutForStartingInventoryByTypeAndVariety',
                    detail = startingInventory[2]
                );
            }
            
            // Add Starting inventory to the return array
            gradeProjections[2].StartingInvByGrade = startingInventory[2];
            
            // Get pick projections by grade
            var pickProjections = ProjFunctions.GetPickProjectionsByDateRangeFlowerVarietyAndGrade(DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'), flowerType, flowerVariety);
            if(pickProjections[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetPickProjectionsByDateRangeFlowerVarietyAndGrade',
                    detail = pickProjections[2]
                );
            }
            
            // Add Starting inventory to the return array
            gradeProjections[2].PickProjectionsByGrade = pickProjections[2];
            
            // Get Sales Projections
            var salesProjections = ProjFunctions.GetSaleProjectionsByDateRangeFlowerTypeVarietyAndGrade(DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'), flowerType, flowerVariety, false);
            if(salesProjections[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetSaleProjectionsByDateRangeFlowerTypeVarietyAndGrade',
                    detail = salesProjections[2]
                );
            }
            
            gradeProjections[2].SalesProjectionsByGrade = salesProjections[2];
            
            // Get Sales Projections
            var guessSalesProjections = ProjFunctions.GetSaleProjectionsByDateRangeFlowerTypeVarietyAndGrade(DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'), flowerType, flowerVariety, true);
            if(guessSalesProjections[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetSaleProjectionsByDateRangeFlowerTypeVarietyAndGrade',
                    detail = guessSalesProjections[2]
                );
            }
            
            gradeProjections[2].GuessSalesProjectionsByGrade = guessSalesProjections[2];
            
            gradeProjections[1] = true;
            
            return gradeProjections;
        }catch(functionError fe){
            var gradeProjections = ArrayNew(1);
            gradeProjections[1] = 'ERROR';
            gradeProjections[2] = SerializeJSON(fe);
            //writedump(fe);
            return gradeProjections; 
        }catch(any e){
            var gradeProjections = ArrayNew(1);
            gradeProjections[1] = 'ERROR';
            gradeProjections[2] = SerializeJSON(e);
            //writedump(e);
            return gradeProjections;
        } 
    }
}
