# ------------------------------------------------------------------------------
# List of demos according their dependencies
# ------------------------------------------------------------------------------

# Requires Irrlicht run-time visualization.
if(NOT ENABLE_MODULE_IRRLICHT OR NOT USE_FAST_DDS)
  return()
endif()

set(DEMOS 
    demo_SYN_DDS_distributed
)

# --------------------------------------------------------------

include_directories(${SYN_INCLUDES})

foreach(PROGRAM ${DEMOS})
  message(STATUS "...add ${PROGRAM}")

  add_executable(${PROGRAM} ${PROGRAM}.cpp)
  source_group("" FILES ${PROGRAM}.cpp)

  set_target_properties(
    ${PROGRAM} PROPERTIES COMPILE_FLAGS "${SYN_CXX_FLAGS}"
                          LINK_FLAGS "${CH_LINKERFLAG_EXE} ${MPI_LINK_FLAGS}")

  target_link_libraries(${PROGRAM} ChronoEngine_synchrono ${SYN_LIBRARIES})
endforeach()
