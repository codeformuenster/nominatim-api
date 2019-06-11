<?php

    // FIXME: allow ENV var
    @define('CONST_Database_DSN', 'pgsql:host=postgis-nominatim;port=5432;user=nominatim_init;password=n0mn0m;dbname=nominatim');
    @define('CONST_Database_Web_User', 'nominatim');

    // in postgis-docker
    @define('CONST_Database_Module_Path', '/opt/nominatim/build/module');

    @define('CONST_Osm2pgsql_Binary', '/usr/local/bin/osm2pgsql');
    @define('CONST_Debug', true);

?>