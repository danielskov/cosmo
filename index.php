<?php include('head.html'); ?>
<?php
if (isset($_GET['wait_id']) && !empty($_GET['wait_id'])) {

    // read status file contents
    if (!$statusfile = fopen("/home/adc/cosmo/input/status_" . $_GET['wait_id'], "r")) {
        echo("Error! Sample data not found.");
    }

    $status = fgets($statusfile);
    fclose($statusfile);

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
            <div class="indeterminate"></div>
        </div>

        <div class="row center valign-wrapper">

        <p class="flow-text">
        Please wait while the inversion computations are taking place.
        These may make take several minutes to complete.  <b>Do not</b> press
        the browser navigation buttons or leave this page.</p>

        </div>
        <br><br><br><br><br><br><br><br>

    </div>

<?php
} elseif (isset($_GET['results_id']) && !empty($_GET['results_id'])) {
    // show plots
?>

    <div class="section no-pad-bot" id="index-banner">
        <div class="container">
            <br><br>
            <!-- page header -->
            <h2 class="header center orange-text">MCMC Inversion results</h2>

            <div class="row">
              <div class="col s12 m12 offset-m2">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-5.png">
                    <span class="card-title">Model parameter values</span>
                  </div>
                  <div class="card-content">
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
              <div class="col s12 m12 offset-m2">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-6.png">
                    <span class="card-title">Erosion history</span>
                  </div>
                  <div class="card-content">
                      <p>
                      (a) Two-stage glacial-interglacial model based on the
                      selected climate record.
                      
                      (b) Timing and duration of glacial and interglacial
                      periods are defined by a threshold value (d18Othreshold)
                      that is applied to the climate record. 
                      
                      </p>
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

<?php
} else {
?>
        <div ng-view>
            <!-- content is injected here -->
        </div>
<?php } ?>

        </main>

<?php include('foot.html'); ?>


