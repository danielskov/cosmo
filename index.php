<!DOCTYPE html>
<!--<html lang="en" ng-app="cosmoApp">-->
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

        <!-- let browser know the website is optimized for mobile -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

        <title>MCMC Cosmo Calculator</title>

        <!-- Favicons-->
        <link rel="apple-touch-icon-precomposed" href="img/favicon-apple-touch-icon-152x152.png">
        <meta name="msapplication-TileColor" content="#FFFFFF">
        <meta name="msapplication-TileImage" content="img/favicon-mstile-144x144.png">
        <link rel="icon" href="img/favicon-32x32.png" sizes="32x32" type="image/png">

        <!--  Android 5 Chrome Color-->
        <meta name="theme-color" content="#00aeed">

        <!-- Google material icons -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons"
            rel="stylesheet">

        <!-- materialize -->
        <link href="css/materialize.css" type="text/css" rel="stylesheet"
            media="screen,projection"/>
        <link href="css/style.css" type="text/css" rel="stylesheet"
            media="screen,projection"/>
        <link type="text/css" rel="stylesheet" href="css/materialize.css"
            media="screen,projection"/>
    </head>

    <!--<body ng-controller="mainController">-->
    <body ng-app="cosmoApp">
        <div ng-controller="mainController">

        <!-- Navigation bar -->
        <nav class="light-blue lighten-1" role="navigation">
        <div class="nav-wrapper container"><a id="logo-container" href="#/"
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

        <h2 class="header center orange-text valign">
        Please wait while the inversion computations are taking place</h2>

        <div class="row center valign-wrapper">

        <p class="flow-text row s4 center">
        This make take several minutes to complete.  Please <b>do not</b> press
        the browser navigation buttons and stay on this page.</p>

        </div>

        <div class="row progress center-align s4">
            <div class="indeterminate"></div>
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

        <footer class="page-footer blue">
        <div class="container">
            <div class="row">
                <!--<div class="col l6 s12">-->
                <div class="col l9 s12">
                    <h5 class="white-text">Acknowledgements</h5>
                    <p class="grey-text text-lighten-4">
                    This website is supported by grant ##-###-## by XXXXXX.

                    All rights reserved.
                    </p>
                    <div>
                        <a href="http://www.au.dk/en/">
                        <img src="img/au-logo.png" alt="Aarhus University logo" 
                        height="61" width="289">
                        </a>
                    </div>
                </div>

                <!--
                <div class="col l3 s12">
                    <h5 class="white-text">Settings</h5>
                    <ul>
                        <li><a class="white-text" href="#!">Link 1</a></li>
                        <li><a class="white-text" href="#!">Link 2</a></li>
                        <li><a class="white-text" href="#!">Link 3</a></li>
                        <li><a class="white-text" href="#!">Link 4</a></li>
                    </ul>
                </div>
                -->

                <div class="col l3 s12">
                    <h5 class="white-text">Contact & Feedback</h5>
                    <ul>
                        <li><a class="white-text" href="mailto:mfk@geo.au.dk">
                            Mads Faurschou Knudsen</a></li>
                        <li><a class="white-text"
                            href="mailto:anders.damsgaard@geo.au.dk">
                            Anders Damsgaard</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="footer-copyright">
            <div class="container">
                This website is maintained by <a class="white-text
                    text-lighten-3"
                    href="mailto:anders.damsgaard@geo.au.dk">Anders
                    Damsgaard</a> and designed using
                <a class="white-text text-lighten-3"
                    href="http://materializecss.com">Materialize</a>
            </div>
        </div>
        </footer>
    </div>

        <!-- import javascript at the end of body -->
        <!-- import jQuery before materialize.js (use materialize.min.js) -->
        <script type="text/javascript"
            src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
        <!--<script type="text/javascript" src="js/materialize.min.js"></script>-->
        <script type="text/javascript" src="js/materialize.js"></script>
        <script type="text/javascript"
            src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.3/angular.min.js"></script>
        <script type="text/javascript"
            src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.3/angular-route.min.js"></script>
        <script type="text/javascript" src="js/routing.js"></script>
        <script type="text/javascript" src="js/init.js"></script>

        <script> // Google Analytics
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
            ga('create', 'UA-45154895-2', 'auto');
            ga('send', 'pageview');
        </script>
    </body>
</html>
