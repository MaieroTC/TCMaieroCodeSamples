/********************************************************
  Orginization Name: The Sun Valley Group, Inc.
  File Name: 
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
    InvAging = createObject("component", "MM.FarmnetCommon.Inventory.InventoryAging.BaseInventoryAgingFunctions");
    FloAttributes = createObject("component", "MM.FarmnetCommon.Attributes.BaseFlowerTypeFunctions");
    ActiveTypes = createObject("component", "MM.PickProjectionsVsSales.cfc.GetUniqueAttributes");
    
    /**
     * WIll get all starting inventory by 
     * @dateStart             {date} dateStart       
     * @dateEnd               {date} dateEnd         
     * @channelBreakout       {boolean} channelBreakout 
     */
    public function GetStartingInventoryByDivisionByType(dateStart, dateEnd, channelBreakout)returnFormat = "JSON"{
        try{
            var startingInvAging = ArrayNew(1);
            var startingInvAging[2] = ArrayNew(1);
            
            var startingInvAgingByChannel = ArrayNew(1);
            var startingInvAgingByChannel[2] = ArrayNew(1);
            
            // Get all the flower types to loop over
            if(IsDefined("dateStart") == false || IsDefined("dateEnd")== false){
                var getTypes = FloAttributes.GetAllFlowerTypes();
            }else{
                var getTypes = ActiveTypes.GetActiveFlowerTypes(DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'));
            }
            
            if(IsDefined("dateStart") == true && IsDefined("dateEnd") == true){
                // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
                if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                    var archived = true;
                }else{
                    var archived = false;
                }
            }else{
                var archived = false;
            }
            
            // Loop over all flower types to get the starting inventory for each
            for(flower in getTypes[2]){
                // Check to see if this needs to pull from archived inventory
                if(archived){
                    var typeInv = InvAging.GetArchivedStartingInventoryByTypeByStemMinusDumps(flower.type, DateFormat(dateStart, 'mm/dd/yyyy'));
                }else{
                    var typeInv = InvAging.GetStartingInventoryByTypeByStemMinusDumps(flower.type);
                }
                    
                if(typeInv[1] == 'ERROR'){
                    Throw(
                        type = 'functionError',
                        message = 'GetStartingInventoryByTypeByStemMinusDumps',
                        detail = typeInv[2]
                    );
                }else{
                    flower.startingInventory = typeinv[2];
                }
                // Get Inventory by channels
                if(isdefined('channelBreakout')){
                    if(channelBreakout){
                        if(archived){
                            var channelInv = InvAging.GetIngediantInventoryTotalsByInventoryChannelArchive(flower.type, DateFormat(dateStart, 'mm/dd/yyyy'));
                        }else{
                            var channelInv = InvAging.GetIngediantInventoryTotalsByInventoryChannel(flower.type);
                        }
                        if(channelInv[1] == 'ERROR'){
                            Throw(
                                type = 'functionError',
                                message = 'GetStartingInventoryByTypeByStemMinusDumps',
                                detail = typeInv[2]
                            );
                        }else{
                            flower.startingInvAgingByChannel = channelInv[2];
                        }
                        var appendArray = ArrayAppend(startingInvAging[2], flower);
                    }
                }else{
                    var appendArray = ArrayAppend(startingInvAging[2], flower);
                }
            }
            
            startingInvAging[1] = true;
            return startingInvAging;
        }catch(functionError fe){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(fe);
            writedump(fe);
            return startingInvAging;
        }catch(any e){
            WriteDump(e);
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(e);
            return startingInvAging;
        }
    }
    
    /**
     * [GetStartingInventoryByDivisionVariety description]
     * @param       {[type]} required  
     * @param       {[type]} dateStart
     * @param       {[type]} dateEnd 
     */
    public function GetStartingInventoryByDivisionVariety(required flowerType, dateStart, dateEnd)returnFormat = 'JSON'{
        try{
            var startingInventory = ArrayNew(1);
            var startingInventory[2]=ArrayNew(1);
            
            if(IsDefined("dateStart") == false || IsDefined("dateEnd") == false){
                var getVarieties = FloAttributes.GetAllFlowerVaritiesByType(flowerType);
            }else{
                var getVarieties = ActiveTypes.GetActiveFlowerVarieties(dateStart, dateEnd, flowerType);
            }
            // ******* Check for errors
            
            // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
            if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                var archived = true;
            }else{
                var archived = false;
            }
            
            
            for(flower in getVarieties[2]){
                if(archived){
                    var varietyInv = InvAging.GetArchivedStartingInventoryByVarietyByStemMinusDumps(flowerType, flower.variety, dateStart);
                }else{
                    var varietyInv = InvAging.GetStartingInventoryByVarietyByStemMinusDumps(flowerType, flower.variety);
                }
                
                if(varietyInv[1] == 'ERROR'){
                    Throw(
                        type = 'functionError',
                        message = 'GetStartingInventoryByVarietyByStemMinusDumps',
                        detail = varietyInv[2]
                    );
                }else{
                    flower.startingInventory = varietyInv[2];
                    var appendArray = ArrayAppend(startingInventory[2], flower);
                }
            }
            
            startingInventory[1] = true;
            
            
            return startingInventory;
        }catch(functionError fe){
            var startingInventory = ArrayNew(1);
            startingInventory[1] = 'ERROR';
            startingInventory[2] = SerializeJSON(fe);
            //writedump(fe);
            return startingInventory;
        }catch(any e){
            var startingInventory = ArrayNew(1);
            startingInventory[1] = 'ERROR';
            startingInventory[2] = SerializeJSON(e);
            //writedump(e);
            return startingInventory;
        }
    }
    
    /**
     * This will get all starting inventory broken down to grade for all Divisions and Flower Types
     * [GetAllStartingInventoryByDivisionTypeAndGrade description]
     * @dateStart           {date} dateStart       
     * @dateEnd             {Date} dateEnd         
     * @channelBreakout     {Boolean} channelBreakout 
     */
    public function GetAllStartingInventoryByDivisionTypeAndGrade(dateStart, dateEnd, channelBreakout)returnFormat = 'JSON'{
        try{
            var startingInvAging = ArrayNew(1);
            var startingInvAging[2] = ArrayNew(1);
            
            var startingInvAgingByChannel = ArrayNew(1);
            var startingInvAgingByChannel[2] = ArrayNew(1);
            
            // Get all the flower types to loop over
            if(IsDefined("dateStart") == false|| IsDefined("dateEnd")== false){
                var getTypes = FloAttributes.GetAllFlowerTypes();
            }else{
                var getTypes = ActiveTypes.GetActiveFlowerTypes(DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'));
            }
            
            if(IsDefined("dateStart") == true|| IsDefined("dateEnd") == true){
                // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
                if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                    var archived = true;
                }else{
                    var archived = false;
                }
            }else{
                var archived = false;
            }
            
            // Loop over all flower types to get the starting inventory for each
            for(flower in getTypes[2]){
                // Check to see if this needs to pull from archived inventory
                if(archived){
                    var typeGradeInv = InvAging.GetArchivedStartingInventoryByTypeAndGradeByStemMinusDumps(flower.type, DateFormat(dateStart, 'mm/dd/yyyy'));
                }else{
                    var typeGradeInv = InvAging.GetStartingInventoryByTypeAndGradeByStemMinusDumps(flower.type);
                }
                
                // Check for errors
                if(typeGradeInv[1] == 'ERROR'){
                    Throw(
                        type = 'functionError',
                        message = 'GetStartingInventoryByTypeAndGradeByStemMinusDumps',
                        detail = typeGradeInv[2]
                    );
                }else{
                    flower.startingInventoryByGrade = typeGradeInv[2];
                }
                var appendArray = ArrayAppend(startingInvAging[2], flower);
            }
            
            startingInvAging[1] = true;

            return startingInvAging;
        }catch(functionError fe){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(fe);
            writedump(fe);
            return startingInvAging;
        }catch(any e){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(e);
            writedump(e);
            return startingInvAging;
        }
    }
    
    /**
     * This will get all starting inventory broken down to grade for all Divisions and a specific flowertype
     * [GetAllStartingInventoryByDivisionTypeAndGrade description]
     * @dateStart           {date} dateStart       
     * @dateEnd             {Date} dateEnd         
     * @channelBreakout     {Boolean} channelBreakout
     * @flowerType          {string} flowerType 
     */
    public function GetGradeBreakoutForStartingInventoryByType(required dateStart, required dateEnd, required channelBreakout, required flowerType)returnFormat = 'JSON'{
        try{
        
            var startingInvAging = ArrayNew(1);
            var startingInvAging[2] = ArrayNew(1);
            
            var startingInvAgingByChannel = ArrayNew(1);
            var startingInvAgingByChannel[2] = ArrayNew(1);
            
            // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
            if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                var archived = true;
            }else{
                var archived = false;
            }
            
            // Check to see if this needs to pull from archived inventory
            if(archived){
                var typeGradeInv = InvAging.GetArchivedStartingInventoryByTypeAndGradeByStemMinusDumps(flowerType, DateFormat(dateStart, 'mm/dd/yyyy'));
            }else{
                var typeGradeInv = InvAging.GetStartingInventoryByTypeAndGradeByStemMinusDumps(flowerType);
            }
            // Check for errors
            if(typeGradeInv[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetStartingInventoryByTypeAndGradeByStemMinusDumps',
                    detail = typeGradeInv[2]
                );
            }else{
                startingInvAging[2] = typeGradeInv[2];
            }
            
            startingInvAging[1] = true;

            return startingInvAging;
        }catch(functionError fe){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(fe);
            writedump(fe);
            return startingInvAging;    
        }catch(any e){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(e);
            return startingInvAging;
        }
    }
    
    /**
     * Will get all variety grade breakouts for starting inventory 
     * @dateStart             {date} dateStart 
     * @dateEnd               {date} dateEnd 
     * @channelBreakout       {boolean} channelBreakout [If true will breakout starting inventory by channel]
    */
    public function GetAllStartingInventoryByDivisionTypeVariertyAndGrade(required dateStart, required dateEnd, required channelBreakout, required flowerType)returnFormat = 'JSON'{
        try{
            var startingInvAging = ArrayNew(1);
            var startingInvAging[2] = ArrayNew(1);
            
            var startingInvAgingByChannel = ArrayNew(1);
            
            // Get all the flower Varieties to loop over
            if(IsDefined("dateStart") == false|| IsDefined("dateEnd")== false){
                var getTypeVar = FloAttributes.GetAllFlowerVaritiesByType(flowerType);
            }else{
                var getTypeVar = ActiveTypes.GetActiveFlowerVarieties(DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'), flowerType);
            }
            // check for error's
            if(getTypeVar[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveFlowerVarieties',
                    detail = typeGradeInv[2]
                );
            }
            
            // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
            if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                var archived = true;
            }else{
                var archived = false;
            }
            
            // Loop over all varieties 
            for(flower in getTypeVar[2]){
                if(archived){
                    var typeVarGradeInv = InvAging.GetArchiveStartingInventoryByTypeVarietyAndGradeByStemMinusDumps(flowerType, flower.variety, DateFormat(dateStart , "mm/dd/yyyy"));
                }else{
                    var typeVarGradeInv = InvAging.GetStartingInventoryByTypeVarietyAndGradeByStemMinusDumps(flowerType, flower.variety);
                }
                // Check for errors
                if(typeVarGradeInv[1] == 'ERROR'){
                    Throw(
                        type = 'functionError',
                        message = 'GetStartingInventoryByTypeVarietyAndGradeByStemMinusDumps',
                        detail = typeVarGradeInv[2]
                    );
                }else{
                    flower.startingInventoryByGrade = typeVarGradeInv[2];
                }
                
                // Add results to return array
                var appendArray= ArrayAppend(startingInvAging[2], flower);
            }
            
            startingInvAging[1] = true;
            
            return startingInvAging;
        }catch(functionError fe){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(fe);
            writedump(fe);
            return startingInvAging; 
        }catch(any e){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(e);
            writedump(e);
            return startingInvAging;
        }
    }
    
    /**
     * Will get Stating inventory information by variety and Grade
     * @dateStart             {date} dateStart 
     * @dateEnd               {date} dateEnd 
     * @channelBreakout       {boolean} channelBreakout [If true will breakout ]
     * @flowerType             {string} flowerType [description]
     * @flowerVariety            {string} flowerVariety [description]
    */
    public function GetGradeBreakoutForStartingInventoryByTypeAndVariety(required dateStart, required dateEnd, required channelBreakout, required flowerType, required flowerVariety) returnFormat = 'JSON'{
        try{
            // Store base information
            var startingInvAging = ArrayNew(1);
            startingInvAging[2] = ArrayNew(1);
            
            // Store inv by channel
            var startingInvAgingByChannel = ArrayNew(1);
            
            // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
            if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                var archived = true;
            }else{
                var archived = false;
            }
            
            // Get inventory
            if(archived){
                var typeVarGradeInv = InvAging.GetArchiveStartingInventoryByTypeVarietyAndGradeByStemMinusDumps(flowerType, flowerVariety, DateFormat(dateStart, 'mm/dd/yyyy'));
            }else{
                var typeVarGradeInv = InvAging.GetStartingInventoryByTypeVarietyAndGradeByStemMinusDumps(flowerType, flowerVariety);
            }
            
            // Check for errors and if none assign to return array
            if(typeVarGradeInv[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetStartingInventoryByTypeVarietyAndGradeByStemMinusDumps',
                    detail = typeVarGradeInv[2]
                );
            }else{
                startingInvAging[2] = typeVarGradeInv[2];
            }
            
            startingInvAging[1] = true;
            
            return startingInvAging;
        }catch(functionError fe){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(fe);
            //writedump(fe);
            return startingInvAging;    
        }catch(any e){
            var startingInvAging = ArrayNew(1);
            startingInvAging[1] = 'ERROR';
            startingInvAging[2] = SerializeJSON(e);
            //writedump(e);
            return startingInvAging;
        }  
    } 
}
