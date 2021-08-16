#!/bin/bash

set -ev

CXX="/opt/clang-12/bin/clang++"

# Without modules
CXX_FLAGS="-std=c++20 -stdlib=libc++ -Wall -Werror -g -O0 -DASIO_STANDALONE -DASIO_NO_DEPRECATED -pthread"

$CXX $CXX_FLAGS -I../asio/asio/include ../test.cpp -o test

# With modules
CXX_FLAGS="$CXX_FLAGS -fmodules -fimplicit-modules -fmodules-cache-path=modules-cache -DMODULES"
CXXM_FLAGS="$CXX_FLAGS --precompile -x c++-module"

$CXX -c $CXXM_FLAGS ../asio.cppm -I../asio/asio/include \
    -fmodule-map-file=../asio.modulemap \
     -o asio.pcm \
    -Xclang -emit-module-interface

$CXX -c $CXX_FLAGS -fmodule-file=asio.pcm -fmodule-map-file=../asio.modulemap \
    ../test.cpp -o test.o

$CXX $CXX_FLAGS test.o asio.pcm -o test_mod
