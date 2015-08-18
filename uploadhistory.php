<?php
// uploadhistory.php
// Validates form data from pages/history.html and writes a file for the Matlab 
// script file_scanner_mcmc_starter.m to read as input for the MCMC inversion.

//$missing_fields = ''; // string of missing field names
$missing_fields = array(); // array of missing field names
//die('"' . $_POST['sample_id'] . '", ' . isset($_POST['sample_id']));

// Check required fields one by one
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

// If something is missing, send error to user and make him/her go back
if (count($missing_fields) > 0) {
    $error_msg = '<html><body>' .
        '<h2>Invalid input</h2>';

    // generate comma-separated list of missing field names
    for ($i = 0; $i < count($missing_fields); $i++) {

        // text before list of field names
        if ($i == 0 && count($missing_fields) == 1) {
            $error_msg .= '<p>The following value is missing: <b>';
        } elseif ($i == 0) {
            $error_msg .= '<p>The following values are missing: <b>';
        }

        if (1 == count($missing_fields)) { // just a single missing field
            $error_msg .= $missing_fields[$i];
        } elseif ($i + 1 == count($missing_fields)) { // no comma for last word
            $error_msg .= ' and ' . $missing_fields[$i];
        } elseif ($i + 2 == count($missing_fields)) { // no oxford comma
            $error_msg .= $missing_fields[$i] . ' ';
        } else {
            $error_msg .= $missing_fields[$i] . ', ';
        }
    }
    $error_msg .= '</b></p><p>Please <a href="javascript:history.back()">go' .
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
