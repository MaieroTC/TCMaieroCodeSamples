
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Projections-PicksvsSales</title>
<cfset isBootStrap="YES">
<!--- TC - <cfinclude template="/MM/include_CheckAuthority.cfm"> --->
<cfsetting showdebugoutput="YES">
<link rel = "stylesheet" type="text/css" href="/MM/js/lib/jquery-ui-1.11.4.custom/jquery-ui.min.css">
<link rel = "stylesheet" type="text/css" href="/MM/js/lib/bootstrap/css/bootstrap.min.css" />
<link rel = "stylesheet" type="text/css" href = "/MM/js/lib/jquery-loading-master/dist/jquery.loading.min.css" />
<link rel="stylesheet" href="/MM/PickProjectionsVsSales/css/PicksVsSalesProjections.css">
<!--- TC -Font awesome  --->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
    
<!--- TC - Boot Strap Studio Start. --->
<div class = 'sticky-top get-height' style="padding: 10px;">
    <div class="row">
        <div class="col">
            <h1 class="text-left title">Projections - Picks vs Sales</h1>
        </div>
    </div>
    <div class="row">
        <div class="col">
        </div>
        <div class="col med-pad-right input-search">
            <div class="input-group">
                <div class="input-group-prepend">
                    <label class="input-group-text" for="inputGroupSelect01">Jump To:</label>
                </div>
                <select class="custom-select" id="scrollJump-select">
                    <option>
                        Please Run Report to Use this feature
                    </option>
                </select>
                <div class="input-group-append">
                    <button id = "scrollJump" class="btn btn-outline-secondary" type="button">Go</button>
                </div>
            </div>
        </div>
    </div>
</div>
<div class= "picksVsSaleProjection-div">
</div>
<footer>
    <!--- TCM - Need Both Jquery things to work --->
    <script src="/MM/js/lib/jquery-1.11.3.min.js"></script>
    <script src="/MM/js/lib/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
    <script src="/MM/js/lib/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!--- TC - MomentJs --->
    <script src="/MM/js/lib/Moment/Moment.min.js"></script>
    <!--- TC - Loading Overlay --->
    <script src="/MM/js/lib/jquery-loading-master/dist/jquery.loading.min.js"></script>
    <!--- TC - Custom Javascript pages and css pages --->
    <!--- TC - <script type="text/javascript" src = "/MM/PickProjectionsVsSales/js/PickvsSalesProjectionsColorVariety.js"></script> --->
    <script type="text/javascript" src = "/MM/PickProjectionsVsSales/js/min/PickvsSalesProjectionsColorVariety.min.js"></script>
</footer>
