<!---
  Orginization Name: The Sun Valley Group, Inc.
  File Name: AxInvoiceImportInstructions
  Purpose: 
  Accessed from: 
  Author: TC Maiero
  Date:
  Modifications by:
  Modified on: 
  Modification details:
--->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>Axapta Invoice Import Instructions</title>
    <cfset isBootStrap="YES">
    
    <!--- TCM  - Main Header  --->
    <cfsetting showDebugOutput = "no">
    <cfinclude template="/MM/include_CheckAuthority.cfm">
        
    <!--- TC - StyleSheets --->
    <link rel ="stylesheet" type="text/css" href="/MM/js/lib/jquery/jquery-ui/jquery-ui.min.css">
    <link rel = "stylesheet" type="text/css" href="/MM/js/lib/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" text="text/css" href="/MM/Accounting/DailyImport/css/AxImportsInstructions.css" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">    
    <!--- TCM - End Jquery inserts ---> 
</head>    
<body>
    <div class = "container-fluid">
        <div class = "row">
            <div class = "col">
                <h2 class="text-left page-title">Axapta Import Guide</h2>
            </div>
        </div>
        <div class = "row">
            <p class="intro">
                These guides will explain how to use the Famnet Axapta export/import tool for customers, invocies and late fees.  This tool will not work in Internet Explorer but should work in any other browser.  If you have issues with browsers other than Internet Explorer please let HelpDesk@tsvg.com know.
            </p>
        </div>
    </div>
    <!--- TC - **************Late Fee and Invoice IMPORT ************************************** --->
    <div class = "container-fluid">
        <div class = "row">
            <div class = "col">
                <h3 class="text-left page-title">Axapta Invoice/Late Fee Import Instructions</h3>
            </div>
        </div>
        <div class = "row">
            <ol type="1">
                <li>
                    <p>
                        Enter the date you want to see in the input box under 'Axapta Daily Invoice Import' and click on submit
                        <figure class="figure">
                            <img src="Images/AxInvoiceImportInstructions_DateEntry.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Date Entry</figcaption>
                        </figure>
                    </p>
                    <ul>
                        <li>
                            <p>
                                For late fees only check the box that says <strong>Late Fee's Only</strong>
                                <figure class="figure">
                                    <img src="Images/AxInvoiceImportInstructions_DateEntryLateFee.jpg" class="figure-img img-fluid rounded" alt="...">
                                    <figcaption class="figure-caption">Date Entry - Late Fee</figcaption>
                                </figure>
                            </p>
                        </li>
                    </ul>
                </li>
                <li>
                    <p>
                        After data has loaded there will be validation messages that either say the process has succeeded or not.  If you see the error message please contact development@tsvg.com.
                        <figure class="figure">
                            <img src="Images/AxInvoiceImportInstructions_SuccesfulRun.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Successful Run</figcaption>
                        </figure>
                        <figure class="figure">
                            <img src="Images/AxInvoiceImportInstructions_FailedRun1.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Failed Run</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        Once data has loaded succesfully, please press the button in the upper left hand of the data labeled <strong>CSV</strong>.<strong> DO NOT OPEN THIE FILE.  OPENING THE FILE IN EXCEL COULD MESS UP SKU'S AND GET RID OF LEADING ZEROS.</strong>
                        <figure class="figure">
                            <img src="Images/AxInvoiceImportInstructions_CSVExport.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Export to CSV</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        The file will be in your downloads folder.  Move this file to the appropriate storage area. Open Axapta and go to the 'Accounts Receivable' section.  Under the periodic section you will see a option called, 'Free Text Invoice Import'.  Click it.
                        <figure class="figure">
                            <img src="Images/AxInvoiceImportInstructions_AxaptaFreeTextImport.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Axapta Menus</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        A box will appear and ask you to provide the import file.  Navigate to where the file is stored and click open.
                        <figure class="figure">
                            <img src="Images/AxInvoiceImportInstructions_AxaptaFreeTextImportDialog.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Axapta Import Screen</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        Click Ok when you are ready for the import. <strong>Note: </strong>Only click once.  There is very little feedback but if you clicked ok the invoices should be processing.
                        <figure class="figure">
                            <img src="Images/AxInvoiceImportInstructions_AxaptaFreeTextImportReadyToImport.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Axapta Import Screen</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        The import usually takes between 3-10 minutes depanding on the number of invocies.  After the process has been completed a dialog box will appear that displays the results and if there are any errors.  The most common error we see is a customer does not exist in Axapta.  If this is the case please read the instructions below to import the customer into axapta.  Once you have completed that re-import the same Invoice file.  Don't worry, Axapta does not import invoices that already exist. 
                        <figure class="figure">
                            <img src="Images/AxInvoiceImportInstructions_AxaptaFreeTextImportInvoiceExists.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Invoice Exists</figcaption>
                        </figure>
                    </p>
                </li>
            </ol>
        </div>
    </div>
    <!--- TC - **************CUSTOMER IMPORT ************************************** --->
    <div class = "container-fluid">
        <div class = "row">
            <div class = "col">
                <h3 class="text-left page-title">Customer Import</h3>
            </div>
        </div>
        <div class = "row">
            <div class = "col">
                <h4 class="text-left page-title">Customer Import On Invoice Import</h4>
            </div>
        </div>
        <div class="row">
            <ol type="1">
                <li>
                    <p>
                        If a customer does not exist when a invoice is imported, Axapta will throw an error when the import occurs.  Scroll down to the bottom of the alert dialog and it should show the invoice that were problematic.
                    </p>
                </li>
                <li>
                    <p>
                        In Farmnet, in the upper right hand corner of the table created for the Axapta Daily Invoice Import there is a serch box.  Search for the problematic invoice(s) one at a time.
                        <figure class="figure">
                            <img src="Images/AxCustomerImport_FromInvoice.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Search for customer number by Invoice</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        Copy that number and paste it into the Customer import field and follow the steps to import a customer below.  After that re-import the invoices.
                        <figure class="figure">
                            <img src="Images/AxCustomerImport_FromInvoice.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Search for customer number by Invoice</figcaption>
                        </figure>
                    </p>
                </li>
            </ol>
        </div>
        <div class = "row">
            <div class = "col">
                <h4 class="text-left page-title">Customer Import</h4>
            </div>
        </div>
        <div class = "row">
            <ol type="1">
                <li>
                    <p>
                        Enter the customer number for the customer you need to import under Axapta Customer Import and click submit.
                        <figure class="figure">
                            <img src="Images/AxCustomerImport_EnterCustomer.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Customer Number Import</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        If the customer exists the customer information will populate in the table below.  If it does not exist the table will show the message, "No Data to Display"
                        <figure class="figure">
                            <img src="Images/AxCustomerImport_CustomerInfo.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Customer Information</figcaption>
                        </figure>
                        <figure class="figure">
                            <img src="Images/AxCustomerImport_NoCustomerInfo.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Customer Not Found</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        When the customer information is displayed, press the CSV button in the upper left hand corner of the table.  The file will be downloaded to your downloads folder on your PC.  Move it to the correct storage folder.
                        <figure class="figure">
                            <img src="Images/AxCustomerImport_CustomerInfoExport.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Export Customer Information</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        Open Axapta and navigate to the Accounts Receivable area.  Under Periodic there will be a option labeled <strong>Customer Import</strong>.  Click that.
                        <figure class="figure">
                            <img src="Images/AxCustomerImport_AxaptaCustomerImport.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Axapta Customer Import</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        This will open a dialog that asks for a file.  Click on the file icon and point to the correct file and click ok to import.
                        <div class="alert alert-danger" role="alert">
                            WARNING!!!! MAKE YOU HAVE THE CORRECT FILE.  AXAPTA DOES NO CHECK THE EXISTENCE OF THE CUSTOMER AND WILL CHANGE CUSTOMER INFORMATION SUCH AS DIMENSION.
                        </div>
                        <figure class="figure">
                            <img src="Images/AxCustomerImport_AxaptaCustomerImportDialog.jpg" class="figure-img img-fluid rounded" alt="...">
                            <figcaption class="figure-caption">Axapta Customer Import Dialog</figcaption>
                        </figure>
                    </p>
                </li>
                <li>
                    <p>
                        Unfortunatly, there is no dialog that displays the import was succesful or not but the best way to check is to just search for the customer in Axapta.
                        <div class="alert alert-warning" role="alert">
                            If the customer is Canadian make sure to switch the Customer Group to WCAD and Dimension Entity to 95 before any invoices are imported against that customer.
                        </div>
                        <div class="row">
                            <figure class="figure">
                                <img src="Images/AxCustomerImport_AxaptaCustomerImportDialog.jpg" class="figure-img img-fluid rounded" alt="...">
                                <figcaption class="figure-caption">Change to WCAD</figcaption>
                            </figure> 
                        </div>
                        <div class="row">
                            <figure class="figure">
                                <img src="Images/AxCustomerImport_AxaptaCustomerImportEntity.jpg" class="figure-img img-fluid rounded" alt="...">
                                <figcaption class="figure-caption">Dimension to 95</figcaption>
                            </figure> 
                        </div>
                    </p>
                </li>
            </ol>
        </div>
    </div>
</body>
<footer>
    <!--- TCM - Need Both Jquery things to work --->
    <script src="/MM/js/lib/jquery/jquery.min.js"></script>
    <script src="/MM/js/lib/jquery/jquery-ui/jquery-ui.min.js"></script>
    
    <!--- TC - Bootstrap --->
    <script src="/MM/js/lib/bootstrap/js/bootstrap.min.js"></script>
</footer>
