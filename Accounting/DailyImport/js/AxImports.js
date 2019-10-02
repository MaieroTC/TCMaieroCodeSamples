/****************************************************************************************
*	Orginization: The Sun Valley Group                                                  
* 	File Name: AxImport.js                                                 
*  	Purpose: Store the Javascript to run the Accounting import page                                 
*   Created At: 9/26/2019                                                             
*   Created by: TC Maiero                                                               
*   Modified At:                                                                        
*   Modified By:                                                                        
****************************************************************************************/

// Custome function to sum columns in a data table
jQuery.fn.dataTable.Api.register( 'sum()', function ( ) {
    return this.flatten().reduce( function ( a, b ) {
        if ( typeof a === 'string' ) {
            a = a.replace(/[^\d.-]/g, '') * 1;
        }
        if ( typeof b === 'string' ) {
            b = b.replace(/[^\d.-]/g, '') * 1;
        }
 
        return a + b;
    }, 0 );
} );

$(document).ready(function(){
    // Invoice Import tools
    $(".validate-axImport").on('click', function(){
        // Get the date value
        var aDate = moment($(".import-date").val()).format("L");
        // Make sure input is a valid date and if not message the user and stop action
        if(!moment(aDate).isValid()){
            alert("Please Enter a valid Date");
            return;
        }
        
        // Remove Customer Table
        $('#axCustomerImport').remove();
        $('#customer-import-data').html('<table id = "axCustomerImport" class = "display" width = "100%">');
        
        // Need to start to validate the information.
        ValdidateAxImportInfo(aDate);
    });
    
    
    // Customer Import Tools
    $(".get-customer-info").on('click', function(){
        var aCustomerNumber = $("#theCustomerNumber").val();
        if(aCustomerNumber == ''){
            alert("Please Enter a customer number");
            return;
        }
        
        CreateAxCustomerImportDataTable(aCustomerNumber);
    });    
});

/**
 * Will Validate the information and display to screen the correct message.
 * @param       {date} aDate date should be validated before.
 * @constructor
 */
function ValdidateAxImportInfo(aDate){
    $.ajax({
        type:"POST",
        url: "/MM/Accounting/DailyImport/views/dataPages/ValidateDataPage.cfm?theDate="+aDate,
        dataType: "json",
        async: true,
        error: function(jqXHR, textStatus, errorThrown) {
            alert('There was a error with the functions execution.  Please contact IT.  Errors will be in logs.');
            console.log('jqXHR:');
            console.log(jqXHR);
            console.log('textStatus:');
            console.log(textStatus);
            console.log('errorThrown:');
            console.log(errorThrown);
            return false;
        },
        beforeSend: function(){
            $("#validate-ax-import").html(
                '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>' +
                'Loading...'
            );
        },
        success:  function(theData){
            // Check the success variable to see what function we need to pass the result to
            if(theData[0]){
                SuccessAxValidation(aDate, theData);
            }else if(!theData[0]){
                FailAxValidation(aDate, theData)
            }
        },
        complete: function(){
            $("#validate-ax-import").html(
                'Submit'
            );
        }
    });
}

function SuccessAxValidation(aDate, theData){
    RemoveObjectsOnReload();
    
    //  Add the response notification
    $("#validation-response").append(
        '<div class="alert alert-success validation alert-width" role="alert">' +
            '<span class = "row message">All data matches</span>' +
        '</div>'
    );
    
    // Need to check to see if the table exists and create the data table.
    if($.fn.DataTable.isDataTable('#axImport')) {
        $('#axImport').remove();
        $('#import-data').html('<table id = "axImport" class = "display" width = "100%">');
    }
    
    var table = CreateAxImportDataTable(aDate);
}

