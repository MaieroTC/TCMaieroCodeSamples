/****************************************************************************************
*	Orginization: The Sun Valley Group                                                  
* 	File Name:                                                 
*  	Purpose:                                               
*   Created At:                                                              
*   Created by: TC Maiero                                                               
*   Modified At:                                                                        
*   Modified By:                                                                        
****************************************************************************************/

$(document).ready(function() {
    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = window.location.search.substring(1),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
            }
        }
    };
    
    var saleDate = getUrlParameter('theSaleDate');
    var division  = getUrlParameter('theDivision');
    var flowerType = getUrlParameter('theFlowerType');
    var excludeTransfers = false;
    
    var table = PicksVsSalesOrders(saleDate, division, flowerType, excludeTransfers);
});

function PicksVsSalesOrders(saleDate, division, flowerType, excludeTransferOrders){
    var outerTable = $("#orderInfo").DataTable({
        lengthMenu: [10, 25, 50, 100],
        iDisplayLength: 100,
        autoWidth: "false",
        dom: "Blftip",
        destroy:true,
        buttons:[
            'copy', 'csv', 'print'
        ],
        ajax: {
            url: "/MM/PickProjectionsVsSales/Reports/DataPages/PickVsSalesProjectionsOrderDrillDownData.cfm?theSaleDate="+saleDate+"&theDivision="+division+"&theFlowerType="+flowerType+"&excludeTransfers="+excludeTransferOrders,
            dataSrc:"",
            type: "POST"
        },
        language: {
            emptyTable: "No Data to Display",
            decimal: ",",
            thousands: "."
        },
        columns: [
            {title: "Order Id", data: "ORDERID", visible:true},
            {title: "Division", data: "DIVISION", visible:true},
            {title: "Order Status", data: "ORDERSTATUS", visible:true},
            {title: "Ship to 1", data: "SHIPTOADD1", visible:true},
            {title: "Ship to 2", data: "SHIPTOADD2", visible:true},
            {title: "Ship to 3", data: "SHIPTOADD3", visible:true},
            {title: "City", data: "SHIPTOCITY", visible:true},
            {title: "State", data: "SHIPTOSTATE", visible:true},
            {title: "Total Stems", data: "TOTALSTEMS", visible:true},
        ],
        order:[
            [1, 'desc']
        ]
    });
    
    return outerTable;
}
