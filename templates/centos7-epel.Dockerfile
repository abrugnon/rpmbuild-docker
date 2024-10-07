FROM centos:7
MAINTAINER Arnaud Brugnon <abrugnon@mail4.pro>

RUN yum -y groupinstall 'Development Tools' \
    && yum -y install yum-utils sudo http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# disable tty requirement in sudo
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
RUN useradd -s /bin/bash -G adm,wheel -m rpm

# This is an optimisation for caching, since using the auto generated one will
# make docker always run the builddep steps since new file
# replaced by master shell


# Add macros if needed ($$$ copie auto depuis SRC ?)
RUN echo '%global python3_pkgversion 34' > /home/rpm/.rpmmacros
RUN rpm --eval '%{python3_pkgversion}'

# Copy specs
ADD #SPEC# /tmp/project.spec
# download and cache dependencies
RUN sudo yum-builddep -y /tmp/project.spec


USER rpm
#ENV PROJECT $PROJECT

ADD utils/genrpm.sh /home/rpm/genrpm.sh
WORKDIR /home/rpm


# Add a "shadow" to RPM tree
ADD .build/rpm/ /home/rpm/rpmbuild/
RUN sudo chown -R rpm. /home/rpm/rpmbuild


ENTRYPOINT ["/home/rpm/genrpm.sh"]
