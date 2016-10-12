cmake_minimum_required(VERSION 2.6)

set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)
if (NOT CMAKE_MODULE_PATH)
  set(CMAKE_MODULE_PATH /opt/grx/share/hrpsys/cmake_modules/ CACHE STRING "set path to cmake_modules")
endif (NOT CMAKE_MODULE_PATH)

####
## settings for OpenRTM
##
include(FindPkgConfig)
include(CheckIncludeFiles)
find_package(OpenRTM REQUIRED)
include_directories(${OPENRTM_INCLUDE_DIRS})
link_directories(${OPENRTM_LIBRARY_DIRS})
include(GenerateStubSkel)


###
# setting for OpenHRP or choreonoid
#
if(NOT USE_CNOID_MODEL)
  find_package(OpenHRP REQUIRED)
  include_directories(${OPENHRP_INCLUDE_DIRS})
  link_directories(${OPENHRP_LIBRARY_DIRS})
  set(MODEL_LIBRARIES ${OPENHRP_LIBRARIES})
else()
  pkg_check_modules(CHOREONOID REQUIRED choreonoid-body-plugin)
  include_directories(${CHOREONOID_INCLUDE_DIRS})
  link_directories(${CHOREONOID_LIBRARY_DIRS})
  set(MODEL_LIBRARIES ${CHOREONOID_LIBRARIES})
endif()

include_directories(/opt/grx/include)
include_directories(${CMAKE_MODULE_PATH})


####
## for each component
##
set(comp_name ${COMP_NAME})
set(comp_sources ${comp_name}.cpp)

#generate_stub_skel(${comp_name}Service)
#set(comp_sources ${comp_sources} ${comp_name}Service_impl.cpp ${comp_name}ServiceSk.cpp)


add_library(${comp_name} SHARED ${comp_sources})
target_link_libraries(${comp_name} ${OPENRTM_LIBRARIES})
target_link_libraries(${comp_name} ${MODEL_LIBRARIES})
target_link_libraries(${comp_name} m)
#target_link_libraries(lapack blas f2c)
set_target_properties(${comp_name} PROPERTIES PREFIX "")

if (NO_COMP)
  set(target ${comp_name})
else()
  set(target ${comp_name} ${comp_name}Comp)
  add_executable(${comp_name}Comp ${comp_name}Comp.cpp ${comp_sources})
  target_link_libraries(${comp_name}Comp ${OPENRTM_LIBRARIES})
  target_link_libraries(${comp_name}Comp ${MODEL_LIBRARIES})
  target_link_libraries(${comp_name}Comp boost_filesystem)
  target_link_libraries(${comp_name}Comp m)
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ggdb3 -fno-schedule-insns -fno-schedule-insns2 -fno-strict-aliasing")

#install(TARGETS ${target}
install(TARGETS ${comp_name} LIBRARY DESTINATION lib CONFIGURATIONS)
#install(FILES connect.conf DESTINATION rtc)
