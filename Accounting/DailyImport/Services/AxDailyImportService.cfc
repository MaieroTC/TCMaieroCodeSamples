/********************************************************
  Orginization Name: The Sun Valley Group, Inc.
  File Name: AxDailyImportController
  Purpose: To control all the checks needed to do the daily import
  Accessed from: 
  Author: TC Maiero
  Date: 9/23/2019
  Modifications by:
  Modified on: 
  Modification details:
  Parameters (Variables):
  Page Interactions:
********************************************************/
    
component{
    Query_to_JSON = createObject("component", "MM.component.cfc.CFQuerytoJSON");
    AxImportData = createObject("component", "MM.Accounting.DailyImport.models.AxInvoiceImport");
    
    /**
     * Will get all the information too compare needed invoice information.
     * @param       {[type]} required theDate [description]
     * @constructor
     */
    public function GetAxImportValidationData(required theDate) returnFormat = "JSON"{
        try{
            // Return Array
            var data = ArrayNew(1);
            
            // Need to create an array of structs to store all the data.
            data[2] = StructNew();
            // Create a element to return any messages that will be needed at this layer.
            data[3] = StructNew();
            data[3].messages = ArrayNew(1);
            
            theDate = DateFormat(theDate, 'mm/dd/yyyy');
            
            // Set return to true until a error is thrown
            data[1] = true;
            
            // Struct to hold validation messages
            var message = StructNew();
            
            // Get Invoice Header total
            var invoiceHeaderTotal = AxImportData.InvoiceHeaderGetTotalByDay(theDate);
            if(invoiceHeaderTotal[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'InvoiceHeaderGetTotalByDay',
                    detail = invoiceHeaderTotal[2]
                );
            }else if(!invoiceHeaderTotal[1]){
                data[1] = false;
                message.pass = false;
                message.display = 'No Invoice Header Information';
                ArrayAppend(data[3].messages, message);
            }else{
                // Start to build the struct to do all the checks on
                data[2].date = invoiceHeaderTotal[2].date;
                data[2].invoiceHeadNetTotal = invoiceHeaderTotal[2].total;
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            // Get Source type total
            var sourceTypeTotal = AxImportData.SourceTypeByInvoiceGetTotalByDay(theDate);
            if(sourceTypeTotal[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'SourceTypeByInvoiceGetTotalByDay',
                    detail = sourceTypeTotal[2]
                );
            }else if(!sourceTypeTotal[1]){
                data[1] = false;
                message.pass = false;
                message.display = 'No Invoice Source Type Data';
                ArrayAppend(data[3].messages, message);
            }else{
                data[2].sourceTypeNetTotal = sourceTypeTotal[2].total;
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            // Get invoice details totals
            var invoiceDetailTotal = AxImportData.InvoiceDetailGetTotalByDay(theDate);
            if(invoiceDetailTotal[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'InvoiceDetailGetTotalByDay',
                    detail = invoiceDetailTotal[2]
                );
            }else if(!invoiceDetailTotal[1]){
                data[1] = false;
                message.pass = false;
                message.display = 'No Invoice Detail Data';
                ArrayAppend(data[3].messages, message);
            }else{
                data[2].invoiceDetailNetTotal = invoiceDetailTotal[2].total;
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            // Get bill as total
            var billAsTotal = AxImportData.InvoiceBillAsGetTotalByDay(theDate);
            if(billAsTotal[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'InvoiceBillAsGetTotalByDay',
                    detail = billAsTotal[2]
                );
            }else if(!billAsTotal[1]){
                data[1] = false;
                message.pass = false;
                message.display = 'No Invoice Bill As Data';
                ArrayAppend(data[3].messages, message);
            }else{
                data[2].billAsNetTotal = billAsTotal[2].total;
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            // Get axapta import totals
            var axImportTotal = AxImportData.GetAxImportTotal(theDate);
            if(axImportTotal[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetAxImportTotal',
                    detail = axImportTotal[2]
                );
            }else if(!axImportTotal[1]){
                data[1] = false;
                message.pass = false;
                message.display = 'No Axapta Import Data';
                ArrayAppend(data[3].messages, message);

            }else{
                data[2].axInvoiceTotal = axImportTotal[2].total;
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            // Get diect sales totals
            var directSalesTotals = AxImportData.GetDirectSalesJournalTotals(theDate);
            if(directSalesTotals[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'GetDirectSalesJournalTotals',
                    detail = directSalesTotals[2]
                );
            }else if(!directSalesTotals[1]){
                data[1] = false;
                message.pass = false;
                message.display = 'No Direct Sales Data';
                ArrayAppend(data[3].messages, message);
            }else{
                // compare net total to all other net totals in struct
                // compare invoice total to axInvoiceTotal(invoice total = taxTotal + netTotal)
                data[2].invoiceTotal = directSalesTotals[2].invoiceTotal;
                data[2].netTotal = directSalesTotals[2].netTotal;
                data[2].taxTotal = directSalesTotals[2].taxTotal;
            }
            
            // Validate data if all necessary data is there
            if(data[1]){
                data = THIS.ValidateAxImport(data);
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
     * ValidateAxImport
     * @theData       {Object - Struct} required - The data that is returned from the function GetAxImportValidationDataController.
     *                                             This will return a true or false for each validation point with a corresponding message 
     *                                             to inform the user what aspect was not validated.
     */
    public function ValidateAxImport(required theData) returnFormat = "JSON"{
        try{
            // Struct to hold validation messages
            var message = StructNew();
            
            // Compare all the Invoice Header, Bill As, Source Type and Detail numbers
            var invoiceNetCompare = Compare(theData[2].invoiceHeadNetTotal, theData[2].sourceTypeNetTotal);
            if(invoiceNetCompare == 0){
                message.pass = true;
                message.display = 'Invoice head and source type match';
                ArrayAppend(theData[3].messages, message);
            }else{
                theData[1] = false;
                message.pass = false;
                message.display = 'Invoice head and source type do not match';
                ArrayAppend(theData[3].messages, message);
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            invoiceNetCompare = Compare(theData[2].invoiceHeadNetTotal, theData[2].invoiceDetailNetTotal);
            if(invoiceNetCompare == 0){
                message.pass = true;
                message.display = 'Invoice head and detail match';
                ArrayAppend(theData[3].messages, message);
            }else{
                theData[1] = false;
                message.pass = false;
                message.display = 'Invoice head and detail do not match';
                ArrayAppend(theData[3].messages, message);
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            invoiceNetCompare = Compare(theData[2].invoiceHeadNetTotal, theData[2].billAsNetTotal);
            if(invoiceNetCompare == 0){
                message.pass = true;
                message.display = 'Invoice head and bill as match';
                ArrayAppend(theData[3].messages, message);;
            }else{
                theData[1] = false;
                message.pass = false;
                message.display = 'Invoice head and bill as do not match';
                ArrayAppend(theData[3].messages, message);
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            // Need to comapre to the direct sales net
            invoiceNetCompare = Compare(theData[2].invoiceHeadNetTotal, theData[2].netTotal);
            if(invoiceNetCompare == 0){
                message.pass = true;
                message.display = 'Invoice head and diect sales match';
                ArrayAppend(theData[3].messages, message);
            }else{
                theData[1] = false;
                message.pass = false;
                message.display = 'Invoice head and direct sales do not match';
                ArrayAppend(theData[3].messages, message);
            }
            
            // Need to redfine temp struct
            message = StructNew();
            
            // Need to comapre the actual totals including Tax
            var invoiceTotalCompare = Compare(theData[2].axInvoiceTotal, theData[2].invoiceTotal);
            if(invoiceTotalCompare == 0){
                message.pass = true;
                message.display = 'Invoice Axpata import total and direct sales match';
                ArrayAppend(theData[3].messages, message);
            }else{
                theData[1] = false;
                message.pass = false;
                message.display = 'Invoice Axpata import and direct sales do not match';
                ArrayAppend(theData[3].messages, message);
            }
            
            return theData;
        }catch(any e){
            theData[1] = 'ERROR';
            theData[2] = SerializeJSON(e);
            //writedump(e);
            return theData;
        } 
    }
    
    /**
     * Will get all information to import daily invoices into Axapta
     * @theDate       {date} required date to pull data for
     */
    public function GetAxImportData(required theDate, lateFees) returnFormat = "JSON"{
        try{
            var data = ArrayNew(1);
            
            data[1] = true;
            // Need to create an array of structs to store all the data.
            data[2] = ArrayNew(1);
            
            // Get DATA
            var data = AxImportData.AxImportDailySalesInfo(DateFormat(theDate, 'mm/dd/yyyy' ));
            if(data[1] == 'ERROR'){
                Throw(
                    type = 'functionError',
                    message = 'AxImportDailySalesInfo',
                    detail = data[2]
                );
            }else if(!data[1]){
                data[1] = false;
                data[2] = '[]';
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
    
    /**
     * Will filter out the Axapta import data to only show late fees
     * @param       {object} required object that will have all Axapta import information
     **/
    public function LateFeeFilter(required theData) returnFormat = "JSON"{
        try{
            var data = ArrayNew(1);
            // Need to create an array of structs to store all the data.
            data[2] = ArrayNew(1);
            
            
            // Will need to loop through and check the invoice and/or order number of each record to see if it is a late fee.  If it is will add to new array
            for(record in theData){
                if(Left(record.Invoice_Number, 1) == 'L'){
                    ArrayAppend(data[2], record);
                }
            }
            
            // Check to see there are late fees that have been added to the return array
            if(ArrayLen(data[2]) > 0){
                data[1] = true;
            }else{
                data[1] = false;
                data[2] = [];
            }
            
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
