#!/bin/bash

set -ev

CXX="/opt/clang-12/bin/clang++"

CXX_FLAGS="-std=c++20 -stdlib=libc++ -Wall -Werror -g -O0"
CXX_FLAGS="$CXX_FLAGS -fmodules -fimplicit-modules -fmodules-cache-path=modules-cache -DMODULES"
CXXM_FLAGS="$CXX_FLAGS --precompile -x c++-module"
    
$CXX -c $CXXM_FLAGS ../callback.cppm \
     -o callback.pcm \
    -Xclang -emit-module-interface

$CXX -c $CXX_FLAGS -fmodule-file=asio.pcm -fmodule-file=callback.pcm \
    -fmodule-map-file=../asio.modulemap \
    ../test.cpp -o test.o

$CXX $CXX_FLAGS test.o callback.pcm asio.pcm -o test_mod
