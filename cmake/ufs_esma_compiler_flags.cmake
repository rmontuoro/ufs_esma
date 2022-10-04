# UFS/GOCART interface
#
# UFS porting of ESMA_cmake package.
# See original version at: https://github.com/GEOS-ESM/ESMA_cmake (tag: v3.4.2)

if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
  set (FREAL8 "-fdefault-real-8 -fdefault-double-8")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
  set (FREAL8 "-r8")
else()
  set (FREAL8 "")
  message(WARNING "Fortran compiler with ID ${CMAKE_Fortran_COMPILER_ID} will be used with CMake default options")
endif()
