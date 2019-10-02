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
    CustomerModel = createObject("component", "MM.Accounting.DailyImport.models.AxCustomerFunctions");
    
    /**
     * WIll call the model to pull the customer information
     * @param       {[type]} theCustomerNumber [description]
     * @constructor
     */
    public function GetAxCustomerData(required theCustomerNumber) returnFormat = "JSON"{
        try{
            var data = ArrayNew(1);
            
            // Need to create an array of structs to store all the data.
            data[2] = ArrayNew(1);
            // Create a element to return any messages that will be needed at this layer.
            data[3] = StructNew();
            
            // Check to see if the customer number is definded
            if(theCustomerNumber == ''){
                theCustomerNumber = 'ALL';
            }
            
            // Get DATA
            var customer = CustomerModel.AxCustomerImportInformation(theCustomerNumber);
            if(customer[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'AxCustomerImportInformation',
                    detail = customer[2]
                );
            }else if(!customer[1]){
                data[1] = false;
                data[2] = [];
                data[3].messages = 'No Customer Information';
            }else{
                data[1] = true;
                data[2] = customer[2];
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
    
}
