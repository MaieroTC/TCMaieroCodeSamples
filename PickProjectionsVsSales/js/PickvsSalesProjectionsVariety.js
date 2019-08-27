/****************************************************************************************
*	Orginization: The Sun Valley Group                                                  
* 	File Name: PickvsSalesProjectionsVariety                                                
*  	Purpose:  Control the javascript for the drill downs                                             
*   Created At: 3/5/2019                                                             
*   Created by: TC Maiero                                                               
*   Modified At:                                                                        
*   Modified By:                                                                        
****************************************************************************************/
$(document).ready(function() {
    // Get Url parameters
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
    
    var startDate = getUrlParameter('startDate');
    var endDate  = getUrlParameter('endDate');
    var flowerType = getUrlParameter('flowerType');
    var flowerDescription = getUrlParameter('flowerdescription');
    var reportType = 'flowerVariety'
    
    // Load the ajax data
    $.ajax({
        type:"POST",
        url: "/MM/PickProjectionsVsSales/reports/dataPages/PickVsSalesProjectionsVarietyDrillDownData.cfm?startDate="+startDate+"&endDate="+endDate+"&flowerType="+flowerType,
        dataType:"JSON",
        async:true,
        success: function(data){
            BuildHeader(data, startDate, endDate, reportType);
            CreateGroupByColorJSON(data);
        }
    })
});

// Ajax start and stop functions
$(document).ajaxStart(function (){
    $(".picksVsSaleProjection-div").loading("start");
});
$(document).ajaxStop(function(){
    $(".picksVsSaleProjection-div").loading("stop");
    
    // Binds the action to each table cell with the drilldown class after load
    $('.drilldown').on('click',function(){
        console.log('clicked');
    });
    
    // Binds the jump search
    $("#scrollJump").on('click', function (e){
        // Get value of the ID we need to jump to
        var jumpId = $("#scrollJump-select").val()

        var position = $("#" + jumpId).offset().top - $(".get-height").outerHeight();
        
        $("body,html").animate({
            scrollTop:position
        });
    });
});

