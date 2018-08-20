<?php

if ( isset( $_GET['debug'] ) && $_GET['debug'] === 'error-test' ) {
    ini_set( 'display_errors', 'On' );
    error_reporting( E_ALL & ~E_STRICT );
    error_log( 'PHP EXCEPTION This is a test from i.php.', 0 );
}


phpinfo();



