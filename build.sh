#!/bin/bash

set -ev

CXX="/opt/clang-12/bin/clang++"

CXX_FLAGS="-std=c++20 -stdlib=libc++ -Wall -Werror -g -O0"
CXX_FLAGS="$CXX_FLAGS -fmodules -fimplicit-modules -fmodules-cache-path=modules-cache -DMODULES"
CXXM_FLAGS="$CXX_FLAGS --precompile -x c++-module"
    
$CXX -c $CXXM_FLAGS ../callback.cppm \
     -o callback.pcm \
    -Xclang -emit-module-interface
    
$CXX -c $CXXM_FLAGS -fmodule-file=callback.pcm ../call.cppm \
     -o call.pcm \
    -Xclang -emit-module-interface
    
$CXX -c $CXX_FLAGS -fmodule-file=callback.pcm -fmodule-file=call.pcm \
    ../call.cpp -o call.o

$CXX -c $CXX_FLAGS -fmodule-file=callback.pcm -fmodule-file=call.pcm \
    ../test.cpp -o test.o

$CXX $CXX_FLAGS test.o call.pcm call.o callback.pcm -o test_mod
