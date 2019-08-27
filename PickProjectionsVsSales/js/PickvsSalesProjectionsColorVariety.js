/****************************************************************************************
*	Orginization: The Sun Valley Group                                                  
* 	File Name: PickvsSalesProjectionsVariety                                                
*  	Purpose:  Control the javascript for the drill downs                                             
*   Created At: 3/5/2019                                                             
*   Created by: TC Maiero                                                               
*   Modified At:                                                                        
*   Modified By:                                                                        
****************************************************************************************/
// Global Variables
// Main Object
var colorHead = [];
var colorSummary = {};

var level;
var altLevel;

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
    
    // Set Tab Title
    $('head title', window.parent.document).text(flowerDescription + '-' + flowerType);
    //Set the page Title
    $('.title').html('Projections - Picks vs Sales - ' + flowerDescription + ' - ' + flowerType);

     
    // Load the ajax data
    $.ajax({
        type:"POST",
        url: "/MM/PickProjectionsVsSales/reports/dataPages/PickVsSalesProjectionsVarietyDrillDownData.cfm?startDate="+startDate+"&endDate="+endDate+"&flowerType="+flowerType,
        dataType:"JSON",
        async:true,
        success: function(data){
            BuildByColor(data, startDate, endDate, reportType);
        }
    })
});

// Ajax start and stop functions
$(document).ajaxStart(function (){
    $(".picksVsSaleProjection-div").loading("start");
    // Remove all options on rebuild
    $('#scrollJump-select').children().remove();
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
        
        // Set the new position
        var position = $("#" + jumpId).offset().top - $(".get-height").outerHeight();
        
        $("body,html").animate({
            scrollTop:position
        });
    });
    
    // console.log(colorHead);
});

function BuildByColor(data, startDate, endDate, reportType){
    // Get Unique colors from the data
    var colors = CreateUniqueColorList(data);
    // Loop through each color
    $.each(colors, function(index, element){
        // Find all varieties with matching colors
        
        var colorFind = data.filter(color => color.COLORCODE == element);
        
        // Copy the first object in the array and clean it up.
        colorSummary = Object.assign({}, colorFind[0]);
        colorSummary.GUESSSALEPROJECTIONS = [];
        colorSummary.INTRANSITPROJECTIONS = [];
        colorSummary.PICKPROJECTIONS = [];
        colorSummary.SALESPROJECTIONS = [];
        colorSummary.STARTINGINVENTORY = [];
        delete colorSummary.SHORT_NAME;
        delete colorSummary.TYPE;
        delete colorSummary.TYPEVARIETY;
        delete colorSummary.VARIETY;
        delete colorSummary.VARIETY_NAME;
            
        // Need to create the Color Summary
        BuildHeader(colorFind, startDate, endDate, reportType);
        
        // Push the current object into the color Head array
        colorHead.push(colorSummary);
    });
}

function CreateUniqueColorObjectForSearch(data){
    // Array to store unique colors
    var lookup = {};
    var result = [];
    
    // Loop through each colorcode and add uniqu ones for groupings
    $.each(data, function(index, element){
        var color = element.COLORCODE;
        // Check to see if the color is already added to the array
        if(!(color in lookup)){
            lookup[color] = 1;
            lookup['COLOR_DESCRIPTION'] = element.COLOR_DESCRIPTION;
            lookup['COLORCODE'] = element.COLORCODE;
            result.push(lookup);
        };
    });
    //console.log(result);
    return result;
}

function CreateUniqueColorList(data){
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

    return result;
}

