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
    $(".getPickVsSales").on('click', function(){
        // $(".picksVsSaleProjection-div").loading("toggle");
        $('.picksVsSaleProjection-div').empty();
        var startDate = moment($(".startDate").val()).format("L");
        var endDate = moment($(".endDate").val()).format("L");
        
        var reportType = 'flowerType'; 
        
        if(moment(startDate, 'MM/DD/YYYY').isValid() && moment(endDate, 'MM/DD/YYYY').isValid()){
            $.ajax({
                type:"POST",
                url: "/MM/PickProjectionsVsSales/reports/dataPages/PickVsSalesProjectionsData.cfm?startDate="+startDate+"&endDate="+endDate,
                dataType:"JSON",
                async:true,
                success: function(data){
                    BuildHeader(data, startDate, endDate, reportType);
                }
            })
        }else{
            alert("Not a valid date");
        }
    });
});

// Ajax start and stop functions
$(document).ajaxStart(function (){
    $(".picksVsSaleProjection-div").loading("start");
});
$(document).ajaxStop(function(){
    $(".picksVsSaleProjection-div").loading("stop");
    
    // Binds the jump search
    $("#scrollJump").on('click', function (e){
        // Get value of the ID we need to jump to
        var jumpId = $("#scrollJump-select").val()

        var position = $("#" + jumpId).offset().top - $(".get-height").outerHeight();
        
        $("body,html").animate({
            scrollTop:position
        });
    });
    
    $(".orderDrilldown").on("click", function(){
        var saleDate = $(this).data('sales-date');
        var division = $(this).data('sales-division');
        var flowerType = $(this).data('sales-type');
        
        var orderWindow = window.open(
            "/MM/PickProjectionsVsSales/reports/PicksVsSalesOrderDrillDown.cfm?theSaleDate="+saleDate+"&theDivision="+division+"&theFlowerType="+flowerType+"&excludeTransfers="+false,
            "_blank",
            "",
            'true'
        );
        
        orderWindow.addEventListener('load', function() {
	        orderWindow.document.title = saleDate + ' - ' + division + ' - ' + flowerType;
        });
        
    });
});

// Build Table Functions
function BuildHeader(jsonData, startDate, endDate, reportType){
    $.each(jsonData, function(index, element){
        $('.picksVsSaleProjection-div').append(
            '<div class="row type-container" id="'+element.TYPE+'">' +
                '<div class="col">' +
                    '<h3 class="picksVsSaleProjection-h3">'+ 
                        '<a class = "openVarietyDrillDown cursor-change" data-flowerdescription="'+element.DESCRIPTION+'" data-flowertype="'+element.TYPE+'" data-typeRow-index="'+index+'">' 
                            + element.DESCRIPTION +' - '+ element.TYPE + 
                        '</a>' +
                    '</h3>' +
                '</div>' +
                '<div class="row">' +
                    '<div class="row divisionList-div">' +
                    '</div>' +
                '</div>' +
            '</div>' 
        );
        BuildTable(index, this, startDate, endDate, reportType);
    });
    
    PopulateScrollSpySearch(jsonData);
    
    // Variety Drill Down Open in new window
    $(".openVarietyDrillDown").on("click", function(){
        var windowType = $(this).data("flowertype");
        var windowTypeDesc = $(this).data("flowerdescription");
        
        
        varietyWindow = window.open(
            "/MM/PickProjectionsVsSales/reports/PickvsSalesProjectionsColorVarietyDrillDown.cfm?startDate="+startDate+"&endDate="+endDate+"&flowerType="+windowType+"&flowerdescription="+windowTypeDesc,
            "_blank",
            "",
            'true'
        );
        
        varietyWindow.addEventListener('load', function() {
	        varietyWindow.document.title = windowTypeDesc + ' - ' + windowType;
        });
        return true;
    });
    
}

function BuildTable(row, data, startDate, endDate, reportType){
    var divisions = ['ARCATA', 'OXNARD', 'CANADA'];
    $.each(divisions, function(index, element){
        BuildDivisionsAndTableHeaders(startDate, endDate, element, row, data);
        if(reportType == 'flowerType'){
            PopulateBasePickVsSalesTableByType(row, data, element, startDate, endDate);
        }
    });
}

function BuildDayColumns(startDate, endDate){
    var html;
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        html += '<th data-date="'+ moment(m).format('l') +'">' + moment(m).format('l') +'</th>';
    }
    return html;
}

