FROM almalinux:9

RUN  dnf -y update
RUN  dnf -y install dnf-utils epel-release sudo
RUN  dnf -y groupinstall 'Development Tools'
RUN  dnf config-manager --set-enabled crb
# disable tty requirement in sudo
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
RUN useradd -s /bin/bash -G adm,wheel -m rpm


# This is an optimisation for caching, since using the auto generated one will
# make docker always run the builddep steps since new file
# replaced by master shell


# Add macros if needed ($$$ copie auto depuis SRC ?)
#RUN echo '%global python3_pkgversion 34' > /home/rpm/.rpmmacros
#RUN rpm --eval '%{python3_pkgversion}'

# Copy specs
ADD #SPEC# /tmp/project.spec

# download and cache dependencies unless option -s is used
ARG SKIPDEPENDENCIES=0
RUN if [ $SKIPDEPENDENCIES -eq 0 ]; then sudo yum-builddep -y /tmp/project.spec; fi


USER rpm
#ENV PROJECT $PROJECT

ADD utils/genrpm.sh /home/rpm/genrpm.sh
WORKDIR /home/rpm

# Add a "shadow" to RPM tree
ADD .build/rpm/ /home/rpm/rpmbuild/
RUN sudo chown -R rpm. /home/rpm/rpmbuild


ENTRYPOINT ["/home/rpm/genrpm.sh"]