// Build Table Functions
function BuildHeader(data, startDate, endDate, reportType){
    $.each(data, function(index, element){
        // Check to see if it is a new color
        level = 'flowerVariety'
        
        // if this is the first for this color set.  Create the header 
        if(index == 0){
            $('.picksVsSaleProjection-div').append(
                '<div class ="row type-container level-color" id="'+element.COLORCODE.trim()+'">' + 
                    '<div class = "variety-collapse variety-collapse-row card" data-toggle="collapse" href="#collapse-head-'+element.COLORCODE.trim()+'" role="button" aria-expanded="false" aria-controls="collapseExample">' +
                        'Click for Variety Details' +
                        '<div class="collapse" id="collapse-head-'+element.COLORCODE.trim()+'">'+
                            '<div class="card-body" id="collapse-body-'+element.COLORCODE.trim()+'">' + 
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>'            
            );
        }
        
        // Build the variety header
        $('#collapse-body-'+element.COLORCODE.trim()).append(
            '<div class="row type-container level-variety" id="'+element.VARIETY+'">' +
                '<div class="col">' +
                    '<h3 class="picksVsSaleProjection-h3">'+ 
                        '<a data-flowerDescription="'+element.VARIETY_NAME+'" data-flowervariety="'+element.VARIETY+'" data-typerow-index="'+index+'" data-colorcode="'+element.COLORCODE.trim()+'" data-color="'+element.COLOR_DESCRIPTION.trim()+'">' + element.VARIETY_NAME +' - '+ element.VARIETY + ' - ' + element.COLOR_DESCRIPTION.trim() +'</a>' +
                    '</h3>' +
                '</div>' +
                '<div class="row">' +
                    '<div class="row divisionList-div" id="level-container-'+element.VARIETY+'">' +
                    '</div>' +
                '</div>' +
            '</div>'            
        );
        
        // Build the rest of the table
        BuildTable(index, element, startDate, endDate, reportType, level);
        
        // Check to see if this is the last item in the color list, if it is then build the Color table
        if(index == data.length - 1){
            $('#'+element.COLORCODE.trim()).prepend(
                '<div class="col">' +
                    '<h3 class="picksVsSaleProjection-h3">'+ 
                        '<a "data-typerow-index="'+index+'" data-colorcode="'+element.COLORCODE.trim()+'" data-color="'+element.COLOR_DESCRIPTION.trim()+'">' + element.COLOR_DESCRIPTION.trim() +'</a>' +
                    '</h3>' +
                '</div>' +
                '<div class="row">' +
                    '<div class="row divisionList-div" id="level-container-'+element.COLORCODE.trim()+'">' +
                    '</div>' +
                '</div>' 
            );
            level = 'flowerColor';
            BuildTable(index, element, startDate, endDate, reportType, level);
        }
    });
    
    //PopulateScrollSpySearchVariety(data);
    PopulateScrollSpySearchColor(data);
};

function BuildTable(row, data, startDate, endDate, reportType, reportLevel, colorIndex){
    // Loop through Divisions
    // NOTE: Need to change this to be dynamic based on the data
    var divisions = ['ARCATA', 'OXNARD', 'CANADA'];
    $.each(divisions, function(index, element){
        // Build each division head
        BuildDivisionsAndTableHeaders(startDate, endDate, element, row, data, reportLevel);
        // Populate each division with data with data
        PopulateBasePickVsSalesTableByType(row, data, element, startDate, endDate, reportLevel);
    });
}

function BuildDivisionsAndTableHeaders(startDate, endDate, element, row, data, reportLevel){
    var level;
    if(reportLevel == 'flowerVariety'){
        level = 'VARIETY';
    }else if(reportLevel == 'flowerColor'){
        level = 'COLORCODE';
    }
    // Build each division container the data will be 
    $('#level-container-'+ data[level]).append(
        '<div class="col collapse-control">' +
            '<h5 '+ 
                'data-toggle="collapse"' +
                'data-target = ".collapse-'+element+'-'+data[level]+'" ' +
                'aria-expanded="false" '+ 
                'aria-controls="collapse-'+element+'-'+data[level]+'" ' +
                'class = "active-farmnet-Color font-weight-bold rounded-border cursor-change" >'
                    + element + '<i class = "sm-pad-left far fa-minus-square collapse-icon"></i>' +
            '</h5>' +
            '<div class="table-responsive" data-division ="'+ element +'">' +
                '<table id ="'+element+'-'+data[level]+'" class="rounded-border table picksVsSaleProjection-table">' +
                    '<thead>' +
                        '<tr class = "pickVsSalesHeader table-active">' +
                            '<th></th>' +
                            '<th>Starting Inventory</th>' +
                            '<th>Todays Sales</th>' +
                        '</tr>' +
                    '</thead>' +
                    '<tbody class="divisionProjections collapse show collapse-'+element+'-'+data[level]+'">'+
                    '</tbody>' +
                    '<tfoot class="divisionProjectionsTotal rounded-border">'+
                    '</tfoot>' +
                '</table>' +
            '</div>' +
        '</div>'
    );
    //Build Days
    var dateHtml = BuildDayColumns(startDate, endDate);
    $('#'+element+'-'+data[level]+ ' .pickVsSalesHeader').append(dateHtml);
    $('#'+element+'-'+data[level]+ ' .pickVsSalesHeader').append(
        '<th class = "rowTotal">Totals</th>'
    );
}

