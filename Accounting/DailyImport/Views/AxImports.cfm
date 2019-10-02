<!---
  Orginization Name: The Sun Valley Group, Inc.
  File Name: 
  Purpose: 
  Accessed from: 
  Author: TC Maiero
  Date:
  Modifications by:
  Modified on: 
  Modification details:
--->


<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Axapta Import</title>
<cfset isBootStrap="YES">

<!--- TCM  - Main Header  --->
<cfinclude template="/MM/MainHeader.cfm">
<cfsetting showDebugOutput = "yes">
    
<!--- TC - StyleSheets --->
<link rel ="stylesheet" type="text/css" href="/MM/js/lib/jquery/jquery-ui/jquery-ui.min.css">
<link rel = "stylesheet" type="text/css" href="/MM/js/lib/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" text="text/css" href="/MM/js/lib/DataTables/datatables.min.css" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">    
<link rel="stylesheet" text="text/css" href="/MM/Accounting/DailyImport/css/AxImports.css" />


<div class = "container-fluid">
    <div class = "row">
        <div class = "col">
            <h2 class="text-left page-title page-title-min-bot">Axapta Import Tool</h2>
        </div>
    </div>
    <div class = "row">
        <div class = "col">
            <div class="alert alert-primary" role="alert">
                For use instructions click <a class="invoice-import-instructions"  href="UserInstructions/AxInvoiceImportInstructions.cfm" rel="noopener noreferrer" target="_blank">HERE</a>
            </div>
        </div>
    </div>
</div>

<!--- TCM -Invoice Import --->
<div class = "container-fluid">
    <div class = "row col-sm-12">
        <div class = "col-sm-5">
            <h4 class="text-left">Axapta Daily Invoice Import</h2>
        </div>
        <div class = "col-sm-4 offset-sm-1">
            <h4 class="text-left">Axapta Customer Import</h2>
        </div>
    </div>
    <div class ="row col-sm-12">
        <!--- TC - Invoice Import Input --->
        <span class = "col-sm-3">
            <div class="input-group mb-3 min-input-group-custom">
                <div class="input-group-prepend">
                    <span class="input-group-text" id="basic-addon1">Date</span>
                </div>
                <input class = "import-date form-control min-input-custom" type="date" name="startDate" />
            </div>
        </span>
        <span class = "col-sm-1">
            <input class="form-check-input" type="checkbox" id="lateFeeOnly">
            <label class="form-check-label" for="lateFeeOnly">
                Late Fee's Only
            </label>
        </span>
        <span class = "col-sm-1">
            <button class = "btn btn-primary validate-axImport" name="getLineLoss" id="validate-ax-import">
                Submit    
            </button>
        </span>
        <!--- TC - END Invoice Import input --->
        
        <!--- TC - Customer Import Input --->
        <span class = "col-sm-3 offset-sm-1">
            <div class="input-group mb-3 min-input-group">
                <div class="input-group-prepend ">
                    <span class="input-group-text" id="basic-addon1">Customer</span>
                </div>
                <input class = "import-date form-control date-input-width-custom min-input" type="text" name="customerNumber" id="theCustomerNumber"/>
            </div>
        </span>
        <span class = "col-sm-1">
            <button class = "btn btn-primary get-customer-info" name="getLineLoss" id="validate-ax-import">
                Submit    
            </button>
        </span>
        <!--- TC - End Customer Import input --->
    </div>
</div>

<div class="container-fluid" id="validation-response">
</div>

<div class="container table-container" id="import-data">
    <table id = "axImport" class = "display" width = "100%">
    </table>
</div>

<div class="container table-container" id="customer-import-data">
    <table id = "axCustomerImport"  class="display" width="100%">
    </table>
</div>

<!--- TCM - Customer Import --->
<!--- TC - <div class = "container-fluid">
    <div class = "row">
        <div class = "col">
            <h4 class="text-left">Axapta Customer Import</h2>
        </div>
    </div>
    <div class ="row">
        
    </div>
</div> --->

<cfinclude template="/MM/MainFooter.cfm">
<footer>
    <!--- TCM - Need Both Jquery things to work --->
    <script src="/MM/js/lib/jquery/jquery.min.js"></script>
    <script src="/MM/js/lib/jquery/jquery-ui/jquery-ui.min.js"></script>
    
    <!--- TC - Bootstrap --->
    <script src="/MM/js/lib/bootstrap/js/bootstrap.min.js"></script>
    
    <!--- TC - DataTables --->
    <script src= "/MM/js/lib/DataTables/datatables.min.js"></script>
    <script src= "/MM/js/lib/DataTables/Buttons-1.5.6/js/dataTables.buttons.min.js"></script>
    <script src= "/MM/js/lib/DataTables/Buttons-1.5.6/js/buttons.flash.min.js"></script>
    <script src= "/MM/js/lib/DataTables/Buttons-1.5.6/js/buttons.print.min.js"></script>
    <script src= "/MM/js/lib/DataTables/Buttons-1.5.6/js/buttons.html5.min.js"></script>
    
    <!--- TC - MomentJs --->
    <script src="/MM/js/lib/Moment/Moment.min.js"></script>
    <!--- TC - Page Specific JS --->
    <script src="/MM/Accounting/DailyImport/js/AxImports.js"></script>
</footer>
