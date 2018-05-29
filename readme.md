# Local Docker Tomcat
This is a local docker tomcat configuration.

## Build
This is what is used to build the container.

'''
$ docker build -t tomcat:latest .
'''

## Run
This is the command to execute the container with volume mappings.

'''
$ docker run --rm -p 8080:8080 tomcat
'''