function BuildDivisionsAndTableHeaders(startDate, endDate, element, row, data){
    $('#'+ data.TYPE +' .divisionList-div' ).append(
        '<div class="col collapse-control">' +
            '<h5 '+ 
                'data-toggle="collapse"' +
                'data-target = ".collapse-'+element+'-'+data.TYPE+'" ' +
                'aria-expanded="false" '+ 
                'aria-controls="collapse-'+element+'-'+data.TYPE+'" ' +
                'class = "active-farmnet-Color font-weight-bold rounded-border cursor-change" >'
                    + element + '<i class = "sm-pad-left far fa-minus-square collapse-icon"></i>' +
            '</h5>' +
            '<div class="table-responsive" data-division ="'+ element +'">' +
                '<table id ="'+element+'-'+data.TYPE+'" class="rounded-border table picksVsSaleProjection-table">' +
                    '<thead>' +
                        '<tr class = "pickVsSalesHeader table-active">' +
                            '<th></th>' +
                            '<th>Starting Inventory</th>' +
                            '<th>Todays Sales</th>' +
                        '</tr>' +
                    '</thead>' +
                    '<tbody class="divisionProjections collapse show collapse-'+element+'-'+data.TYPE+'">'+
                    '</tbody>' +
                    '<tfoot class="divisionProjectionsTotal rounded-border">'+
                    '</tfoot>' +
                '</table>' +
            '</div>' +
        '</div>'
    );
    //Build Days
    var dateHtml = BuildDayColumns(startDate, endDate);
    $('#'+element+'-'+data.TYPE+ ' .pickVsSalesHeader').append(dateHtml);
    $('#'+element+'-'+data.TYPE+ ' .pickVsSalesHeader').append(
        '<th class = "rowTotal">Totals</th>'
    );
}

function PopulateBasePickVsSalesTableByType(row, data, element, startDate, endDate){
    PickProjectionsPopulate(row, data, element, startDate, endDate);
    InTransitPopulate(row, data, element, startDate, endDate);
    SalesProjectionsPopulate(row, data, element, startDate, endDate);
    GuessSalesProjectionPopulate(row, data, element, startDate, endDate);
    RunningTotalPopulate(row, data, element, startDate, endDate);
}

function PickProjectionsPopulate(row, data, element, startDate, endDate){
    var total = 0;
    
    $('#'+ element+'-'+data.TYPE +' .divisionProjections').append(
        '<tr id=picks-'+ element+'-'+data.TYPE +'>' +
            '<td>Picks</td>' +
            '<td></td>' +
            '<td></td>' +
        '</tr>'
    );
    
    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.PICKPROJECTIONS.find(PICKPROJECTIONS => PICKPROJECTIONS.DIVISION == element && moment(PICKPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
        
        $('#picks-'+ element+'-'+data.TYPE).append(
            '<td class= drilldown '+
                ' data-picks-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-picks-division='+ element +
                ' data-picks-type='+ divisionData.FLOWERTYPE+
                ' data-picks-totelStems='+ divisionData.TOTALPROJECTEDPICKSTEMS +'>'
                    + divisionData.TOTALPROJECTEDPICKSTEMS + 
            '</td>'
        );
        total = total + divisionData.TOTALPROJECTEDPICKSTEMS;  
    }
    $('#picks-'+ element+'-'+data.TYPE).append(
        '<td class= drilldown '+
            ' data-picks-division='+ element +
            ' data-picks-type='+ divisionData.FLOWERTYPE+
            ' data-picks-totelStems='+ total +'>'
                + total + 
        '</td>'
    );
}

function InTransitPopulate(row, data, element, startDate, endDate){
    var total = 0;
    
    $('#'+ element+'-'+data.TYPE +' .divisionProjections' ).append(
        '<tr id= inTransit-'+ element+'-'+data.TYPE +'>' +
            '<td>In-Transit</td>' +
            '<td></td>' +
            '<td></td>' +
        '</tr>'  
    );
    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.INTRANSITPROJECTIONS.find(INTRANSITPROJECTIONS => INTRANSITPROJECTIONS.DIVISION == element && moment(INTRANSITPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
        $('#inTransit-'+ element+'-'+data.TYPE).append(
            '<td class= drilldown '+ 
                ' data-inTransit-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-inTransit-division='+ element +
                ' data-inTransit-type='+ divisionData.FLOWERTYPE+
                ' data-inTransit-totelStems='+ divisionData.TOTALPROJECTEDSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSTEMS + 
            '</td>'
        );
        
        total = total + divisionData.TOTALPROJECTEDSTEMS;
    }
    $('#inTransit-'+ element+'-'+data.TYPE).append(
        '<td class= drilldown '+ 
            ' data-inTransit-division='+ element +
            ' data-inTransit-type='+ divisionData.FLOWERTYPE+
            ' data-inTransit-totelStems='+ total +'>'
                + total + 
        '</td>'
    );
}

function SalesProjectionsPopulate(row, data, element, startDate, endDate){
    var dayBefore =  moment(startDate).subtract(1, 'd');
    var total = 0;
    // Build the first days sales
    var divisionData = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(dayBefore).format('L'));
    $('#'+ element+'-'+data.TYPE +' .divisionProjections' ).append(
        '<tr id=sales-'+element+'-'+divisionData.FLOWERTYPE+'>' +
            '<td>Sales</td>' +
            '<td></td>' +
            '<td class= orderDrilldown '+ 
                ' data-sales-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-sales-division='+ element +
                ' data-sales-type='+ divisionData.FLOWERTYPE+
                ' data-sales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSALESSTEMS + 
                    '<i class="far fa-question-circle sm-pad-left invToolTip cursor-change"' +
                        ' data-toggle=invchannel-tooltip/>' +
                    '</i>' +
            '</td>' +
        '</tr>' 
    );
    
    total = total + divisionData.TOTALPROJECTEDSALESSTEMS;
    
    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(m).format('L'));
        $('#sales-'+ element+'-'+data.TYPE).append(
            '<td class= orderDrilldown '+
                'data-sales-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-sales-division='+ element +
                ' data-sales-type='+ divisionData.FLOWERTYPE+
                ' data-sales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSALESSTEMS +
                    '<i class="far fa-question-circle sm-pad-left invToolTip cursor-change"' +
                        ' data-toggle=invchannel-tooltip/>' +
                    '</i>' + 
            '</td>'
        );
        
        total = total + divisionData.TOTALPROJECTEDSALESSTEMS;
    }
    // Add total column
    $('#sales-'+ element+'-'+data.TYPE).append(
        '<td class= orderDrilldown '+
            ' data-sales-division='+ element +
            ' data-sales-type='+ divisionData.FLOWERTYPE+
            ' data-sales-totelStems='+ total +'>'
                + total +
        '</td>'
    );
}

