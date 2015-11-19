<?php

// reCAPTCHA setup
require_once('recaptchalib.php');

// your secret key
$secret = "6LeMrRATAAAAAOdcvVGi6PfR__XGOVoUP7lCqHp1";
 
// empty response
$response = null;
 
// check secret key
$reCaptcha = new ReCaptcha($secret);

// if submitted check response
if ($_POST["g-recaptcha-response"]) {
    $response = $reCaptcha->verifyResponse(
        $_SERVER["REMOTE_ADDR"],
        $_POST["g-recaptcha-response"]
    );
}

// include top of html template
include('head.html');

?>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
        <script type="text/javascript" src="js/history-form-prefiller.js"></script>
<?php

if (isset($_GET['wait_id']) && !empty($_GET['wait_id'])) {

    // read status file contents
    if (!$statusfile = fopen("/home/adc/cosmo/input/status_" . $_GET['wait_id'], "r")) {
        echo("Error! Sample data not found.");
    }

    $status = fgets($statusfile);
    fclose($statusfile);

    $show_percentage = false;
    if (strpos($status, '<!--') !== false) {
        $percentage = preg_replace('/.*<!--/', '', $status);
        $percentage = preg_replace('/-->/', '', $percentage);
        $percentage = preg_replace('/ /', '', $percentage);
        $show_percentage = true;
    }

    // redirect to results page if computations are complete
    if (strcmp($status, "Computations complete") == 0) {
        header("Location: /index.php?results_id=" . $_GET['wait_id']);
    }

    // refresh the page every 5 seconds while computations are running
?>
    <meta http-equiv="refresh" content="5" >
<?php
}

include('navigation.html');
?>
        <main>