function FailAxValidation(aDate, theData){
    // Need to check to see if the table exists and create the data table.
    if($.fn.DataTable.isDataTable('#axImport')) {
        $('#axImport').remove();
        $('#import-data').html('<table id = "axImport" class = "display" width = "90%">');
    }
    
    RemoveObjectsOnReload();

    // Main Alert to notify something is wrong
    $("#validation-response").append(
        '<div class="alert alert-warning validation alert-width" role="alert">' +
            '<div class = "alert-Info-message">' +
                'There was an issue.  Please contact development@tsvg with the red messages that appear on screen' +
            '<div>' +
        '</div>'
    );
    
    $.each(theData[2].MESSAGES, function(index, element){
        // Add the correct alert when writing out the issues
        if(element.PASS == true){
            $(".alert-Info-message").append(
                '<div class="alert alert-success validation" role="alert">' +
                    element.DISPLAY +
                '</div>'
            );
        }else{
            $(".alert-Info-message").append(
                '<div class="alert alert-danger validation" role="alert">' +
                    element.DISPLAY +
                '</div>'
            );
        }
        
    });
}

function CreateAxImportDataTable(aDate){
    // Get the late fee check
    var lateFee = $("#lateFeeOnly").prop("checked");
    if(lateFee){
        var axImportUrl = '/mm/accounting/dailyimport/Views/DataPages/AxLateFeeImportDataPage.cfm?theDate='+aDate+'&lateFeeOnly='+lateFee;
        var theFileName = moment(aDate).format("L")+'Invoice - LateFees';
    }else{
        var axImportUrl = '/mm/accounting/dailyimport/Views/DataPages/AxInvoiceImportDataPage.cfm?theDate='+aDate;
        var theFileName = moment(aDate).format("L")+'Invoice';    
    }
    
    // Check to see if late fees are checked
    
    
    var axImport = $("#axImport").DataTable({
        lengthMenu: [10, 25, 50, 100],
        iDisplayLength: 10,
        autoWidth: "false",
        dom: "Blftip",
        buttons:[
            {
                extend: 'csv',
                text: 'CSV',
                header: false,
                footer: false,
                filename: theFileName
            }
        ],
        destroy:true,
        ajax: {
            url: axImportUrl,
            dataSrc:"",
            type: "POST"
        },
        orderFixed: [
            [ 0, 'asc' ]
        ],
        language: {
            emptyTable: "No Data to Display",
            decimal: ",",
            thousands: "."
        },
        columns: [
            {
                title:"InvoiceNumber",
                data: "INVOICE_NUMBER",
                searchable:true,
                orderable: false,
            },
            {
                title: "Order Number",
                data: "ORDER_NUMBER",
                orderable: false,
                searchable: true
                //render: $.fn.dataTable.render.number( ',', '.', '', '' ),
            },
            {
                title: "Sku",
                data: "TDOLLAR",
                orderable: false,
                searchable: true,
                render:$.fn.dataTable.render.text()
            },
            {
                title: "Currency",
                data: "MYCURRENCY",
                orderable: false,
                searchable: true
            },
            {
                title: "Customer Number",
                data: "CUSTOMER_NUMBER",
                orderable: false,
                searchable: true
            },
            {
                title: "Description",
                data: "DESCRIPTION",
                orderable: false,
                searchable: true
            },
            {
                title: "Qty",
                data: "QTY",
                orderable: false,
                searchable: true
            },
            {
                title: "Price",
                data: "PRICE",
                orderable: false,
                searchable: true
            },
            {
                title: "FOB",
                data: "FOB",
                orderable: false,
                searchable: true
            },
            {
                title: "Total",
                data: "TOTAL",
                orderable: false,
                searchable: true
            },
            {
                title: "Date",
                data: "OTHER_DATE",
                orderable: false,
                searchable: true,
                render: function(data){
                    return moment(data).format("L");
                }
            },
            {
                title: "Tag No",
                data: "TAG_NO",
                orderable: true,
                searchable: true,
                render:$.fn.dataTable.render.text()
            },
            {
                title: "Division",
                data: "DIVISION",
                orderable: true,
                searchable: true
            }
        ],
        drawCallback: function (settings) {
            var api = this.api();
            
            // Only add total and count once the table has finished loading.
            if(settings.aoData.length > 0 && $(".total-info").length == 0) {
                var total = api.column(9).data().sum();
                var rows = api.data().count();
                
                // Update Totals
                $(".validation").append(
                    '<span class = "row validation total-info">The total is: $'+ FormatNumber(total.toFixed(2)) +'</span>' +
                    '<span class = "row validation total-info">With '+FormatNumber(rows)+' records</span>' 
                );
            }
        },
        order:[
            [4, 'asc']
        ],
    });
    
    return axImport;
}

