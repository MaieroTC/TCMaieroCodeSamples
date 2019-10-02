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
    AxInvoiceImportService = createObject("component", "MM.Accounting.DailyImport.Services.AxDailyImportService");
    AxCustomerImportService = createObject("component", "MM.Accounting.DailyImport.Services.AxCustomerImportService");
    
    /**
     * Validation Controller
     * @theDate       {date} required [description]
     */
    public function ValidateAxInvoiceInfo(required theDate)returnFormat = "JSON"{
        try{
            var data = ArrayNew(1);
            
            // Get DATA
            var data = AxInvoiceImportService.GetAxImportValidationData(theDate);
            if(data[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetAxImportValidationData',
                    detail = data[2]
                );
            }
            
            return data;
        }catch(functionError fe){
            var data = ArrayNew(1);
            data[1] = 'ERROR';
            data[2] = SerializeJSON(fe);
            writedump(fe);
            return data; 
        }catch(any e){
            var data = ArrayNew(1);
            data[1] = 'ERROR';
            data[2] = SerializeJSON(e);
            writedump(e);
            return data;
        } 
    }
    
    /**
     * [GetAxInvoiceImportInfo description]
     * @theDate       {date} required    date to pull data
     * @lateFees      {bool} optional, if defined and set to true will only pull late fees
     */
    public function GetAxInvoiceImportInfo(required theDate, lateFeeOnly) returnFormat = "JSON"{
        try{
            var data = ArrayNew(1);
    
            // Get DATA
            var data = AxInvoiceImportService.GetAxImportData(theDate);
            if(data[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = '_FUNCTION_',
                    detail = data[2]
                );
            }
            
            // Check to see if late fees are defined    
            if(IsDefined('lateFeeOnly')){
                // if late fees equals true will need to only pull out late fees
                if(lateFeeOnly){
                    data = AxInvoiceImportService.LateFeeFilter(data[2]);
                }
            }
            
            return data;
        }catch(functionError fe){
            var data = ArrayNew(1);
            data[1] = 'ERROR';
            data[2] = SerializeJSON(fe);
            //writedump(fe);
            return data; 
        }catch(any e){
            var data = ArrayNew(1);
            data[1] = 'ERROR';
            data[2] = SerializeJSON(e);
            //writedump(e);
            return data;
        } 
    }
    
    /**
     * Will get all customer import info
     * @theCustomerNumber       {string} optional Customer Number
     */
    public function GetAxCustomerImportInfo(required theCustomerNumber) returnFormat = "JSON"{
        try{
            var data = ArrayNew(1);
            
            // Get DATA
            var data = AxCustomerImportService.GetAxCustomerData(theCustomerNumber);
            if(data[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = '_FUNCTION_',
                    detail = data[2]
                );
            }
            
            return data;
        }catch(functionError fe){
            var data = ArrayNew(1);
            data[1] = 'ERROR';
            data[2] = SerializeJSON(fe);
            // writedump(fe);
            return data; 
        }catch(any e){
            var data = ArrayNew(1);
            data[1] = 'ERROR';
            data[2] = SerializeJSON(e);
            // writedump(e);
            return data;
        } 
    }
    
}
