## Version

Version 0.01

## Script Options

--username
A valid username of a user account with access to the Tomcat management pages.

```
$ perl Main.pm --username myusername
```

--password
The password for the user account given for the username parameter above.

```
$ perl Main.pm --password mypass
```

--hostname
The resolvable hostname or IP address of the target Tomcat server.

```
$ perl Main.pm --hostname myhost.com
```

--action
Run Actions
Defults test

```
$ perl Main.pm --action deploy
```

deploy   - Deploy Webapp
undeploy - Undeploy Webapp
start    - Start Webapp
stop     - Stop Webapp
info     - Info Webapp about process
check    - Check if Webapp response
test     - Module implement the following pipeline:
             Deploy application
             Start application  
             Check if application works and responses
             Undeploy application
             Check if application no longer available                 

--config
Config file
Defults /TManager/logs/conf.cfg


```
$ perl Main.pm --config /path/myconf.cfg
```

--save_conf
Change or save your config or options in /TManager/logs/conf.cfg

```
$ perl Main.pm --save_conf
```

--war
Name and directory for Webapp .WAR file.

```
$ perl Main.pm --war /mydir/app.war
```

--path
Name of Webapp path on Tomcat server.

```
$ perl Main.pm --path /myappname
```
--port
The target port on the target Tomcat server on which to connect.
If this parameter is not specified then it defaults to port 8080.

```
$ perl Main.pm --port myport
```

--proto
The protocol to use when connecting to the target Tomcat server.

If this parameter is not specified then it defaults to HTTP.

```
$ perl Main.pm --proto http
```
--debug
Output debug info

```
$ perl Main.pm --debug
```
--error_log
Write log file

```
$ perl Main.pm --error_log 
```

## Action Test Example 

```
$ perl Main.pl --username kstas --password 123 --hostname 192.168.137.229 --war /usr/HelloW.war --path /MyWebApp

OK - Deployed application at context path /MyWebApp
OK - Started application at context path /MyWebApp
OK - Webapp /MyWebApp Available
OK - Session information for application at context path /MyWebApp
Default maximum session inactive interval 30 minutes
>0 minutes: 0 sessions were expired
OK - Stopped application at context path /MyWebApp
OK - Undeployed application at context path /MyWebApp
Unable to retrieve content
OK - /MyWebApp Not available
Test 7/7 complete
```