function CreateAxCustomerImportDataTable(aCustomerNumber){
    // Remove Invoice Table
    $('#axImport').remove();
    $('#import-data').html('<table id = "axImport" class = "display" width = "100%">');
    
    // Remove Customer Table
    $('#axCustomerImport').remove();
    $('#customer-import-data').html('<table id = "axCustomerImport" class = "display" width = "100%">');
    
    // Remove Validation Alerts
    RemoveObjectsOnReload();
    
    var axCustomerImportUrl = '/mm/accounting/dailyimport/Views/DataPages/AxCustomerImportDataPage.cfm?theCustomerNumber='+aCustomerNumber;  
    
    var axCustomerImportTable = $("#axCustomerImport").DataTable({
        lengthMenu: [10, 25, 50, 100],
        iDisplayLength: 10,
        autoWidth: "false",
        dom: "Blftip",
        scrollX: true,
        buttons:[
            {
                extend: 'csv',
                text: 'CSV',
                header: false,
                filename: moment().format("L")+'Invoice-Customer'
            }
        ],
        destroy:true,
        ajax: {
            url: axCustomerImportUrl,
            dataSrc:"",
            type: "POST"
        },
        orderFixed: [
            [ 0, 'asc' ]
        ],
        language: {
            emptyTable: "No Data to Display",
            decimal: ",",
            thousands: "."
        },
        columns: [
            {
                title:"Customer Number",
                data: "CUSTOMER_NUMBER",
                visible:true,
                searchable:true
            },
            {
                title:"Customer Type",
                data: "CUSTTYPE",
                visible:true,
                searchable:true
            },
            {
                title:"Currency",
                data: "CURRENCY",
                visible:true,
                searchable:true
            },
            {
                title:"Customer",
                data: "CUSTOMERNAME",
                visible:true,
                searchable:true
            },
            {
                title:"Address",
                data: "ADDRESS",
                visible:true,
                searchable:true
            },
            {
                title:"Phone",
                data: "PHONE",
                visible:true,
                searchable:true
            },
            {
                title:"Fax",
                data: "FAX",
                visible:true,
                searchable:true
            },
            {
                title:"Country",
                data: "COUNTRY",
                visible:true,
                searchable:true
            },
            {
                title:"Zip",
                data: "THEZIP",
                visible:true,
                searchable:true
            },
            {
                title:"State",
                data: "THESTATE",
                visible:true,
                searchable:true
            },
            {
                title:"City",
                data: "THECITY",
                visible:true,
                searchable:true
            },
            {
                title:"Street",
                data: "STREET",
                visible:true,
                searchable:true
            },
            {
                title:"Statement Address",
                data: "STATEMENTADDRESS",
                visible:true,
                searchable:true
            },
            {
                title:"Statement Country",
                data: "STATEMENT_COUNTRY",
                visible:true,
                searchable:true
            },
            {
                title:"Statement Zip",
                data: "STATEMENT_THEZIP",
                visible:true,
                searchable:true
            },
            {
                title:"Statement State",
                data: "STATEMENT_STATE",
                visible:true,
                searchable:true
            },
            {
                title:"Statement City",
                data: "STATEMENT_THECITY",
                visible:true,
                searchable:true
            },
            {
                title:"Statement Street",
                data: "STATEMENTSTREET",
                visible:true,
                searchable:true
            },
            {
                title:"Invoice Email List",
                data: "INVOICEEMAILLIST",
                visible:true,
                searchable:true
            },
            {
                title:"Statement Email List",
                data: "STATEMENTEMAILLIST",
                visible:true,
                searchable:true
            },
            {
                title:"Chain",
                data: "MYCHAIN",
                visible:true,
                searchable:true
            },
        ],
        order:[
            [4, 'asc']
        ],
    });
    
    return axCustomerImportTable;
}

function RemoveObjectsOnReload(){
    // remove previous alert if it exists
    $(".validation").remove();
}

// Function to format numbers
function FormatNumber(num) {
  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
}