function GuessSalesProjectionPopulate(row, data, element, startDate, endDate){
    var total = 0;
    var dayBefore =  moment(startDate).subtract(1, 'd');
    var divisionData = data.GUESSSALEPROJECTIONS.find(GUESSSALEPROJECTIONS => GUESSSALEPROJECTIONS.DIVISION == element && moment(GUESSSALEPROJECTIONS.DISPLAYDATE).format('L') == moment(dayBefore).format('L'));
    $('#'+ element+'-'+data.TYPE +' .divisionProjections' ).append(
        '<tr id=guessSales-'+element+'-'+divisionData.FLOWERTYPE+'>' +
            '<td>Guess</td>' +
            '<td></td>' +
            '<td class= drilldown '+
                ' data-guessSales-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-guessSales-division='+ element +
                ' data-guessSales-type='+ divisionData.FLOWERTYPE+
                ' data-guessSales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSALESSTEMS + 
            '</td>' +
        '</tr>' 
    );
    
    total = divisionData.TOTALPROJECTEDSALESSTEMS + total;
    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.GUESSSALEPROJECTIONS.find(GUESSSALEPROJECTIONS => GUESSSALEPROJECTIONS.DIVISION == element && moment(GUESSSALEPROJECTIONS.DISPLAYDATE).format('L') == moment(m).format('L'));
        $('#guessSales-'+ element+'-'+data.TYPE).append(
            '<td class= drilldown '+
                ' data-guessSales-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-guessSales-division='+ element +
                ' data-guessSales-type='+ divisionData.FLOWERTYPE+
                ' data-guessSales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSALESSTEMS + 
            '</td>'
        );
        
        total = divisionData.TOTALPROJECTEDSALESSTEMS + total;
    }
    $('#guessSales-'+ element+'-'+data.TYPE).append(
        '<td class= drilldown '+
            ' data-guessSales-division='+ element +
            ' data-guessSales-type='+ divisionData.FLOWERTYPE+
            ' data-guessSales-totelStems='+ total +'>'
                + total + 
        '</td>'
    );
}

