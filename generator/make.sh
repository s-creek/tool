#!/bin/sh
cd `dirname $0`

#
# user configuration
#
export COMP_NAME="USER_COMP_NAME"


#
# not change !!
#
export RTM_ROOT=/opt/grx
export PATH=/usr/pkg/bin:/opt/grx/bin:$PATH
export PKG_CONFIG_PATH=/opt/grx/lib/pkgconfig:/usr/pkg/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/usr/pkg/lib:/opt/grx/lib:/opt/grx/lib/OpenRTM-aist:$LD_LIBRARY_PATH

CMAKE_OPT="-DCMAKE_INSTALL_PREFIX:STRING=/opt/grx  -DCOMP_NAME=${COMP_NAME} $@"
MAKE_OPT="VERBOSE=1"

# for logging
DATE=`/bin/date '+%Y%m%d%H%M'`
mkdir -p log

# cmake
cmake . ${CMAKE_OPT} 2>&1 | tee log/build_${DATE}.log

# make
make ${MAKE_OPT} 2>&1 | tee -a log/build_${DATE}.log

cd log
ln -sfv build_${DATE}.log build.log