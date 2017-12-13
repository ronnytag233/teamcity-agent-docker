# teamcity-agent-docker

This is a teamcity build agent docker image, it uses Docker-outside-of-Docker (DooD) to allow access to docker running on the host.
When starting the image as container you must set the TEAMCITY_SERVER environment variable to point to the teamcity server e.g.
```
docker run -e TEAMCITY_SERVER=http://localhost:8111
```
