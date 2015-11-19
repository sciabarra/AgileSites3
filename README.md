# Initial setup

go in dist and execute agilesites.sh (or agilesites.cmd on windows)

if there is not an agilesites.properties,  answer to the questions where is sites 

it will setup it all 

# Development Cycle

You need to install sbt first.

Open a terminal, go in plugin folder and execute sbt.sh (or sbt.cmd on windows)

(it is simply starting sbt using a local repo in ..\dist)

Then put in continuous deployment with ~publishLocal.

Open another terminal and type agilesites.sh (or agilesites.cmd on windows)

If you change the plugin code, you need to reload.

If you change a service, you need to do ng:setupOnly (it will update)

If you change spoon, it is automatically picked up if you performed a publishLocal

# Use the debugger 

All the code for the groovy code executed in Sites is under

    plugin/src/test/groovy
    
so you can do put breakpoints there if you put the application server in debug mode.

# Enable logs

You can configure logging using the configuratin files
 
dist/project/conf/logback-test.xml
dist/project/conf/application.conf
 
(copy the -dist files in the apporiate one then edit it)

# Set system properties

To debug configuration

- copy mysetenv.sh-dist (or .bat on windows) to mysetenv.sh (or .bat on windows)

- decomment the options you need

# Debugging logback and akka file used

Enable the system property logback.debug=true (decomment in mysetenv)

Enable the system property config.trace=loads (decomment in mysetenv)






