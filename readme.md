# Local Docker Tomcat
This is a local docker tomcat configuration.

## Build
This is what is used to build the container.

```
$ docker build -t tomcat:latest .
```

## Run
This is the command to execute the container with volume mappings.

```
$ docker run --rm -p 8080:8080 tomcat
```
### Run Interactively and override
```
$ docker run --rm -it -p 8080:8080 tomcat /bin/sh
````

## Notes
- The file *tomcat-users.xml* is in the .gitignore so that no passwords end up in the repository.
- run for build of 3cm: docker run --rm -it -p 8080:8080 -v //c/Users/gchkenn/cf/3cm:/var/3cm tomcat /bin/sh