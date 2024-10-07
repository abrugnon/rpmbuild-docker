#!/bin/bash
set -ex
# generic rpm compiler
SPECS_DIR=$(rpm --eval %{_specdir})
SPEC=$(ls ${SPECS_DIR}/*.spec | head -n 1)
#cat $SPEC
echo "Now Building :" ${PROJECT}

ls -al /home/rpm/
# compile or fail
rpmbuild -bb ${SPEC} $@ || exit 1

# if success copy to parent dir
[[ -d /data ]] || exit 0

find rpmbuild/RPMS/ -name *.rpm | xargs -i cp  {} /data/rpm/output/
#find rpmbuild/RPMS/ -name *.rpm