function RunningTotalPopulate(row, data, element, startDate, endDate){
    // Starting Inventory
    var runningTotal = data.STARTINGINVENTORY.find(STARTINGINVENTORY => STARTINGINVENTORY.DIVISION == element);
    $('#'+ element+'-'+data.TYPE +' .divisionProjectionsTotal' ).append(
        '<tr class = "table-info" '+ 
            ' id=runningTotal-'+element+'-'+runningTotal.TYPE+'>' +
                '<td class = "font-weight-bold">' 
                    + 'Running Total' +
                '</td>' +
                '<td class = "font-weight-bold td-align-right"'+
                    ' id = runningTotal-'+element+'-start-'+runningTotal.TYPE +
                    ' data-runningTotal-date=starting data-runningTotal-division='+ element +
                    ' data-runningTotal-type='+ runningTotal.TYPE+
                    ' data-runningTotal-totelStems='+ runningTotal.TOTAL +'>'
                        + runningTotal.TOTAL +
                    '<i class="far fa-question-circle sm-pad-left invToolTip"' +
                        ' data-toggle=invchannel-tooltip/>' +
                    '</i>' +
                '</td>' +
        '</tr>' 
    );
    
    // Write the tool tip html
    var inventoryTypes = ['MASSMK', 'NORMAL', 'ONBULB', 'UNFINH'];
    var startingInvToolTip = '';
    $.each(inventoryTypes, function(index, type){
        var startingByChannel = data.STARTINGINVAGINGBYCHANNEL.find(STARTINGINVAGINGBYCHANNEL => STARTINGINVAGINGBYCHANNEL.DIVISION.toUpperCase() == element.toUpperCase() && STARTINGINVAGINGBYCHANNEL.INVTYPE.toUpperCase() == type.toUpperCase());
        startingInvToolTip = startingInvToolTip +
            '<div class="row">' + 
                '<div class="col">'
                    + startingByChannel.INVENTORYNAME +
                '</div>' +
                '<div class="col">'
                    + startingByChannel.MYSTEMS +
                '</div>' +
            '</div>';
    });
    
    // initialize the tooltip
    $('#runningTotal-'+element+'-start-'+runningTotal.TYPE).tooltip({
        title: startingInvToolTip,
        placement: 'auto',
        html: true
    }); 
    
    // Variable to check for no data
    var noDate = false;
    // Today's Sale's
    var dayBefore =  moment(startDate).subtract(1, 'd');
    
    // Guess Sales are included in sales
    var sales = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(dayBefore).format('L'));
    
    var totalStems = runningTotal.TOTAL - sales.TOTALPROJECTEDSALESSTEMS;
    
    $('#runningTotal-'+element+'-'+runningTotal.TYPE).append(
        '<td class = "font-weight-bold" '+
            'id = runningTotal-'+element+'-'+moment(dayBefore).unix()+'-'+runningTotal.TYPE+'>'
                + totalStems +
        '</td>'
    );
    
    //Loop through day columns
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var dayBefore =  moment(m).subtract(1, 'd');
        
        // Guess Sales are included in Sales
        var sales = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(m).format('L'));
        
        var inTransit = data.INTRANSITPROJECTIONS.find(INTRANSITPROJECTIONS => INTRANSITPROJECTIONS.DIVISION == element && moment(INTRANSITPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
        
        var pickProjections = data.PICKPROJECTIONS.find(PICKPROJECTIONS => PICKPROJECTIONS.DIVISION == element && moment(PICKPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
        
        previousTotalStems = $("#runningTotal-"+element+"-"+moment(dayBefore).unix()+"-"+runningTotal.TYPE).html();
        
        totalStems = previousTotalStems - sales.TOTALPROJECTEDSALESSTEMS + inTransit.TOTALPROJECTEDSTEMS + pickProjections.TOTALPROJECTEDPICKSTEMS
        if(totalStems == 0){
            noData = true;
        }else{
            noData = false;
        }

        $('#runningTotal-'+element+'-'+runningTotal.TYPE).append(
            '<td class = "font-weight-bold"'+
                ' id = runningTotal-'+element+'-'+moment(m).unix()+'-'+runningTotal.TYPE+'>'
                    + totalStems  +
            '</td>'
        );
    }
    
    
    $('tr#runningTotal-'+element+'-'+runningTotal.TYPE).find('td').each(function(){
        if($(this).html() < 0){
            $(this).addClass('redText');
        }
    });
    
    // Collapse Control 
    $(".collapse-control").on('shown.bs.collapse', function(){
        $(this)
            .find(".fa-plus-square") 
            .removeClass("fa-plus-square")
            .addClass("fa-minus-square");
    });
    
    $(".collapse-control").on('hidden.bs.collapse', function(){
        $(this)
            .find(".fa-minus-square") 
            .removeClass("fa-minus-square")
            .addClass("fa-plus-square");
    });
    
    if(noData == true){
        $('.collapse-'+element+'-'+runningTotal.TYPE).collapse({
            hide: true
        });
    }
    // Add total column.  There is no data for this but it is for looks
    $('#runningTotal-'+element+'-'+runningTotal.TYPE).append(
        '<td class = "font-weight-bold"'+
        '</td>'
    );
}

function PopulateScrollSpySearch(data){
    // Remove all options on rebuild
    $('#scrollJump-select').children().remove();
    
    $.each(data, function(index, element){
        $('#scrollJump-select')
            .append($("<option value ="+element.TYPE+">" + element.TYPE + "-" + element.DESCRIPTION + "</option>"));
    });
}
