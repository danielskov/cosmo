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
if (!isset($_POST['name']) || $_POST['name'] == '') {
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
if (!isset($_POST['t_degla_uncer']) || $_POST['t_degla_uncer'] == '') {
    array_push($missing_fields, 'Uncertainty of time since deglaciation');
}
if (!isset($_POST['record']) || $_POST['record'] == ''){
    array_push($missing_fields, 'Climate record');
}
if (!isset($_POST['record_threshold_min']) || $_POST['record_threshold_min'] == ''){
    array_push($missing_fields, 'Min. climate record threshold value');
}
if (!isset($_POST['record_threshold_max']) || $_POST['record_threshold_max'] == ''){
    array_push($missing_fields, 'Max. climate record threshold value');
}

// Check TCN concentrations, at least one value is needed
if ((!isset($_POST['be_conc']) || $_POST['be_conc'] == '') &&
    (!isset($_POST['al_conc']) || $_POST['al_conc'] == '') &&
    (!isset($_POST['c_conc'])  || $_POST['c_conc'] == '') &&
    (!isset($_POST['ne_conc']) || $_POST['ne_conc']) == '') {
        array_push($missing_fields, 'at least 1 TCN concentration');
}

// For each isotope concentration there should be uncertainty and production 
// rate
if ((isset($_POST['be_conc']) && $_POST['be_conc'] != '') &&
    (!isset($_POST['be_prod']) || $_POST['be_prod'] == '' ||
    !isset($_POST['be_uncer']) || $_POST['be_uncer'] == '')) {
        array_push($missing_fields, 'Production rate and/or uncertainty for ' .
        '<sup>10</sup>Be');
}
if ((isset($_POST['al_conc']) && $_POST['al_conc'] != '') &&
    (!isset($_POST['al_prod']) || $_POST['al_prod'] == '' ||
    !isset($_POST['al_uncer']) || $_POST['al_uncer'] == '')) {
        array_push($missing_fields, 'Production rate and/or uncertainty for ' .
        '<sup>26</sup>Al');
}
if ((isset($_POST['c_conc']) && $_POST['c_conc'] != '') &&
    (!isset($_POST['c_prod']) || $_POST['c_prod'] == '' ||
    !isset($_POST['c_uncer']) || $_POST['c_uncer'] == '')) {
        array_push($missing_fields, 'Production rate and/or uncertainty for ' .
        '<sup>14</sup>C');
}
if ((isset($_POST['ne_conc']) && $_POST['ne_conc'] != '') &&
    (!isset($_POST['ne_prod']) || $_POST['ne_prod'] == '' ||
    !isset($_POST['ne_uncer']) || $_POST['ne_uncer'] == '')) {
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

// generate string containing all user input.
// addslashes adds backslashes before characters that need to be escaped.

$fieldnames = array(
    'sample_id',
    'name',
    'email',
    'lat',
    'long',
    'be_conc',
    'al_conc',
    'c_conc',
    'ne_conc',
    'be_uncer',
    'al_uncer',
    'c_uncer',
    'ne_uncer',
    'be_prod',
    'al_prod',
    'c_prod',
    'ne_prod',
    'rock_density',
    'epsilon_gla_min',
    'epsilon_gla_max',
    'epsilon_int_min',
    'epsilon_int_max',
    't_degla',
    't_degla_uncer',
    'record', // check if set missing
    'record_threshold_min',
    'record_threshold_max');

// Generate unique output file name
$outputfile = tempnam('/tmp', 'cosmo_');
if (is_writable($outputfile)) {

    if (!$handle = fopen($outputfile, 'w')) {
        die("The php server could not open $outputfile.");
    }

    // write header to file
    /*foreach ($fieldnames as $fieldname) {
        if (fwrite($handle, addslashes($fieldname) . "\t") === false) {
            die("The php server could not write $fieldname to $outputfile.");
        }
    }
    fwrite($handle, "\n");*/

    // write values to file
    foreach ($fieldnames as $fieldname) {
        if (fwrite($handle, addslashes($_POST[$fieldname]) . "\t") === false) {
            die("The php server could not write $fieldname to $outputfile.");
        }
    }
    //fwrite($handle, "\n");

} else {
    die("The php server output file $outputfile is not writable");
}

// change permissions of output file
if (!chmod($outputfile, 0777)) {
    die("The php server could not set proper permissions for $outputfile.");
}

//$data = addslashes($_POST['sample_id']) . '\t';
//$returnstatus = file_put_contents($tmpfile, $data);
//if ($returnstatus === false) {
//    die('There was an error writing to the output file: ' . $tmpfile);
//}


// delete temporary file
//unlink($tmpfile);



// Finally redirect user after processing uploaded data. This header function 
// call must be before any output!
header("Location: /~ad/cosmo");

?>
