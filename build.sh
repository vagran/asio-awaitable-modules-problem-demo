#!/bin/bash

set -ev

CXX="/opt/clang-12/bin/clang++"

CXX_FLAGS="-std=c++20 -stdlib=libc++ -Wall -Werror -g -O0"

# Without modules

$CXX -c $CXX_FLAGS ../test.cpp -o test.o

$CXX $CXX_FLAGS test.o -o test

# With modules

CXX_FLAGS="$CXX_FLAGS -fmodules -fimplicit-modules -fmodules-cache-path=modules-cache -DMODULES"

$CXX -c $CXX_FLAGS ../test.cpp -o test.o

$CXX $CXX_FLAGS test.o -o test_mod