function BuildDayColumns(startDate, endDate){
    var html;
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        html += '<th data-date="'+ moment(m).format('l') +'">' + moment(m).format('l') +'</th>';
    }
    return html;
}

function PopulateBasePickVsSalesTableByType(row, data, element, startDate, endDate, reportLevel){
    PickProjectionsPopulate(row, data, element, startDate, endDate, reportLevel);
    InTransitPopulate(row, data, element, startDate, endDate, reportLevel);
    SalesProjectionsPopulate(row, data, element, startDate, endDate, reportLevel);
    GuessSalesProjectionPopulate(row, data, element, startDate, endDate, reportLevel);
    RunningTotalPopulate(row, data, element, startDate, endDate, reportLevel);
}

function PickProjectionsPopulate(row, data, element, startDate, endDate, reportLevel){
    var total = 0;
    
    if(reportLevel == 'flowerVariety'){
        level = 'VARIETY';
        altLevel = 'FLOWERVARIETY'
    }else if(reportLevel == 'flowerColor'){
        level = 'COLORCODE';
    }
    
    // Build the static 
    $('#'+ element+'-'+data[level]+' .divisionProjections').append(
        '<tr id=picks-'+ element+'-'+data[level] +'>' +
            '<td>Picks</td>' +
            '<td></td>' +
            '<td></td>' +
        '</tr>'
    );
    
    // Loop through the pick data and populate each table while storing color grouping information
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.PICKPROJECTIONS.find(PICKPROJECTIONS => PICKPROJECTIONS.DIVISION == element && moment(PICKPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
        
        if(reportLevel == 'flowerVariety'){
            $('#picks-'+ element+'-'+data[level]).append(
                '<td class= drilldown '+
                    ' data-picks-date='+ moment(divisionData.DATEKEY).format('L') +
                    ' data-picks-division='+ element +
                    ' data-picks-totelStems='+ divisionData.TOTALPROJECTEDPICKSTEMS +'>'
                        + divisionData.TOTALPROJECTEDPICKSTEMS + 
                '</td>'
            );
            
            total = total + divisionData.TOTALPROJECTEDPICKSTEMS;
            
            // Check to see if the color already exists in the color summary and that color summary has 
            if(colorSummary.PICKPROJECTIONS.length > 0){
                var colorExists = colorSummary.PICKPROJECTIONS.find(colorInfo => colorInfo.DIVISION == element && moment(colorInfo.DATEKEY).format('L') == moment(m).format('L') && colorInfo.COLORCODE == data.COLORCODE.trim());
            }
            
            // *** NEED TO START GETTING COLOR SUMMARYS *****
            if(colorExists === undefined){
                var colorPickDetail = {};
                colorPickDetail.DATEKEY =  moment(divisionData.DATEKEY).format('L');
                colorPickDetail.DIVISION = element;
                colorPickDetail.DISPLAYDATE = moment(divisionData.DATEKEY).format('L');
                colorPickDetail.COLORCODE = data.COLORCODE.trim();
                colorPickDetail.COLOR_DESCRIPTION = data.COLOR_DESCRIPTION.trim();
                colorPickDetail.TOTALPROJECTEDPICKSTEMS = divisionData.TOTALPROJECTEDPICKSTEMS;
                colorSummary.PICKPROJECTIONS.push(colorPickDetail);
            }else{
                colorExists.TOTALPROJECTEDPICKSTEMS = colorExists.TOTALPROJECTEDPICKSTEMS + divisionData.TOTALPROJECTEDPICKSTEMS;
            }
        }else if(reportLevel == 'flowerColor'){
            // Populate the color summary
            var colorExists = colorSummary.PICKPROJECTIONS.find(colorInfo => colorInfo.DIVISION == element && moment(colorInfo.DATEKEY).format('L') == moment(m).format('L') && colorInfo.COLORCODE == data.COLORCODE);

            $('#picks-'+ element+'-'+data[level]).append(
                '<td class= drilldown '+
                    ' data-picks-date='+ moment(colorExists.DATEKEY).format('L') +
                    ' data-picks-division='+ element +
                    ' data-picks-totelStems='+ colorExists.TOTALPROJECTEDPICKSTEMS +'>'
                        + colorExists.TOTALPROJECTEDPICKSTEMS + 
                '</td>'
            );
            // Keep track of row total
            total = total + colorExists.TOTALPROJECTEDPICKSTEMS;
        } 
    }
    // Add total to the table
    $('#picks-'+ element+'-'+data[level]).append(
        '<td class= drilldown '+
            ' data-picks-division='+ element +
            ' data-picks-totelStems='+ total +'>'
                + total + 
        '</td>'
    ); 
}

function InTransitPopulate(row, data, element, startDate, endDate, reportLevel){
    var total = 0;
    if(reportLevel == 'flowerVariety'){
        level = 'VARIETY';
        altLevel = 'FLOWERVARIETY'
    }else if(reportLevel == 'flowerColor'){
        level = 'COLORCODE';
    }
    
    $('#'+ element+'-'+data[level] +' .divisionProjections' ).append(
        '<tr id= inTransit-'+ element+'-'+data[level] +'>' +
            '<td>In-Transit</td>' +
            '<td></td>' +
            '<td></td>' +
        '</tr>'  
    );
    // // Loop through the In Transit data and populate each table while storing color grouping information
    for (var m = moment(startDate); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.INTRANSITPROJECTIONS.find(INTRANSITPROJECTIONS => INTRANSITPROJECTIONS.DIVISION == element && moment(INTRANSITPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
        if(reportLevel == 'flowerVariety'){
            $('#inTransit-'+ element+'-'+data[level]).append(
                '<td class= drilldown '+ 
                    ' data-inTransit-date='+ moment(divisionData.DATEKEY).format('L') +
                    ' data-inTransit-division='+ element +
                    ' data-inTransit-totelStems='+ divisionData.TOTALPROJECTEDSTEMS +'>'
                        + divisionData.TOTALPROJECTEDSTEMS + 
                '</td>'
            );
            
            total = divisionData.TOTALPROJECTEDSTEMS + total;
            
            // Check to see if the color already exists in the color summary and that color summary has 
            if(colorSummary.INTRANSITPROJECTIONS.length > 0){
                var colorExists = colorSummary.INTRANSITPROJECTIONS.find(colorInfo => colorInfo.DIVISION == element && moment(colorInfo.DATEKEY).format('L') == moment(m).format('L') && colorInfo.COLORCODE == data.COLORCODE.trim());
            }
            
            // *** NEED TO START GETTING COLOR SUMMARYS *****
            if(colorExists === undefined){
                var colorInTransitDetail = {};
                colorInTransitDetail.DATEKEY =  moment(divisionData.DATEKEY).format('L');
                colorInTransitDetail.DIVISION = element;
                colorInTransitDetail.DISPLAYDATE = moment(divisionData.DATEKEY).format('L');
                colorInTransitDetail.COLORCODE = data.COLORCODE.trim();
                colorInTransitDetail.COLOR_DESCRIPTION = data.COLOR_DESCRIPTION.trim();
                colorInTransitDetail.TOTALPROJECTEDSTEMS = divisionData.TOTALPROJECTEDSTEMS;
                colorSummary.INTRANSITPROJECTIONS.push(colorInTransitDetail);
            }else{
                colorExists.TOTALPROJECTEDSTEMS = colorExists.TOTALPROJECTEDSTEMS + divisionData.TOTALPROJECTEDSTEMS;
            }
        }else if(reportLevel == 'flowerColor'){
            // Complete the color summary table
            var colorExists = colorSummary.INTRANSITPROJECTIONS.find(colorInfo => colorInfo.DIVISION == element && moment(colorInfo.DATEKEY).format('L') == moment(m).format('L') && colorInfo.COLORCODE == data.COLORCODE);
            $('#inTransit-'+ element+'-'+data[level]).append(
                '<td class= drilldown '+ 
                    ' data-inTransit-date='+ moment(colorExists.DATEKEY).format('L') +
                    ' data-inTransit-division='+ element +
                    ' data-inTransit-totelStems='+ colorExists.TOTALPROJECTEDSTEMS +'>'
                        + colorExists.TOTALPROJECTEDSTEMS + 
                '</td>'
            );
            
            total = divisionData.TOTALPROJECTEDSTEMS + total;
        }
    }
    // Add the total column
    $('#inTransit-'+ element+'-'+data[level]).append(
        '<td class= drilldown '+ 
            ' data-inTransit-division='+ element +
            ' data-inTransit-totelStems='+ total +'>'
                + total + 
        '</td>'
    );
}

function SalesProjectionsPopulate(row, data, element, startDate, endDate, reportLevel){
    var total = 0;
    
    if(reportLevel == 'flowerVariety'){
        level = 'VARIETY';
        altLevel = 'FLOWERVARIETY'
    }else if(reportLevel == 'flowerColor'){
        level = 'COLORCODE';
        altLevel = 'COLORCODE';
    }
    
    var dayBefore =  moment(startDate).subtract(1, 'd');
    
    $('#'+ element+'-'+data[level] +' .divisionProjections' ).append(
        '<tr id=sales-'+element+'-'+data[level]+'>' +
            '<td>Sales</td>' +
            '<td></td>' +
        '</tr>' 
    );
    
    // Loop through the sales data to populate the table while storing the color summary.  
    // ***********NOTE: Sales are a day before so a days sales is the next days.  EX: 1/3/2019 sales in table are for 1/4/2019  
    for (var m = moment(dayBefore); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(m).format('L'));
        if(reportLevel == 'flowerVariety'){
            $('#sales-'+ element+'-'+data[level]).append(
                '<td class= drilldown '+
                    'data-sales-date='+ moment(divisionData.DATEKEY).format('L') +
                    ' data-sales-division='+ element +
                    ' data-sales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                        + divisionData.TOTALPROJECTEDSALESSTEMS + 
                '</td>'
            );
            
            total = total + divisionData.TOTALPROJECTEDSALESSTEMS;
            
            // Check to see if the color already exists in the color summary and that color summary has 
            if(colorSummary.SALESPROJECTIONS.length > 0){
                var colorExists = colorSummary.SALESPROJECTIONS.find(colorInfo => colorInfo.DIVISION == element && moment(colorInfo.DISPLAYDATE).format('L') == moment(m).format('L') && colorInfo.COLORCODE == data.COLORCODE.trim());
            }
            // *** NEED TO START GETTING COLOR SUMMARYS *****
            if(colorExists === undefined){
                var colorSaleDetail = {};
                colorSaleDetail.DATEKEY =  moment(divisionData.DATEKEY).format('L');
                colorSaleDetail.DIVISION = element;
                colorSaleDetail.DISPLAYDATE = moment(divisionData.DISPLAYDATE).format('L');
                colorSaleDetail.COLORCODE = data.COLORCODE.trim();
                colorSaleDetail.COLOR_DESCRIPTION = data.COLOR_DESCRIPTION.trim();
                colorSaleDetail.TOTALPROJECTEDSALESSTEMS = divisionData.TOTALPROJECTEDSALESSTEMS;
                colorSummary.SALESPROJECTIONS.push(colorSaleDetail);
            }else{
                colorExists.TOTALPROJECTEDSALESSTEMS = colorExists.TOTALPROJECTEDSALESSTEMS + divisionData.TOTALPROJECTEDSALESSTEMS;
            }
        }else if(reportLevel == 'flowerColor'){
            var colorExists = colorSummary.SALESPROJECTIONS.find(colorInfo => colorInfo.DIVISION == element && moment(colorInfo.DISPLAYDATE).format('L') == moment(m).format('L') && colorInfo.COLORCODE == data.COLORCODE.trim());
            $('#sales-'+ element+'-'+data[level]).append(
                '<td class= drilldown '+
                    'data-sales-date='+ moment(colorExists.DATEKEY).format('L') +
                    ' data-sales-division='+ element +
                    // ' data-sales-type='+ divisionData.FLOWERVARIETY+
                    ' data-sales-totelStems='+ colorExists.TOTALPROJECTEDSALESSTEMS +'>'
                        + colorExists.TOTALPROJECTEDSALESSTEMS + 
                '</td>'
            );
            
            total = total + colorExists.TOTALPROJECTEDSALESSTEMS;
        }    
    }
    // Add total column
    $('#sales-'+ element+'-'+data[level]).append(
        '<td class= drilldown '+
            ' data-sales-division='+ element +
            ' data-sales-totelStems='+ total +'>'
                + total + 
        '</td>'
    );  
}

function GuessSalesProjectionPopulate(row, data, element, startDate, endDate, reportLevel){
    var total = 0;
    
    if(reportLevel == 'flowerVariety'){
        level = 'VARIETY';
        altLevel = 'FLOWERVARIETY'
    }else if(reportLevel == 'flowerColor'){
        level = 'COLORCODE';
        altLevel = 'COLORCODE';
    }
    
    var dayBefore =  moment(startDate).subtract(1, 'd');
    
    $('#'+ element+'-'+data[level] +' .divisionProjections' ).append(
        '<tr id=guessSales-'+element+'-'+data[level]+'>' +
            '<td>Guess</td>' +
            '<td></td>' +
        '</tr>' 
    );
    

    // Loop through the rest of the sales data to populate the rest of the days table
    for (var m = moment(dayBefore); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
        var divisionData = data.GUESSSALEPROJECTIONS.find(GUESSSALEPROJECTIONS => GUESSSALEPROJECTIONS.DIVISION == element && moment(GUESSSALEPROJECTIONS.DISPLAYDATE).format('L') == moment(m).format('L'));
        if(reportLevel == 'flowerVariety'){
            $('#guessSales-'+ element+'-'+data.VARIETY).append(
                '<td class= drilldown '+
                    ' data-guessSales-date='+ moment(divisionData.DATEKEY).format('L') +
                    ' data-guessSales-division='+ element +
                    ' data-guessSales-totelStems='+ divisionData.TOTALPROJECTEDSALESSTEMS +'>'
                        + divisionData.TOTALPROJECTEDSALESSTEMS + 
                '</td>'
            );
            
            // sum up total
            total = divisionData.TOTALPROJECTEDSALESSTEMS + total;
            
            // Check to see if the color already exists in the color summary and that color summary has 
            if(colorSummary.GUESSSALEPROJECTIONS.length > 0){
                var colorExists = colorSummary.GUESSSALEPROJECTIONS.find(colorInfo => colorInfo.DIVISION == element && moment(colorInfo.DISPLAYDATE).format('L') == moment(m).format('L') && colorInfo.COLORCODE == data.COLORCODE.trim());
            }
            // *** NEED TO START GETTING COLOR SUMMARYS *****
            if(colorExists === undefined){
                var colorGuessSaleDetail = {};
                colorGuessSaleDetail.DATEKEY =  moment(divisionData.DATEKEY).format('L');
                colorGuessSaleDetail.DIVISION = element;
                colorGuessSaleDetail.DISPLAYDATE = moment(divisionData.DISPLAYDATE).format('L');
                colorGuessSaleDetail.COLORCODE = data.COLORCODE.trim();
                colorGuessSaleDetail.COLOR_DESCRIPTION = data.COLOR_DESCRIPTION.trim();
                colorGuessSaleDetail.TOTALPROJECTEDSALESSTEMS = divisionData.TOTALPROJECTEDSALESSTEMS;
                colorSummary.GUESSSALEPROJECTIONS.push(colorGuessSaleDetail);
            }else{
                colorExists.TOTALPROJECTEDSALESSTEMS = colorExists.TOTALPROJECTEDSALESSTEMS + divisionData.TOTALPROJECTEDSALESSTEMS;
            }
            
        }else if(reportLevel == 'flowerColor'){
            var colorExists = colorSummary.GUESSSALEPROJECTIONS.find(colorInfo => colorInfo.DIVISION == element && moment(colorInfo.DISPLAYDATE).format('L') == moment(m).format('L') && colorInfo.COLORCODE == data.COLORCODE.trim());
            $('#guessSales-'+ element+'-'+data[level]).append(
                '<td class= drilldown '+
                    ' data-guessSales-date='+ moment(colorExists.DATEKEY).format('L') +
                    ' data-guessSales-division='+ element +
                    ' data-guessSales-totelStems='+ colorExists.TOTALPROJECTEDSALESSTEMS +'>'
                        + colorExists.TOTALPROJECTEDSALESSTEMS + 
                '</td>'
            );
            // sum up total
            total = colorExists.TOTALPROJECTEDSALESSTEMS + total;
        }
    }
    // Add Total
    $('#guessSales-'+ element+'-'+data[level]).append(
        '<td class= drilldown '+
            ' data-guessSales-division='+ element +
            ' data-guessSales-totelStems='+ total +'>'
                + total + 
        '</td>'
    );
}

function RunningTotalPopulate(row, data, element, startDate, endDate, reportLevel){
    if(reportLevel == 'flowerVariety'){
        level = 'VARIETY';
        altLevel = 'FLOWERVARIETY'
    }else if(reportLevel == 'flowerColor'){
        level = 'COLORCODE';
        altLevel = 'COLORCODE';
    }
    
    // Static label
    var runningTotal = data.STARTINGINVENTORY.find(STARTINGINVENTORY => STARTINGINVENTORY.DIVISION == element);
    $('#'+ element+'-'+data[level] +' .divisionProjectionsTotal' ).append(
        '<tr class = "table-info" '+ 
            ' id=runningTotal-'+element+'-'+runningTotal[level]+'>' +
                '<td class = "font-weight-bold">' 
                    + 'Running Total' +
                '</td>' +
        '</tr>'
    );
    
    // Variable to check for no data
    var noData = false;
    // Set day before variable for sales
    var dayBefore =  moment(startDate).subtract(1, 'days').format('L');
    
    
    if(reportLevel == 'flowerVariety'){
        // Starting Inventory
        $('#runningTotal-'+element+'-'+runningTotal[level]).append(
            '<td class = "font-weight-bold"'+
                ' id = runningTotal-'+element+'-'+moment(dayBefore).subtract(1, 'days').unix()+'-'+runningTotal[level] +
                ' data-runningTotal-division='+ element +
                ' data-runningTotal-type='+ runningTotal[level]+
                ' data-runningTotal-totelStems='+ runningTotal.TOTAL +'>'
                    + runningTotal.TOTAL +
            '</td>'
        );
        
        // Need to start summing up the starting Inventory for each color
        // Check to see if the color already exists in the color summary and that color summary has 
        if(colorSummary.STARTINGINVENTORY.length > 0){
            var colorExists = colorSummary.STARTINGINVENTORY.find(colorInfo => colorInfo.DIVISION == element && colorInfo.COLORCODE == data.COLORCODE.trim() && moment(colorInfo.DATEKEY).format('L') == moment(dayBefore).subtract(1, 'days').format('L'));
        }
        // *** NEED TO START GETTING COLOR SUMMARYS *****
        if(colorExists === undefined){
            var colorRunningTotalDetail = {};
            colorRunningTotalDetail.DIVISION = element;
            colorRunningTotalDetail.COLORCODE = data.COLORCODE.trim();
            colorRunningTotalDetail.COLOR_DESCRIPTION = data.COLOR_DESCRIPTION.trim();
            colorRunningTotalDetail.TOTAL = runningTotal.TOTAL;
            colorRunningTotalDetail.DATEKEY = moment(dayBefore).subtract(1, 'days').format('L');
            colorSummary.STARTINGINVENTORY.push(colorRunningTotalDetail);
        }else{
            colorExists.TOTAL = colorExists.TOTAL + runningTotal.TOTAL;
        }
    
        //Loop through day columns
        for (var m = moment(dayBefore); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
            var dayBeforeTotal =  moment(m).subtract(1, 'd').format('L');
    
            // Guess Sales are included in Sales
            var sales = data.SALESPROJECTIONS.find(SALESPROJECTIONS => SALESPROJECTIONS.DIVISION == element && moment(SALESPROJECTIONS.DISPLAYDATE).format('L') == moment(m).format('L'));
    
            var inTransit = data.INTRANSITPROJECTIONS.find(INTRANSITPROJECTIONS => INTRANSITPROJECTIONS.DIVISION == element && moment(INTRANSITPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
    
            var pickProjections = data.PICKPROJECTIONS.find(PICKPROJECTIONS => PICKPROJECTIONS.DIVISION == element && moment(PICKPROJECTIONS.DATEKEY).format('L') == moment(m).format('L'));
            
            var previousTotalStems = $("#runningTotal-"+element+"-"+moment(dayBeforeTotal).unix()+"-"+runningTotal[level]).html();
            
            if(inTransit === undefined){
                inTransitRunning = 0;
            }else{
                inTransitRunning = inTransit.TOTALPROJECTEDSTEMS;
            }
            
            if(pickProjections === undefined){
                pickRunning = 0;
            }else{
                pickRunning = pickProjections.TOTALPROJECTEDPICKSTEMS;
            }
            
            totalStems = previousTotalStems - sales.TOTALPROJECTEDSALESSTEMS + inTransitRunning + pickRunning;
            
            // Check to see if the color already exists in the color summary and that color summary has 
            if(colorSummary.STARTINGINVENTORY.length > 0){
                var colorExists = colorSummary.STARTINGINVENTORY.find(colorInfo => colorInfo.DIVISION == element && colorInfo.COLORCODE == data.COLORCODE.trim() && moment(colorInfo.DATEKEY).format('L') == moment(m).format('L'));
            }
            // *** NEED TO START GETTING COLOR SUMMARYS *****
            if(colorExists === undefined){
                var colorRunningTotalDetail = {};
                colorRunningTotalDetail.DIVISION = element;
                colorRunningTotalDetail.COLORCODE = data.COLORCODE.trim();
                colorRunningTotalDetail.COLOR_DESCRIPTION = data.COLOR_DESCRIPTION.trim();
                colorRunningTotalDetail.TOTAL = totalStems;
                colorRunningTotalDetail.DATEKEY = moment(m).format('L') ;
                colorSummary.STARTINGINVENTORY.push(colorRunningTotalDetail);
            }else{
                colorExists.TOTAL = colorExists.TOTAL + totalStems;
            }
        
            
            if(totalStems == 0){
                noData = true;
            }else{
                noData = false;
            }
    
            $('#runningTotal-'+element+'-'+runningTotal[level]).append(
                '<td class = "font-weight-bold"'+
                    ' id = runningTotal-'+element+'-'+moment(m).unix()+'-'+runningTotal[level]+'>'
                        + totalStems +
                '</td>'
            );
        }
        
        // Table clean up function
        if(noData == true){
            $('.collapse-'+element+'-'+runningTotal[level]).collapse({
                hide: true
            });
        }
    
        $('tr#runningTotal-'+element+'-'+runningTotal[level]).find('td').each(function(){
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
    }else if (reportLevel == 'flowerColor'){
        for (var m = moment(dayBefore).subtract(1, 'days'); m.diff(endDate, 'days') <= 0; m.add(1, 'days')) {
            var colorExists = colorSummary.STARTINGINVENTORY.find(colorInfo => colorInfo.DIVISION == element && colorInfo.COLORCODE.trim() == data.COLORCODE.trim() && moment(colorInfo.DATEKEY).format('L') == moment(m).format('L'));

            // Starting Inventory
            $('#runningTotal-'+element+'-'+colorExists[level]).append(
                '<td class = "font-weight-bold"'+
                    ' id = runningTotal-'+element+'-'+moment(m).unix()+'-'+colorExists[level] +
                    ' data-runningTotal-division='+ element +
                    ' data-runningTotal-type='+ colorExists[level]+
                    ' data-runningTotal-totelStems='+ colorExists.TOTAL +'>'
                        + colorExists.TOTAL +
                '</td>'
            );
            
            if(colorExists.TOTAL == 0){
                noData = true;
            }else{
                noData = false;
            }
        }
        // Run formatting on the color heads
        if(noData == true){
            $('.collapse-'+element+'-'+runningTotal[level]).collapse({
                hide: true
            });
        }
    
        $('tr#runningTotal-'+element+'-'+runningTotal[level]).find('td').each(function(){
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
    $('#runningTotal-'+element+'-'+data[level]).append(
        '<td class = "font-weight-bold"'+
        '</td>'
    );
}

function PopulateScrollSpySearchVariety(data){
    $.each(data, function(index, element){
        $('#scrollJump-select')
            .append($("<option value ="+element.VARIETY+">" + element.VARIETY_NAME + "-" + element.VARIETY + "</option>"));
    });
}

function PopulateScrollSpySearchColor(data){
    var colors = CreateUniqueColorObjectForSearch(data);
    $.each(colors, function(index, element){
        $('#scrollJump-select')
            .append($("<option value ="+element.COLORCODE+">" + element.COLOR_DESCRIPTION + "-" + element.COLORCODE + "</option>"));
    });
}
