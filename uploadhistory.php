<?php
// uploadhistory.php
// Validates form data from pages/history.html and writes a file for the Matlab 
// script file_scanner_mcmc_starter.m to read as input for the MCMC inversion.

//$missing_fields = ''; // string of missing field names
$missing_fields = array(); // array of missing field names
//die('"' . $_POST['sample_id'] . '", ' . isset($_POST['sample_id']));

// Check required fields if not set or blank, one by one
if (!isset($_POST['sample_id']) || $_POST['sample_id'] == '') {
    array_push($missing_fields, 'Sample ID');
}
if (!isset($_POST['your_name']) || $_POST['your_name'] == '') {
    array_push($missing_fields, 'Your Name');
}
if (!isset($_POST['email']) || $_POST['email'] == '') {
    array_push($missing_fields, 'Email');
}
if (!isset($_POST['lat']) || $_POST['lat'] == '') {
    array_push($missing_fields, 'Latitude');
}
if (!isset($_POST['long']) || $_POST['long'] == '') {
    array_push($missing_fields, 'Longitude');
}
if (!isset($_POST['rock_density']) || $_POST['rock_density'] == '') {
    array_push($missing_fields, 'Rock density');
}
if (!isset($_POST['epsilon_gla_min']) || $_POST['epsilon_gla_min'] == '') {
    array_push($missing_fields, 'Min. glacial erosion rate');
}
if (!isset($_POST['epsilon_gla_max']) || $_POST['epsilon_gla_max'] == '') {
    array_push($missing_fields, 'Max. glacial erosion rate');
}
if (!isset($_POST['epsilon_int_min']) || $_POST['epsilon_int_min'] == '') {
    array_push($missing_fields, 'Min. inter-glacial erosion rate');
}
if (!isset($_POST['epsilon_int_max']) || $_POST['epsilon_int_max'] == '') {
    array_push($missing_fields, 'Max. inter-glacial erosion rate');
}
if (!isset($_POST['t_degla']) || $_POST['t_degla'] == '') {
    array_push($missing_fields, 'Time since deglaciation');
}
if (!isset($_POST['d18O_threshold_min']) || $_POST['d18O_threshold_min'] == ''){
    array_push($missing_fields, 'Min. &delta;<sup>18</sup>O threshold value');
}
if (!isset($_POST['d18O_threshold_max']) || $_POST['d18O_threshold_max'] == ''){
    array_push($missing_fields, 'Max. &delta;<sup>18</sup>O threshold value');
}

// Check TCN concentrations, at least one value is needed
if ((!isset($_POST['conc_10Be']) || $_POST['conc_10Be'] == '') &&
    (!isset($_POST['conc_26Al']) || $_POST['conc_26Al'] == '') &&
    (!isset($_POST['conc_14C'])  || $_POST['conc_14C'] == '') &&
    (!isset($_POST['conc_21Ne']) || $_POST['conc_21Ne']) == '') {
        array_push($missing_fields, 'at least 1 TCN concentration');
}

// For each isotope concentration there should be uncertainty and production 
// rate
if ((isset($_POST['conc_10Be']) && $_POST['conc_10Be'] != '') &&
    (!isset($_POST['prod_10Be']) || $_POST['prod_10Be'] == '' ||
    !isset($_POST['uncer_10Be']) || $_POST['uncer_10Be'] == '')) {
        array_push($missing_fields, 'Production rate and/or uncertainty for ' .
        '<sup>10</sup>Be');
}
if ((isset($_POST['conc_26Al']) && $_POST['conc_26Al'] != '') &&
    (!isset($_POST['prod_26Al']) || $_POST['prod_26Al'] == '' ||
    !isset($_POST['uncer_26Al']) || $_POST['uncer_26Al'] == '')) {
        array_push($missing_fields, 'Production rate and/or uncertainty for ' .
        '<sup>26</sup>Al');
}
if ((isset($_POST['conc_14C']) && $_POST['conc_14C'] != '') &&
    (!isset($_POST['prod_14C']) || $_POST['prod_14C'] == '' ||
    !isset($_POST['uncer_14C']) || $_POST['uncer_14C'] == '')) {
        array_push($missing_fields, 'Production rate and/or uncertainty for ' .
        '<sup>14</sup>C');
}
if ((isset($_POST['conc_21Ne']) && $_POST['conc_21Ne'] != '') &&
    (!isset($_POST['prod_21Ne']) || $_POST['prod_21Ne'] == '' ||
    !isset($_POST['uncer_21Ne']) || $_POST['uncer_21Ne'] == '')) {
        array_push($missing_fields, 'Production rate and/or uncertainty for ' .
        '<sup>21</sup>Ne');
}


// If something is missing, send error to user and make him/her go back
if (count($missing_fields) > 0) {
    $error_msg = '<html><body>' .
        '<h2>Invalid input</h2>';

    // generate comma-separated list of missing field names
    for ($i = 0; $i < count($missing_fields); $i++) {

        // text before list of field names
        if ($i == 0 && count($missing_fields) == 1) {
            $error_msg .= '<p>The following value is missing: <ul>';
        } elseif ($i == 0) {
            $error_msg .= '<p>The following values are missing: <ul>';
        }

        $error_msg .= '<li>' . $missing_fields[$i] . '</li>';
    }
    $error_msg .= '</ul></p><p>Please <a href="javascript:history.back()">go' .
       ' back</a> and fill in the missing fields.</p></body></html>';
    die($error_msg); // end this script, print error
}


// If this is reached, input is ok and it is time to write the file for matlab
if (isset($_POST['sample_id'])) {
    // generate string containing all user input.
    // addslashes adds backslashes before characters that need to be escaped.
    $data = addslashes($_POST['sample_id']) . '\t';
    $tmpfile = tempnam('/tmp', 'cosmo_');
    $returnstatus = file_put_contents($tmpfile, $data);

    if ($returnstatus === false) {
        die('There was an error writing to the output file: ' . $tmpfile);
    }


    // delete temporary file
    //unlink($tmpfile);
} else {
    die('Invalid post data sent');
}

// redirect user after processing uploaded data, header function call must be 
// before any output!
header("Location: /cosmo");

?>