// Build Table Functions
function BuildHeader(jsonData, startDate, endDate, reportType){
    console.log(jsonData);
    $.each(jsonData, function(index, element){
        $('.picksVsSaleProjection-div').append(
            '<div class="row type-container" id="'+element.VARIETY+'">' +
                '<div class="col">' +
                    '<h3 class="picksVsSaleProjection-h3">'+ 
                        '<a data-flowerDescription="'+element.VARIETY_NAME+'" data-flowervariety="'+element.VARIETY+'" data-typerow-index="'+index+'" data-colorcode="'+element.COLORCODE+'" data-color="'+element.COLOR_DESCRIPTION+'">' + element.VARIETY_NAME +' - '+ element.VARIETY + ' - ' + element.COLOR_DESCRIPTION +'</a>' +
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
};

function BuildDayColumns(startDate, endDate){
    var html;
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        html += '<th data-date="'+ moment(m).format('l') +'">' + moment(m).format('l') +'</th>';
    }
    return html;
}

function BuildTable(row, data, startDate, endDate, reportType){
    var divisions = ['ARCATA', 'OXNARD', 'CANADA'];
    var level = ['COLORCODE', 'VARIETY'];
    $.each(divisions, function(index, element){
        BuildDivisionsAndTableHeaders(startDate, endDate, element, row, data);
        if(reportType == 'flowerType' || reportType == 'flowerVariety'){
            PopulateBasePickVsSalesTableByType(row, data, element, startDate, endDate);
        }
    });
}

function BuildDivisionsAndTableHeaders(startDate, endDate, element, row, data){
    $('#'+ data.VARIETY +' .divisionList-div' ).append(
        '<div class="col collapse-control">' +
            '<h5 '+ 
                'data-toggle="collapse"' +
                'data-target = ".collapse-'+element+'-'+data.VARIETY+'" ' +
                'aria-expanded="false" '+ 
                'aria-controls="collapse-'+element+'-'+data.VARIETY+'" ' +
                'class = "active-farmnet-Color font-weight-bold rounded-border cursor-change" >'
                    + element + '<i class = "sm-pad-left far fa-minus-square collapse-icon"></i>' +
            '</h5>' +
            '<div class="table-responsive" data-division ="'+ element +'">' +
                '<table id ="'+element+'-'+data.VARIETY+'" class="rounded-border table picksVsSaleProjection-table">' +
                    '<thead>' +
                        '<tr class = "pickVsSalesHeader table-active">' +
                            '<th></th>' +
                            '<th>Starting Inventory</th>' +
                            '<th>Todays Sales</th>' +
                        '</tr>' +
                    '</thead>' +
                    '<tbody class="divisionProjections collapse show collapse-'+element+'-'+data.VARIETY+'">'+
                    '</tbody>' +
                    '<tfoot class="divisionProjectionsTotal rounded-border">'+
                    '</tfoot>' +
                '</table>' +
            '</div>' +
        '</div>'
    );
    //Build Days
    var dateHtml = BuildDayColumns(startDate, endDate);
    $('#'+element+'-'+data.VARIETY+ ' .pickVsSalesHeader').append(dateHtml);
}

function PopulateBasePickVsSalesTableByType(row, data, element, startDate, endDate){
    PickProjectionsPopulate(row, data, element, startDate, endDate);
    InTransitPopulate(row, data, element, startDate, endDate);
    SalesProjectionsPopulate(row, data, element, startDate, endDate);
    GuessSalesProjectionPopulate(row, data, element, startDate, endDate);
    RunningTotalPopulate(row, data, element, startDate, endDate);
}

function PickProjectionsPopulate(row, data, element, startDate, endDate){
    $('#'+ element+'-'+data.VARIETY +' .divisionProjections').append(
        '<tr id=picks-'+ element+'-'+data.VARIETY +'>' +
            '<td>Picks</td>' +
            '<td></td>' +
            '<td></td>' +
        '</tr>'
    );
    
    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.PICKPROJECTIONS.find(PICKPROJECTIONS => PICKPROJECTIONS.DIVISION == element && moment(PICKPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
        
        $('#picks-'+ element+'-'+data.VARIETY).append(
            '<td class= drilldown '+
                ' data-picks-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-picks-division='+ element +
                ' data-picks-type='+ divisionData.FLOWERVARIETY+
                ' data-picks-totelStems='+ divisionData.TOTALPROJECTEDPICKSTEMS +'>'
                    + divisionData.TOTALPROJECTEDPICKSTEMS + 
            '</td>'
        );
    }
}

function InTransitPopulate(row, data, element, startDate, endDate){
    $('#'+ element+'-'+data.VARIETY +' .divisionProjections' ).append(
        '<tr id= inTransit-'+ element+'-'+data.VARIETY +'>' +
            '<td>In-Transit</td>' +
            '<td></td>' +
            '<td></td>' +
        '</tr>'  
    );
    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.INTRANSITPROJECTIONS.find(INTRANSITPROJECTIONS => INTRANSITPROJECTIONS.DIVISION == element && moment(INTRANSITPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
        $('#inTransit-'+ element+'-'+data.VARIETY).append(
            '<td class= drilldown '+ 
                ' data-inTransit-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-inTransit-division='+ element +
                ' data-inTransit-type='+ divisionData.FLOWERVARIETY+
                ' data-inTransit-totelStems='+ divisionData.TOTALPROJECTEDSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSTEMS + 
            '</td>'
        );
    }
}

function SalesProjectionsPopulate(row, data, element, startDate, endDate){
    var dayBefore =  moment(startDate).subtract(1, 'd');
    
    // Build the first days sales
    var divisionData = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(dayBefore).format('L'));
    $('#'+ element+'-'+data.VARIETY +' .divisionProjections' ).append(
        '<tr id=sales-'+element+'-'+divisionData.FLOWERVARIETY+'>' +
            '<td>Sales</td>' +
            '<td></td>' +
            '<td class= drilldown '+ 
                ' data-sales-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-sales-division='+ element +
                ' data-sales-type='+ divisionData.FLOWERVARIETY+
                ' data-sales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSALESSTEMS + 
            '</td>' +
        '</tr>' 
    );
    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(m).format('L'));
        $('#sales-'+ element+'-'+data.VARIETY).append(
            '<td class= drilldown '+
                'data-sales-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-sales-division='+ element +
                ' data-sales-type='+ divisionData.FLOWERVARIETY+
                ' data-sales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSALESSTEMS + 
            '</td>'
        );
    }
}

function GuessSalesProjectionPopulate(row, data, element, startDate, endDate){
    var dayBefore =  moment(startDate).subtract(1, 'd');
    var divisionData = data.GUESSSALEPROJECTIONS.find(GUESSSALEPROJECTIONS => GUESSSALEPROJECTIONS.DIVISION == element && moment(GUESSSALEPROJECTIONS.DISPLAYDATE).format('L') == moment(dayBefore).format('L'));
    $('#'+ element+'-'+data.VARIETY +' .divisionProjections' ).append(
        '<tr id=guessSales-'+element+'-'+divisionData.FLOWERVARIETY+'>' +
            '<td>Guess</td>' +
            '<td></td>' +
            '<td class= drilldown '+
                ' data-guessSales-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-guessSales-division='+ element +
                ' data-guessSales-type='+ divisionData.FLOWERVARIETY+
                ' data-guessSales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSALESSTEMS + 
            '</td>' +
        '</tr>' 
    );
    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.GUESSSALEPROJECTIONS.find(GUESSSALEPROJECTIONS => GUESSSALEPROJECTIONS.DIVISION == element && moment(GUESSSALEPROJECTIONS.DISPLAYDATE).format('L') == moment(m).format('L'));
        $('#guessSales-'+ element+'-'+data.VARIETY).append(
            '<td class= drilldown '+
                ' data-guessSales-date='+ moment(divisionData.DATEKEY).format('L') +
                ' data-guessSales-division='+ element +
                ' data-guessSales-type='+ divisionData.FLOWERVARIETY+
                ' data-guessSales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                    + divisionData.TOTALPROJECTEDSALESSTEMS + 
            '</td>'
        );
    }
}

