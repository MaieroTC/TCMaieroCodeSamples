
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Projections-PicksvsSales - Order Drill Down</title>
<cfset isBootStrap="YES">
<!--- <cfinclude template="/MM/include_CheckAuthority.cfm"> --->
<cfsetting showdebugoutput="YES">

<link rel = "stylesheet" type="text/css" href="/MM/js/lib/jquery-ui-1.11.4.custom/jquery-ui.min.css">
<link rel = "stylesheet" type="text/css" href="/MM/js/lib/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" text="text/css" href="/MM/DataTables-1.10.18/datatables.min.css" />
<link rel = "stylesheet" type="text/css" href = "/MM/js/lib/jquery-loading-master/dist/jquery.loading.min.css" />
<link rel="stylesheet" href="/MM/PickProjectionsVsSales/css/PicksVsSalesProjections.css">
    
<!--- TC - Boot Strap Studio Start. --->
<div style="padding: 10px;">
    <div class="row">
        <div class="col">
            <h1 class="text-left title">Projections - Picks vs Sales - Order Drill Down</h1>
        </div>
    </div>
</div>

<div id="tableData">
    <table id = "orderInfo" class = "display" width = "90%">
</div>

<footer>
    <!--- TCM - Need Both Jquery things to work --->
    <script src="/MM/js/lib/jquery-1.11.3.min.js"></script>
    <script src="/MM/js/lib/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
    <script src="/MM/js/lib/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!--- TC - Data Table --->
    <script src= "/MM/DataTables-1.10.18/datatables.min.js"></script>
    <script src= "/MM/DataTables-1.10.18/RowGroup-1.1.0/js/dataTables.rowGroup.min.js"></script>
    <script src= "/MM/DataTables-1.10.18/RowGroup-1.1.0/js/rowGroup.jqueryui.min.js"></script>
    <script src= "/MM/DataTables-1.10.18/Buttons-1.5.2/js/dataTables.buttons.min.js"></script>
    <script src= "/MM/DataTables-1.10.18/Buttons-1.5.2/js/buttons.flash.min.js"></script>
    <script src= "/MM/DataTables-1.10.18/Buttons-1.5.2/js/buttons.print.min.js"></script>
    <script src= "/MM/DataTables-1.10.18/Buttons-1.5.2/js/buttons.html5.min.js"></script>
    
    <!--- TC - MomentJs --->
    <script src="/MM/js/lib/Moment/Moment.min.js"></script>
    <script src = "/MM/js/lib/Moment/DataTableMomentPlugIn.js"></script>
    <!--- TC - Loading Overlay --->
    <script src="/MM/js/lib/jquery-loading-master/dist/jquery.loading.min.js"></script>
    <!--- TC - Custom Javascript pages and css pages --->
    <script type="text/javascript" src = "/MM/PickProjectionsVsSales/js/PickvsSalesProjectionsOrder.js"></script>
</footer>
