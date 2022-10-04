# UFS/GOCART interface
#
# UFS porting of ecBuild package.
# See original version at: https://github.com/JCSDA-internal/ecbuild (tag: 3.3.2.jcsda3)

function( ecbuild_add_executable )

  set( options NOINSTALL AUTO_VERSION )
  set( single_value_args TARGET COMPONENT LINKER_LANGUAGE VERSION OUTPUT_NAME )
  set( multi_value_args SOURCES SOURCES_GLOB SOURCES_EXCLUDE_REGEX OBJECTS
                        TEMPLATES LIBS INCLUDES DEPENDS PERSISTENT DEFINITIONS
                        CFLAGS CXXFLAGS FFLAGS GENERATED CONDITION PROPERTIES )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(_PAR_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "CRITICAL - Unknown keywords given to ecbuild_add_executable(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  if( NOT _PAR_TARGET  )
    message(FATAL_ERROR "CRITICAL - The call to ecbuild_add_executable() doesn't specify the TARGET.")
  endif()

  if( NOT _PAR_SOURCES AND NOT _PAR_OBJECTS AND NOT _PAR_SOURCES_GLOB )
    message(FATAL_ERROR "CRITICAL - The call to ecbuild_add_executable() specifies neither SOURCES nor OBJECTS nor SOURCES_GLOB.")
  endif()

  # insert already compiled objects (from OBJECT libraries)
  unset( _all_objects )
  foreach( _obj ${_PAR_OBJECTS} )
    list( APPEND _all_objects $<TARGET_OBJECTS:${_obj}> )
  endforeach()

  add_executable( ${_PAR_TARGET} ${_PAR_SOURCES} ${_all_objects} )

  # Set custom properties
  if( ${_PAR_PROPERTIES} )
    set_target_properties( ${_PAR_TARGET} PROPERTIES ${_PAR_PROPERTIES} )
  endif()

  # add include dirs if defined
  if( DEFINED _PAR_INCLUDES )
    target_include_directories( ${_PAR_TARGET} PRIVATE ${_PAR_INCLUDES} )
  endif()

  # set OUTPUT_NAME
  if( DEFINED _PAR_OUTPUT_NAME )
    set_target_properties( ${_PAR_TARGET} PROPERTIES OUTPUT_NAME ${_PAR_OUTPUT_NAME} )
  endif()

  # add extra dependencies
  if( DEFINED _PAR_DEPENDS)
    add_dependencies( ${_PAR_TARGET} ${_PAR_DEPENDS} )
  endif()

  # add the link libraries
  if( DEFINED _PAR_LIBS )
    target_link_libraries( ${_PAR_TARGET} ${_PAR_LIBS} )
  endif()

  # installation
  if( NOT _PAR_NOINSTALL )
    install( TARGETS ${_PAR_TARGET}
             EXPORT  ${PROJECT_NAME}-targets
             RUNTIME DESTINATION ${INSTALL_BIN_DIR}
             LIBRARY DESTINATION ${INSTALL_LIB_DIR}
             ARCHIVE DESTINATION ${INSTALL_LIB_DIR} )

    # set build location
    set_target_properties( ${_PAR_TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin )

    # export location of target to other projects -- must be exactly after setting the build location (see previous command)
    export( TARGETS ${_PAR_TARGET} APPEND FILE "${PROJECT_TARGETS_FILE}" )

  else()
    set_target_properties( ${_PAR_TARGET} PROPERTIES SKIP_BUILD_RPATH         FALSE )
    set_target_properties( ${_PAR_TARGET} PROPERTIES BUILD_WITH_INSTALL_RPATH FALSE )
  endif()

endfunction()