function RunningTotalPopulate(row, data, element, startDate, endDate){
    // Starting Inventory
    var runningTotal = data.STARTINGINVENTORY.find(STARTINGINVENTORY => STARTINGINVENTORY.DIVISION == element);
    $('#'+ element+'-'+data.VARIETY +' .divisionProjectionsTotal' ).append(
        '<tr class = "table-info" '+ 
            ' id=runningTotal-'+element+'-'+runningTotal.VARIETY+'>' +
                '<td class = "font-weight-bold">' 
                    + 'Running Total' +
                '</td>' +
                '<td class = "font-weight-bold"'+
                    ' id = runningTotal-'+element+'-start-'+runningTotal.VARIETY +
                    ' data-runningTotal-date=starting data-runningTotal-division='+ element +
                    ' data-runningTotal-type='+ runningTotal.VARIETY+
                    ' data-runningTotal-totelStems='+ runningTotal.TOTAL +'>'
                        + runningTotal.TOTAL +
                '</td>' +
        '</tr>' 
    );
    
    // Variable to check for no data
    var noDate = false;
    // Today's Sale's
    var dayBefore =  moment(startDate).subtract(1, 'd');
    
    // Guess Sales are included in sales
    var sales = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(dayBefore).format('L'));
    
    var totalStems = runningTotal.TOTAL - sales.TOTALPROJECTEDSALESSTEMS;
    //console.log(runningTotal);
    //console.log(sales);
    //console.log(totalStems);
    
    $('#runningTotal-'+element+'-'+runningTotal.VARIETY).append(
        '<td class = "font-weight-bold" '+
            'id = runningTotal-'+element+'-'+moment(dayBefore).unix()+'-'+runningTotal.VARIETY+'>'
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
        
        previousTotalStems = $("#runningTotal-"+element+"-"+moment(dayBefore).unix()+"-"+runningTotal.VARIETY).html();
        
        totalStems = previousTotalStems - sales.TOTALPROJECTEDSALESSTEMS + inTransit.TOTALPROJECTEDSTEMS + pickProjections.TOTALPROJECTEDPICKSTEMS
        
        if(totalStems == 0){
            noData = true;
        }else{
            noData = false;
        }
        
        $('#runningTotal-'+element+'-'+runningTotal.VARIETY).append(
            '<td class = "font-weight-bold"'+
                ' id = runningTotal-'+element+'-'+moment(m).unix()+'-'+runningTotal.VARIETY+'>'
                    + totalStems +
            '</td>'
        );
    }
    
    if(noData == true){
        $('.collapse-'+element+'-'+runningTotal.VARIETY).collapse({
            hide: true
        });
    }
    
    $('tr#runningTotal-'+element+'-'+runningTotal.VARIETY).find('td').each(function(){
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
    
}

function PopulateScrollSpySearch(data){
    // Remove all options on rebuild
    $('#scrollJump-select').children().remove();
    
    $.each(data, function(index, element){
        $('#scrollJump-select')
            .append($("<option value ="+element.VARIETY+">" + element.VARIETY_NAME + "-" + element.VARIETY + "</option>"));
    });
}

function CreateGroupByColorJSON(data){
    // Array to store unique colors
    var lookup = {};
    var result = [];
    
    // Loop through each colorcode and add uniqu ones for groupings
    $.each(data, function(index, element){
        var color = element.COLORCODE;
        // Check to see if the color is already added to the array
        if(!(color in lookup)){
            lookup[color] = 1;
            result.push(color);
        };
    });
    
    
    
    //var testColor = data.STARTINGINVENTORY.find(STARTINGINVENTORY => STARTINGINVENTORY.DIVISION == element);
}
