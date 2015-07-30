#!/bin/sh

COMP_NAME=creekQrCodeReader


mkdir -p ${COMP_NAME}
cp make.sh clean.sh CMakeLists.txt ./${COMP_NAME}/
sed -e "s/USER_COMP_NAME/${COMP_NAME}/g" make.sh > ./${COMP_NAME}/make.sh


EXTRA_MODE=OFF
if [ -e ${COMP_NAME}Service.idl ]; then
    cp ${COMP_NAME}Service.idl ./${COMP_NAME}/
    EXTRA_OPT="--service=${COMP_NAME}Service:service0:${COMP_NAME}Service --service-idl=${COMP_NAME}Service.idl"
    EXTRA_MODE=ON
    echo "extra mode"
else
    echo "normal mode"
fi

cd ${COMP_NAME}
rtc-template -bcxx \
    --module-name=${COMP_NAME} \
    --module-type=${COMP_NAME} \
    --module-desc=${COMP_NAME} \
    --module-version=1.0 \
    --module-vendor='s-creek' \
    --module-category=example \
    --module-comp-type=DataFlowComponent \
    --module-act-type=SPORADIC \
    --module-max-inst=0 \
    --inport=image:Img::TimedCameraImage \
    ${EXTRA_OPT}
rm *_vc*
rm *.bat *.yaml
rm user_config.vsprops
rm Makefile.${COMP_NAME}
rm README.${COMP_NAME}

if [ ${EXTRA_MODE} = ON ]; then
    mv ${COMP_NAME}ServiceSVC_impl.h ${COMP_NAME}Service_impl.h
    mv ${COMP_NAME}ServiceSVC_impl.cpp ${COMP_NAME}Service_impl.cpp
fi

removeSVC() {
    sed -e "s/ServiceSVC/Service/g" $1 > /tmp/.$1
    sed -e "s/SERVICESVC/SERVICE/g" /tmp/.$1 > $1
}

if [ ${EXTRA_MODE} = ON ]; then
    removeSVC ${COMP_NAME}.h
    removeSVC ${COMP_NAME}Service_impl.h
    removeSVC ${COMP_NAME}Service_impl.cpp
fi

removeOpenHRP() {
    sed -e "s/OpenHRP_//g" $1 > /tmp/.$1
    sed -e "s/${COMP_NAME}ServiceSkel.h/${COMP_NAME}Service.hh/g" /tmp/.$1 > $1
}

if [ ${EXTRA_MODE} = ON ]; then
    removeOpenHRP ${COMP_NAME}Service_impl.h
    removeOpenHRP ${COMP_NAME}Service_impl.cpp
fi