<?php
if (isset($_GET['wait_id']) && !empty($_GET['wait_id'])) {
?>

    <div class="container">

        <br><br><br><br>
        <div class="row center">
            <h2 class="header col s12 orange-text">Please wait</h2>
        </div>

        <div class="row center">
            <h4 class="header col s12">
<?php
    echo $status;
?>
            </h4>
        </div>

        <div class="row progress center-align s12">
<?php
    if ($show_percentage) { ?>
            <div class="determinate"
                style="width: <?php echo($percentage); ?>%"></div>
<?php
    } else { ?>
            <div class="indeterminate"></div>
<?php } ?>
        </div>

        <div class="row center valign-wrapper">

        <p class="flow-text">
        Please wait while the inversion computations are taking place.
        These may make take several minutes to complete. For long waits you may
        bookmark this page and revisit it later. Please do not resubmit the
        sample.</p>
        </div>

        <div class="row center-align">
        <p class="center-align"> If the computations are queued for more than 24
        hours, please contact <a href="mailto:anders.damsgaard@geo.au.dk">Anders
            Damsgaard</a>.</p>
        </div>
        <br><br><br><br><br><br>

    </div>

<?php
} elseif (isset($_GET['results_id']) && !empty($_GET['results_id'])) {
    // show plots
?>

    <div class="section no-pad-bot" id="index-banner">
        <div class="container">
            <br><br>
            <!-- page header -->
            <h2 class="header center orange-text">MCMC inversion results</h2>

            <div class="row">
              <div class="col s12">
                <div class="card">
                  <div class="card-image">
                <?php 
                    include('output/' . $_GET['results_id'] . '_Walks.html');
                ?>
                  </div>
                  <div class="card-content">
                      <h5 class="blue-text">
                          Results</h5>
                      <p>The table shows the general statistical results of
                      interglacial erosion rate (&epsilon;<sub>int</sub>),
                      glacial erosion rate (&epsilon;<sub>gla</sub>), climate
                      record threshold value
                      (&delta;<sup>18</sup>O<sub>threshold</sub>), and total
                      erosion (E), produced the Markov-Chain Monte-Carlo
                      inversion. Results are displayed per walker and on
                      average. The 50th percentiles (also called second
                      quartile) denote the median parameter value. The 25th
                      percentiles (first quartile) marks the value that splits
                      the lowest 25% percent of data from the highest 75%.
                      The 75th percentiles mark the limit to the upper 25% of
                      data. If the 25th, 50th, and 75th percentile values for a
                      parameter are close, the parameter is well constrained. If
                      a specific percentile value shows high variability for a
                      parameter, there may be several values which fit the
                      solution.</p>

                  </div>
                </div>
              </div>
            </div>

            <div class="row">
                <!--<div class="col s12 m8 offset-m2">-->
              <div class="col s12">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-6.png">
                        <!--<span class="card-title blue-text text-darken-2">
                            Generalized model parameter values</span>-->
                  </div>
                  <div class="card-content">
                      <h5 class="blue-text">
                          Generalized model parameter values</h5>
                      <p>The histograms show the distribution of (a)
                      interglacial erosion rate, (b) glacial erosion rate, (c)
                      timing of last deglaciation, and (d)
                      d<sup>18</sup>O<sub>threshold</sub> levels that provide
                      the best fit to the supplied TCN concentrations. 
                      The vertical axis indicates the number of
                      simulations included in each bin out of the 10,000
                      simulations that followed the MCMC burn-in phase from each
                      MCMC walker.  The solid magenta lines denote the median
                      values (second quartile), while the dashed magenta lines
                      denote the lower and upper quartiles (25th and 75th
                      percentiles, respectively). A parameter is well
                      constrained if the histogram has a single, distinct peak,
                      and relatively close median, lower and upper quartile
                      values. Flat histograms denote that the parameters are not
                      well constrained.</p>
                  </div>
                  <div class="card-action">
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-6.png"
                    target="_blank">Link to PNG</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-6.pdf"
                    target="_blank">Link to PDF</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-6.fig"
                    target="_blank">Link to FIG</a>
                  </div>
                </div>
              </div>
            </div>


            <div class="row">
                <!--<div class="col s12 m8 offset-m2">-->
              <div class="col s12">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-5.png">
                        <!--
                        <span class="card-title blue-text text-darken-2">
                        Model parameter values per inversion walker</span>
                        -->
                  </div>
                  <div class="card-content">
                      <h5 class="blue-text">
                          Model parameter values per inversion walker</h5>
                      <p>The histograms show the distribution of (a)
                      interglacial erosion rate, (b) glacial erosion rate, (c)
                      timing of last deglaciation, and (d)
                      d<sup>18</sup>O<sub>threshold</sub> levels that provide
                      the best fit to the supplied TCN concentrations. There is
                      one histogram per model parameter for each MCMC walker.
                      The <!--fraction indicates the number of simulations
                      included in--> vertical axis indicates the number of
                      simulations included in each bin out of the 10,000
                      simulations that followed the MCMC burn-in phase.</p>
                  </div>
                  <div class="card-action">
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-5.png"
                    target="_blank">Link to PNG</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-5.pdf"
                    target="_blank">Link to PDF</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-5.fig"
                    target="_blank">Link to FIG</a>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
                <!--<div class="col s12 m8 offset-m2">-->
              <div class="col s12">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-7.png">
                        <!--
                        <span class="card-title blue-text text-darken-2">
                        Erosion history</span>-->
                  </div>
                  <div class="card-content">
                      <h5 class="blue-text">
                          Median-based model of sample history</h5>
                      <p>
                      (a) Two-stage glacial-interglacial model based on the
                      selected climate record and the median
                      &delta;<sup>18</sup>O<sub>threshold</sub> value from the
                      first figure above.  Timing and duration of glacial and
                      interglacial periods are defined by the threshold value
                      that is applied to the climate record. 

                      (b) Binary exposure history between glaciations
                      characterized by total exposure and interglacials without
                      any exposure.

                      (c) Erosion rate through time which alternates between
                      interglacial and glacial erosion rate magnitude, based on
                      median values presented above.

                      In all three figures the vertical dashed lines denotes the
                      median age of the last deglaciation.
                      
                      </p>
                  </div>
                  <div class="card-action">
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-7.png"
                    target="_blank">Link to PNG</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-7.pdf"
                    target="_blank">Link to PDF</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-7.fig"
                    target="_blank">Link to FIG</a>
                  </div>
                </div>
              </div>
            </div>

<?php
} else {
?>
        <div ng-view>
            <!-- content is injected here -->
        </div>
<?php } ?>

        </main>

<?php include('foot.html'); ?>


