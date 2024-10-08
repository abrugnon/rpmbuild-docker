# RPMBUILD-DOCKER

Build RPMS inside docker containers. Keep your computer clean !

## Creating a new package (aka test)

- set up the sources directory (mkdir -p ./mypackage/{SOURCES,SPECS}) and put the relevant files into the directories
- choose or create a docker [template](./templates) that will be used to build your package

## Building

```
./factory -t centos7.Dockerfile -d mypackage
```
_ If your build dependencies haven't changed in the SPECFILE (only the build recipe)_
_You can avoid the build image being rebuilt by using the '-s' switch*_

`./factory -t alma9.Dockerfile -s -d mypackage`

## Output files

If everything succeeds, you will find your RPMS in the so called directory. The latest build with same filename overrides the previous one.


## TODO

* check rpmbuild extra args (--with xx ) is OK (+ builddep)
* workout on RPM signature
* ~~remove trailing slash on project/dir name~~
* Filter for Requires/BuildRequires ?
* Avoid Sending whole source context in Docker (.dockerignore ?)
