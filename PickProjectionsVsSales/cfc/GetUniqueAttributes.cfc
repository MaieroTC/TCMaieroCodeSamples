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
    FloAttributes = createObject("component", "MM.FarmnetCommon.Attributes.BaseFlowerTypeFunctions");
    SortArrayOfStruct = createObject("component", "MM.component.cfc.ArrayOfStructSort");
    
    public function GetActiveFlowerTypes(required dateStart, required dateEnd)returnFormat = "JSON"{
        try{
            var flowerTypes = ArrayNew(1);
            
            // Get Active Types from InventoryAging
            // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
            if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                var inventoryAgingFlowerTypes = FloAttributes.GetActiveFlowerTypesFromInventoryAgingArchive(dateStart);
                if(inventoryAgingFlowerTypes[1] == 'ERROR'){
                    Throw(
                        type = 'functionError',
                        message = 'GetActiveFlowerTypesFromInventoryAging',
                        detail = inventoryAgingFlowerTypes[2]
                    );
                }
            }else{
                var inventoryAgingFlowerTypes = FloAttributes.GetActiveFlowerTypesFromInventoryAging();
                if(inventoryAgingFlowerTypes[1] == 'ERROR'){
                    Throw(
                        type = 'functionError',
                        message = 'GetActiveFlowerTypesFromInventoryAging',
                        detail = inventoryAgingFlowerTypes[2]
                    );
                }
            }
            
            
            
            // Get Active FlowerTypes from Projections
            var projectionFlowerTypes = FloAttributes.GetActiveFlowerTypesFromProjectionsBasedonDateRange(DateFormat(dateStart , "mm/dd/yyyy"),DateFormat(dateEnd , "mm/dd/yyyy"));
            if(projectionFlowerTypes[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveFlowerTypesFromProjectionsBasedonDateRange',
                    detail = projectionFlowerTypes[2]
                );
            }
            
            // Get sales flower types
            var salesFlowerTypes = FloAttributes.GetActiveFlowerTypesBasedOnSales(DateFormat(dateStart , "mm/dd/yyyy"),DateFormat(dateEnd , "mm/dd/yyyy"));
            if(projectionFlowerTypes[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveFlowerTypesFromProjectionsBasedonDateRange',
                    detail = projectionFlowerTypes[2]
                );
            }
            
            // Need to get Unique In Transit Flower Types
            var inTransitFlowerTypes = FloAttributes.GetActiveInTransitItemsByDataRange(DateFormat(dateStart , "mm/dd/yyyy"),DateFormat(dateEnd , "mm/dd/yyyy"), false);
            if(inTransitFlowerTypes[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveInTransitItemsByDataRange',
                    detail = inTransitFlowerTypes[2]
                );
            }
            
            // Need to turn convert the data results from the second element of the array into structs to be able to use the struct find info
            var typeDriver = StructNew();
            if(inventoryAgingFlowerTypes[1] != false && inventoryAgingFlowerTypes[1] != 'ERROR'){
                typeDriver.types = inventoryAgingFlowerTypes[2];
            }
            
            // Will need to loop over eacg inventory and append any types that do not exist in the typeDriver Structure
            // Inventory Aging First
            if(salesFlowerTypes[1] != false && salesFlowerTypes[1] != 'ERROR'){
                for(uniqueType in salesFlowerTypes[2]){
                    var search = StructFindValue(typeDriver, uniquetype.type);
                    // Check to see if the size of the search array is 0.  If it is we need to add that element to the typeDriver Structure
                    if(ArrayIsEmpty(search)){
                        var append = ArrayAppend(typeDriver.types, uniqueType);
                    }
                }
            }
            
             
            // Loop through projections
            if(projectionFlowerTypes[1] != false && projectionFlowerTypes[1] != 'ERROR'){
                for(uniqueType in projectionFlowerTypes[2]){
                    search =  StructFindValue(typeDriver, uniquetype.type);
                    // Check to see if the size of the search array is 0.  If it is we need to add that element to the typeDriver Structure
                    if(ArrayIsEmpty(search)){
                        var append = ArrayAppend(typeDriver.types, uniqueType);
                    }
                } 
            }
            
            // Loop through In Transit.  This will need to be handled differently because In tansit is based on a order Id and not sku dump
            if(inTransitFlowerTypes[1] != false && inTransitFlowerTypes[1] != 'ERROR'){
                for(uniqueType in inTransitFlowerTypes[2]){
                    search =  StructFindValue(typeDriver, uniquetype.itemType);
                    if(ArrayIsEmpty(search)){
                        // Need to translate the Struct info to match the 
                        var tempStruct = StructNew();
                        tempStruct.Description = uniqueType.TypeName;
                        tempStruct.Type = uniqueType.itemType;
                        tempStruct.TypeShortCode = uniqueType.TypeShortCode;
                        tempStruct.vCategory = uniqueType.vCategory;
                
                        var append = ArrayAppend(typeDriver.types, tempStruct);
                    }
                }
            }
            
            typeDriver.types =  SortArrayOfStruct.ArrayOfStructsSort(typeDriver.types, 'Type');
            
            flowerTypes[1] = true;
            flowerTypes[2] = typeDriver.types;
            
            return flowerTypes;
        }catch(functionError fe){
            var flowerTypes = ArrayNew(1);
            flowerTypes[1] = 'ERROR';
            flowerTypes[2] = SerializeJSON(fe);
            //writedump(fe);
            return flowerTypes;
        }catch(any e){
            var flowerTypes = ArrayNew(1);
            flowerTypes[1] = 'ERROR';
            flowerTypes[2] = SerializeJSON(e);
            //writedump(e);
            return flowerTypes;
        }
          
    }
    
    public function GetActiveFlowerVarieties(required dateStart, required dateEnd, required flowerType)returnFormat = "JSON"{
        try{
            var flowerVarieties = ArrayNew(1);
            
            // Get Varieties from inventory aging
            // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
            if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                var inventoryAgingFlowerVarieties = FloAttributes.GetActiveVarietiesFromInventoryAgingArchiveByType(flowerType, dateStart);
            }else{
                var inventoryAgingFlowerVarieties = FloAttributes.GetActiveVarietiesFromInventoryAgingByType(flowerType);
            }
            
            if(inventoryAgingFlowerVarieties[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveVarietiesFromInventoryAgingByType',
                    detail = inventoryAgingFlowerVarieties[2]
                );
            }
            //writedump(inventoryAgingFlowerVarieties);
            
            var projectionFlowerVarieties = FloAttributes.GetActiveProjectionVarietiesByTypeAndDateRange(dateFormat(dateStart, 'mm/dd/yyyy'), dateFormat(dateEnd, 'mm/dd/yyyy'), flowerType);
            if(projectionFlowerVarieties[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveProjectionVarietiesByTypeAndDateRange',
                    detail = projectionFlowerVarieties[2]
                );
            }
            //writedump(projectionFlowerVarieties);
            
            var salesFlowerVarieties = FloAttributes.GetActiveSkuDumpVarietiesByTypeAndDateRange(dateFormat(dateStart, 'mm/dd/yyyy'), dateFormat(dateEnd, 'mm/dd/yyyy'), flowerType);
            if(salesFlowerVarieties[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveSkuDumpVarietiesByTypeAndDateRange',
                    detail = salesFlowerVarieties[2]
                );
            }
            //writedump(salesFlowerVarieties);
            
            // Need to get Unique In Transit Flower Types
            var inTransitFlowerInfo = FloAttributes.GetActiveInTransitItemsByDataRange(DateFormat(dateStart , "mm/dd/yyyy"),DateFormat(dateEnd , "mm/dd/yyyy"), false);
            if(inTransitFlowerInfo[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveInTransitItemsByDataRange',
                    detail = inTransitFlowerInfo[2]
                );
            }
            //writedump(inTransitFlowerInfo);
            
            // Need to turn convert the data results from the second element of the array into structs to be able to use the struct find info
            var varietyDriver = StructNew();
            if(inventoryAgingFlowerVarieties[1] != false && inventoryAgingFlowerVarieties[1] != 'ERROR'){
                varietyDriver.varieties = inventoryAgingFlowerVarieties[2];
            }
            
            // Will need to loop over eacg inventory and append any types that do not exist in the typeDriver Structure
            if(salesFlowerVarieties[1] != false && salesFlowerVarieties[1] != 'ERROR'){
                for(uniqueVariety in salesFlowerVarieties[2]){
                    var search = StructFindValue(varietyDriver, uniqueVariety.TypeVariety);
                    // Check to see if the size of the search array is 0.  If it is we need to add that element to the typeDriver Structure
                    if(ArrayIsEmpty(search)){
                        var append = ArrayAppend(varietyDriver.varieties, uniqueVariety);
                    }
                }
            }
            
            
            // Loop through projections
            if(projectionFlowerVarieties[1] != false && projectionFlowerVarieties[1] != 'ERROR'){
                for(uniqueVariety in salesFlowerVarieties[2]){
                    var search = StructFindValue(varietyDriver, uniqueVariety.TypeVariety);
                    // Check to see if the size of the search array is 0.  If it is we need to add that element to the typeDriver Structure
                    if(ArrayIsEmpty(search)){
                        var append = ArrayAppend(varietyDriver.varieties, uniqueVariety);
                    }
                }
            }
            
            //writedump(varietyDriver);
            
            // Loop through In Transit.  This will need to be handled differently because In tansit is based on a order Id and not sku dump
            if(inTransitFlowerInfo[1] != false && inTransitFlowerInfo[1] != 'ERROR'){
                for(uniqueInfo in inTransitFlowerInfo[2]){
                    if(uniqueInfo.itemType == flowerType){
                        search =  StructFindValue(varietyDriver, uniqueInfo.TYPEVARIETYCOMBO);
                        if(ArrayIsEmpty(search)){
                            // Need to translate the Struct info to match the 
                            var tempStruct = StructNew();
                            tempStruct.Variety_Name = uniqueInfo.VarietyName;
                            tempStruct.Type = uniqueInfo.itemType;
                            tempStruct.Variety= uniqueInfo.itemVariety;
                            tempStruct.typeVariety= uniqueInfo.TYPEVARIETYCOMBO;
                            tempStruct.Short_Name = uniqueInfo.Short_Name;
                            tempStruct.Color_Description = uniqueInfo.color_Description;
                            tempStruct.ColorCode = uniqueInfo.colorcode;
                
                            var append = ArrayAppend(varietyDriver.varieties, tempStruct);
                        }
                    }
                }
            }
            
            varietyDriver.varieties =  SortArrayOfStruct.ArrayOfStructsSort(varietyDriver.varieties, 'Variety');
            
            flowerVarieties[1] = true;
            flowerVarieties[2] = varietyDriver.varieties;
            
            
            return flowerVarieties;
        }catch(functionError fe){
            var flowerVarieties = ArrayNew(1);
            flowerVarieties[1] = 'ERROR';
            flowerVarieties[2] = SerializeJSON(fe);
            //writedump(fe);
            return flowerVarieties;
        }catch(any e){
            var flowerVarieties = ArrayNew(1);
            flowerVarieties[1] = 'ERROR';
            flowerVarieties[2] = SerializeJSON(e);
            //writedump(e);
            return flowerVarieties;
        }
    }
    
    /**
     * Will get all active varieties based on a date range and Type that has the corresponding color code 
     * @dateStart       {date} required [description]
     * @dateEnd       {date} required [description]
     * @flowerType       {string} required [description]
     * @colorCode       {string} required [description]
     * @constructor
     */
    public function GetActiveFlowerVarietiesByColor(required dateStart, required dateEnd, required flowerType, required colorCode) returnFormat = "JSON"{
        try{
            var flowerVarieties = ArrayNew(1);
            
            // Get Varieties from inventory aging
            // if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(now(), "mm/dd/yyyy")) == -1){
            if(DateCompare(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat('8/13/2019', "mm/dd/yyyy")) == -1){
                var inventoryAgingFlowerVarieties = FloAttributes.GetActiveVarietiesFromInvAgingArchiveByTypeAndColor(DateFormat(dateStart , "mm/dd/yyyy"), flowerType, colorCode);
            }else{
                var inventoryAgingFlowerVarieties = FloAttributes.GetActiveVarietiesFromInvAgingByTypeAndColor(flowerType, colorCode);
            }
            // Check to see everything went ok
            if(inventoryAgingFlowerVarieties[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveVarietiesFromInvAgingByTypeAndColor',
                    detail = inventoryAgingFlowerVarieties[2]
                );
            }
            
            // GetVarieities from pick projections
            var projectionFlowerVarieties = FloAttributes.GetActivePickProjectionsByTypeColorAndDateRange(dateFormat(dateStart, 'mm/dd/yyyy'), dateFormat(dateEnd, 'mm/dd/yyyy'), flowerType, colorCode);
            if(projectionFlowerVarieties[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActivePickProjectionsByTypeColorAndDateRange',
                    detail = projectionFlowerVarieties[2]
                );
            }
        
            // Get Varities from sales projections
            var salesFlowerVarieties = FloAttributes.GetActiveVaritiesFromSalesByTypeColorAndDateRange(DateFormat(dateStart , "mm/dd/yyyy"), DateFormat(dateEnd , "mm/dd/yyyy"), flowerType, colorcode);
            if(salesFlowerVarieties[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetActiveVaritiesFromSalesByTypeColorAndDateRange',
                    detail = salesFlowerVarieties[2]
                );
            }
            
            
            // Need to turn convert the data results from the second element of the array into structs to be able to use the struct find info
            var varietyDriver = StructNew();
            if(inventoryAgingFlowerVarieties[1] != false && inventoryAgingFlowerVarieties[1] != 'ERROR'){
                varietyDriver.varieties = inventoryAgingFlowerVarieties[2];
            }
            
            // Will need to loop over eacg inventory and append any types that do not exist in the typeDriver Structure
            if(salesFlowerVarieties[1] != false && salesFlowerVarieties[1] != 'ERROR'){
                for(uniqueVariety in salesFlowerVarieties[2]){
                    var search = StructFindValue(varietyDriver, uniqueVariety.TypeVariety);
                    // Check to see if the size of the search array is 0.  If it is we need to add that element to the typeDriver Structure
                    if(ArrayIsEmpty(search)){
                        var append = ArrayAppend(varietyDriver.varieties, uniqueVariety);
                    }
                }
            }
            
            
            // Loop through projections
            if(projectionFlowerVarieties[1] != false && projectionFlowerVarieties[1] != 'ERROR'){
                for(uniqueVariety in salesFlowerVarieties[2]){
                    var search = StructFindValue(varietyDriver, uniqueVariety.TypeVariety);
                    // Check to see if the size of the search array is 0.  If it is we need to add that element to the typeDriver Structure
                    if(ArrayIsEmpty(search)){
                        var append = ArrayAppend(varietyDriver.varieties, uniqueVariety);
                    }
                }
            }
            
            varietyDriver.varieties =  SortArrayOfStruct.ArrayOfStructsSort(varietyDriver.varieties, 'Variety');
            
            flowerVarieties[1] = true;
            flowerVarieties[2] = varietyDriver.varieties;
            
            return flowerVarieties; 
        }catch(functionError fe){
            var flowerVarieties = ArrayNew(1);
            flowerVarieties[1] = 'ERROR';
            flowerVarieties[2] = SerializeJSON(fe);
            writedump(fe);
            return flowerVarieties; 
        }catch(any e){
            var flowerVarieties = ArrayNew(1);
            flowerVarieties[1] = 'ERROR';
            flowerVarieties[2] = SerializeJSON(e);
            writedump(e);
            return flowerVarieties;
        }      
    }
    
}
