cmake_minimum_required(VERSION 3.1)

project(
  OpenGL-Volume-Rendering
  VERSION 1.0
  LANGUAGES C CXX
)

find_package(glfw3 REQUIRED)

set(CMAKE_CXX_STANDARD 17)
SET(GCC_COVERAGE_LINK_FLAGS "-lGL -lX11 -lpthread -lXrandr -lXi -ldl")
SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${GCC_COVERAGE_LINK_FLAGS}")

# This is a "default" library, and will match the *** variable setting.
# Other common choices are STATIC, SHARED, and MODULE
# Including header files here helps IDEs but is not required.
# Output libname matches target name, with the usual extensions on your system
# add_library(Lib simple_lib.cpp simple_lib.hpp)
include_directories(${CMAKE_SOURCE_DIR}/include)

add_library(glad 
  include/glad/glad.h 
  src/glad.c
)
target_include_directories(glad PUBLIC ${CMAKE_SOURCE_DIR}/include)

# Link each target with other targets or add options, etc.

# Adding something we can run - Output name matches target name
add_compile_definitions("SOURCE_ROOT=${CMAKE_SOURCE_DIR}")

add_executable(VolumeRendering 
  ${CMAKE_SOURCE_DIR}/src/main.cc
  ${CMAKE_SOURCE_DIR}/src/glad.c
)


target_link_libraries(VolumeRendering PUBLIC glfw glad)

# Make sure you link your targets with this command. It can also link libraries and
# even flags, so linking a target that does not exist will not give a configure-time error.
# target_link_libraries(VolumeRendering PRIVATE Lib)