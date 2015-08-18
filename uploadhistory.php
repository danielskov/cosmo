<?php
// uploadhistory.php
// Validates form data from pages/history.html and writes a file for the Matlab 
// script file_scanner_mcmc_starter.m to read as input for the MCMC inversion.

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
