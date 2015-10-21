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
?>
    </head>

    <!--<body ng-controller="mainController">-->
    <body ng-app="cosmoApp">
        <div ng-controller="mainController">

        <!-- Navigation bar -->
        <nav class="light-blue lighten-1" role="navigation">
        <div class="nav-wrapper container"><a id="logo-container" href="/#/"
                class="brand-logo"><img src="img/logo.png" alt="logo"
                height="92" width="220"></a>

            <ul class="right hide-on-med-and-down">
                <li><a href="#/">Calculator</a></li>
                <li><a href="#/methods">Methods</a></li>
                <!--<li><a href="#/about">About</a></li>-->
                <li><a href="#/help">Help</a></li>
            </ul>

            <ul id="nav-mobile" class="side-nav">
                <li><a href="#/">Calculator</a></li>
                <li><a href="#/methods">Methods</a></li>
                <!--<li><a href="#/about">About</a></li>-->
                <li><a href="#/help">Help</a></li>
            </ul>

            <a href="#" data-activates="nav-mobile"
                class="button-collapse"><i
                    class="material-icons">menu</i></a>
        </div>
        </nav>

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
            <h2 class="header center orange-text">Inversion results</h2>


            <div class="row">
              <div class="col s12 m8 offset-m2">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-1.png">
                    <span class="card-title">First figure</span>
                  </div>
                  <div class="card-content">
                    <p>This is the first figure, and it shows this and that.</p>
                  </div>
                  <div class="card-action">
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-1.png"
                    target="_blank">Link to PNG</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-1.pdf"
                    target="_blank">Link to PDF</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-1.fig"
                    target="_blank">Link to FIG</a>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col s12 m8 offset-m2">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-2.png">
                    <span class="card-title">Second figure</span>
                  </div>
                  <div class="card-content">
                    <p>This is the second figure, and it shows this and that.</p>
                  </div>
                  <div class="card-action">
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-2.png"
                    target="_blank">Link to PNG</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-2.pdf"
                    target="_blank">Link to PDF</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-2.fig"
                    target="_blank">Link to FIG</a>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col s12 m8 offset-m2">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-3.png">
                    <span class="card-title">Third figure</span>
                  </div>
                  <div class="card-content">
                    <p>This is the third figure, and it shows this and that.</p>
                  </div>
                  <div class="card-action">
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-3.png"
                    target="_blank">Link to PNG</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-3.pdf"
                    target="_blank">Link to PDF</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-3.fig"
                    target="_blank">Link to FIG</a>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col s12 m8 offset-m2">
                <div class="card">
                  <div class="card-image">
                  <img src="output/<?php
                        echo($_GET['results_id']); ?>_Walks-4.png">
                    <span class="card-title">Fourth figure</span>
                  </div>
                  <div class="card-content">
                    <p>This is the fourth figure, and it shows this and that.</p>
                  </div>
                  <div class="card-action">
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-4.png"
                    target="_blank">Link to PNG</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-4.pdf"
                    target="_blank">Link to PDF</a>
                  <a href="output/<?php
                        echo($_GET['results_id']); ?>_Walks-4.fig"
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
