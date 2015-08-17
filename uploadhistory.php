<?php
// write form data to file
if (isset($_POST['sample_id'])) {
    $data = $_POST['sample_id'] . '\t';
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

// redirect user after processing uploaded data, before any output!
header("Location: /cosmo");

?>
