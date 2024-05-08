# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-src"
  "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-build"
  "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-subbuild/nuget-populate-prefix"
  "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/tmp"
  "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp"
  "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src"
  "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp"
)

set(configSubDirs Debug)
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "D:/Flutter project/master-plan/master_plan/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
