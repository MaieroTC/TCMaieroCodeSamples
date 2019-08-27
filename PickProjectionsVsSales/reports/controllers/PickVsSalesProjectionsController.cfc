/********************************************************
  Orginization Name: The Sun Valley Group, Inc.
  File Name: PickVsSalesProjectionsController
  Purpose: BUild the data that will be used in the PickvsSalesProjections Report
  Accessed from: 
  Author: TC Maiero
  Date:2/6/2019
  Modifications by:
  Modified on: 
  Modification details:
  Parameters (Variables):
  Page Interactions:
********************************************************/
    
component{
    Query_to_JSON = createObject("component", "MM.component.cfc.CFQuerytoJSON");
    ArrayStructSort = createObject("component","MM.component.cfc.ArrayOfStructSort");
    TransferInfo = createObject("component", "MM.TransferOrders.Reports.Controllers.InTransitByTypeSku");
    StartingInventory = createObject("component", "MM.PickProjectionsVsSales.cfc.GetStartingInventory");
    Projections = createObject("component", "MM.FarmnetCommon.Inventory.Projections.BaseProjectionFunctions");
    Locations = createObject("component", "MM.FarmnetCommon.Locations.BaseLocationFunctions");
    Error = createObject("component", "MM.FarmnetCommon.Error.cfc.ErrorFunctions");
    OrderInfo = createObject("component", "MM.FarmnetCommon.Orders.cfc.OrderItemFunctions");
    
    public function BuildPickvsSalesProjectionsData (required dateStart, required dateEnd)returnFormat = "JSON"{
        try{
            var pickVsSalesInfo = ArrayNew(1);
            var pickVsSalesInfo[1] = true;
            
            // Get all the flower types we will need to check
            var startingInventory = StartingInventory.GetStartingInventoryByDivisionByType(DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'), true);
            if(startingInventory[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetAllFlowerTypes',
                    detail = startingInventory[2]
                );
            }
            
            // ************** Debug ***************
            //writeDump(startingInventory);
            // ************** End Debug **********
            
            pickVsSalesInfo[2] = startingInventory[2];
            
            // ************* Debug ***************
            //writedump(pickVsSalesInfo[2]);
            // ************** End Debug **********
            
            // Get Transfer Order Data.  Will need to format this based on the loop above.
            var transferOrders = TransferInfo.IntransitByTypeInDateRangeByDeliveryDate(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), false);
            if(transferOrders[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'transferOrders',
                    detail = transferOrders[2]
                );
            }
            
            // TCM - needs to set the Array in the second element of an array to a stucture so I can use coldfusion's search function on the 
            // Structure.
            var transferOrderStructure = StructNew();
            transferOrderStructure.data = transferOrders[2];
            
            var getDivisionList = Locations.GetDistinctDivisions();
            if(getDivisionList[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetDistinctDivisions',
                    detail = getDivisionList[2]
                );
            }
            
            // Get Sales(Guess and Actual) and Pick Projections.  Need to loop through the flower types in the starting inventory result
            for(flower in pickVsSalesInfo[2]){
                var getPickProjections = Projections.GetPickProjectionsByDateRangeAndFlowerTypeByDay(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flower.type);
                var flower.pickProjections = StructNew();
                flower.pickProjections = getPickProjections[2];
                
                var getSalesProjections = Projections.GetSaleProjectionsByDateRangeAndFlowerTypeByDay(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flower.type, false);
                var flower.salesProjections = StructNew();
                flower.salesProjections = getSalesProjections[2];
                
                var getGuessSalesProjections = Projections.GetSaleProjectionsByDateRangeAndFlowerTypeByDay(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flower.type, true);
                var flower.guessSaleProjections = StructNew();
                flower.guessSaleProjections = getGuessSalesProjections[2];
                
                // TCM - Format transfer order info
                var getTransferOrders = THIS.FormatIntransitDataForPickvsSales(transferOrderStructure, flower.type, dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), getDivisionList[2]);
                var flower.inTransitProjections = StructNew();
                flower.inTransitProjections = getTransferOrders[2].inTransit;
            }
            
            //WriteDump(pickVsSalesInfo[2]);
            
            return pickVsSalesInfo;
            
        }catch(functionError fe){
            var pickVsSalesInfo = ArrayNew(1);
            pickVsSalesInfo[1] = 'ERROR';
            pickVsSalesInfo[2] = SerializeJSON(fe);
            //error = ErrorFunctions.SendErrorEmail(fe.detail, fe.message);
            //writedump(fe);
            return pickVsSalesInfo;
        }catch(any e){
            var pickVsSalesInfo = ArrayNew(1);
            pickVsSalesInfo[1] = 'ERROR';
            pickVsSalesInfo[2] = SerializeJSON(e);
            //writedump(e);
            //error = ErrorFunctions.SendErrorEmail(fe.detail, fe.message);
            return pickVsSalesInfo;
        }          
    }
    
    /** Will Get all Projection info for the varieties and build the stuct that will contain color info as well
    * @dateStart        {date} dateStart 
    * @dateEnd          {date} dateEnd 
    * @flowerType       {String} flowerType 
    */
    remote function BuildPickvsSalesProjectionsVarietyData(required dateStart, required dateEnd, required flowerType)returnFormat = 'JSON'{
        try{
            var pickVsSalesVarietyInfo = ArrayNew(1);
            var pickVsSalesVarietyInfo[1] = true;
            
            // Get all the flower varieties we will need to check
            var startingInventory = StartingInventory.GetStartingInventoryByDivisionVariety(flowerType, DateFormat(dateStart, 'mm/dd/yyyy'), DateFormat(dateEnd, 'mm/dd/yyyy'));
            if(startingInventory[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetStartingInventoryByDivisionVariety',
                    detail = startingInventory[2]
                );
            }
            
            //writedump(startingInventory);
            
            // *************************Need to add a no info check
            
            pickVsSalesVarietyInfo[2] = startingInventory[2];
            
            
            // Get Transfer Order Data.  Will need to format this based on the loop above.
            var transferOrders = TransferInfo.IntransitByTypeInDateRangeByDeliveryDate(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), false);
            if(transferOrders[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'transferOrders',
                    detail = transferOrders[2]
                );
            }
            
            // TCM - needs to set the Array in the second element of an array to a stucture so I can use coldfusion's search function on the 
            // Structure.
            var transferOrderStructure = StructNew();
            transferOrderStructure.data = transferOrders[2];
            
            var getDivisionList = Locations.GetDistinctDivisions();
            if(getDivisionList[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetDistinctDivisions',
                    detail = getDivisionList[2]
                );
            }
            
            for(flower in pickVsSalesVarietyInfo[2]){
                // Get Pick Projections
                var getPickProjections = Projections.GetPickProjectionsByDateRangeAndFlowerVarietyByDay(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flowerType, flower.variety);
                var flower.pickProjections = StructNew();
                flower.pickProjections = getPickProjections[2];
                
                // get sales projections
                var getSalesProjections = Projections.GetSaleProjectionsByDateRangeAndFlowerVarietyByDay(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flowerType, flower.variety, false);
                var flower.salesProjections = StructNew();
                flower.salesProjections = getSalesProjections[2];
                
                // Get Guess Sales Projections
                var getGuessSalesProjections = Projections.GetSaleProjectionsByDateRangeAndFlowerVarietyByDay(dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), flowerType, flower.variety, true);
                var flower.guessSaleProjections = StructNew();
                flower.guessSaleProjections = getGuessSalesProjections[2];
                
                var getTransferOrders = THIS.FormatIntransitDataForPickvsSalesVariety(transferOrderStructure, flower.type, flower.variety, dateformat(dateStart, 'mm/dd/yyyy'), dateformat(dateEnd, 'mm/dd/yyyy'), getDivisionList[2]);
                var flower.inTransitProjections = StructNew();
                flower.inTransitProjections = getTransferOrders[2].inTransit;
            }
            
            pickVsSalesVarietyInfo[2] = ArrayStructSort.ArrayOfStructsSort(pickVsSalesVarietyInfo[2], 'colorcode');
            
            return pickVsSalesVarietyInfo;
            
        }catch(functionError fe){
            var pickVsSalesVarietyInfo = ArrayNew(1);
            pickVsSalesVarietyInfo[1] = 'ERROR';
            pickVsSalesVarietyInfo[2] = SerializeJSON(fe);
            //writedump(fe);
            return pickVsSalesVarietyInfo;
        }catch(any e){
            var pickVsSalesVarietyInfo = ArrayNew(1);
            pickVsSalesVarietyInfo[1] = 'ERROR';
            pickVsSalesVarietyInfo[2] = SerializeJSON(e);
            //writedump(e);
            return pickVsSalesVarietyInfo;
        }
    }
    
    remote function BuildPickvsSalesProjectionsOrderData(required orderDate, required division, required flowerType, required excludeTransferOrders)returnFormat = 'JSON'{
        try{
            var orders = ArrayNew(1);
            
            var getOrders = OrderInfo.GetOrdersStemsByDayTypeDivision(orderDate, flowerType, division, excludeTransferOrders);
            if(getOrders[1] == "ERROR"){
                Throw(
                    type = 'functionError',
                    message = 'GetOrdersStemsByDayTypeDivision',
                    detail = getOrders[2]
                );
            }
            
            orders = getOrders;
            
            return orders;
        }catch(functionError fe){
            var orders = ArrayNew(1);
            orders[1] = 'ERROR';
            orders[2] = SerializeJSON(fe);
            return orders;
        }catch(any e){
            var orders = ArrayNew(1);
            orders[1] = 'ERROR';
            orders[2] = SerializeJSON(e);
            return orders;
        }
    }
    
    // TCM -  to make the table creation easier I am going to format the data from the intrasnit orders based format of the rest of the data.
    // inTransitData is the element in the second eleemnt of the array returned by IntransitByTypeInDateRangeByDeliveryDate.
    public function FormatIntransitDataForPickvsSales (required inTransitDataStructure, required flowerType, required dateStart, required dateEnd, required divisionList) returnFormat = "JSON"{
        try{
            var formattedIntransit = ArrayNew(1);
            
            // TCM - Check if struct is empty
            var noTransitOrders = StructIsEmpty(inTransitDataStructure);
            
            var inTransitOrders = StructNew();
            var inTransitOrders.inTransit = ArrayNew(1);
                
            //  TCM - If the struct is empty we still need to fill out the fields with 0 Data
            if(noTransitOrders == false){
                var matchingTypes = StructFindValue(inTransitDataStructure, flowerType, 'all');
                //writedump(matchingTypes);
                
                // Need to loop over the desired divisionList
                for(division in divisionList){
                    for(date=dateStart; dateCompare(date, dateEnd, "d") <= 0; date=dateAdd("d", 1, date)){
                        inTransitData = StructNew();
                        inTransitData.DateKey = DateFormat(date, "mm/dd/yyyy");
                        inTransitData.DisplayDate = DateFormat(date, "mm/dd/yyyy");
                        inTransitData.flowerType = flowerType;
                        inTransitData.division = division;
                        if(ArrayIsEmpty(matchingTypes) == false){
                            inTransitData.totalProjectedStems = 0;
                            for(matches in matchingTypes){
                                if(matches.owner.destinationDivision == division && DateFormat(matches.owner.displayDate, "mm/dd/yyyy") == DateFormat(date, "mm/dd/yyyy")){
                                    inTransitData.totalProjectedStems = inTransitData.totalProjectedStems + matches.owner.totalStems;
                                }else{
                                    inTransitData.totalProjectedStems = 0;
                                }
                            }
                        }else{
                            inTransitData.totalProjectedStems = 0;
                        }
                        
                        var append = ArrayAppend(inTransitOrders.inTransit, inTransitData);
                    }
                }
                formattedIntransit[1] = true;
                formmattedInTransit[2] = inTransitOrders;
            }else{
                formmattedInTransit[1] = false;
                formmattedInTransit[2] = '[]';
            }
            
            return formmattedInTransit;
        }catch(any e){
            var formattedIntransit = ArrayNew(1);
            formattedIntransit[1] = 'ERROR';
            formattedIntransit[2] = SerializeJSON(e);
            return formattedIntransit;
        }
    }
    
    public function FormatIntransitDataForPickvsSalesVariety(required inTransitDataStructure, required flowerType, required flowerVariety, required dateStart, required dateEnd, required divisionList)returnFormat = "JSON"{
        try{
            var formattedIntransit = ArrayNew(1);
            
            // Check if there are no in transit orders
            var noTransitOrders = StructIsEmpty(inTransitDataStructure);
            
            var inTransitOrders = StructNew();
            var inTransitOrders.inTransit = ArrayNew(1);
            
            if(noTransitOrders == false){
                var matchingTypeVariety = StructFindValue(inTransitDataStructure, flowerType&flowerVariety, 'all');
                
                // Need to loop over the desired divisionList
                for(division in divisionList){
                    for(date=dateStart; dateCompare(date, dateEnd, "d") <= 0; date=dateAdd("d", 1, date)){
                        inTransitData = StructNew();
                        inTransitData.DateKey = DateFormat(date, "mm/dd/yyyy");
                        inTransitData.DisplayDate = DateFormat(date, "mm/dd/yyyy");
                        inTransitData.flowerType = flowerType;
                        inTransitData.flowerVariety = flowerVariety;
                        inTransitData.division = division;
                        if(ArrayIsEmpty(matchingTypeVariety) == false){
                            inTransitData.totalProjectedStems = 0;
                            for(matches in matchingTypeVariety){
                                if(matches.owner.destinationDivision == division && DateFormat(matches.owner.displayDate, "mm/dd/yyyy") == DateFormat(date, "mm/dd/yyyy")){
                                    inTransitData.totalProjectedStems = inTransitData.totalProjectedStems + matches.owner.totalStems;
                                }else{
                                    inTransitData.totalProjectedStems = 0;
                                }
                            }
                        }else{
                            inTransitData.totalProjectedStems = 0;
                        }
                        
                        var append = ArrayAppend(inTransitOrders.inTransit, inTransitData);
                    }
                }
                formattedIntransit[1] = true;
                formmattedInTransit[2] = inTransitOrders;
            }else{
                formmattedInTransit[1] = false;
                formmattedInTransit[2] = '[]';
            }

            return formmattedInTransit;
        }catch(any e){
            var formattedIntransit = ArrayNew(1);
            formattedIntransit[1] = 'ERROR';
            formattedIntransit[2] = SerializeJSON(e);
            return formattedIntransit;
        }
    }
}
