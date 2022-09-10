#!/bin/bash

set -ev

CXX="/home/artyom/tmp/llvm-install/bin/clang++"

CXX_FLAGS="-std=c++20 -stdlib=libc++ -Wall -Werror -g -O0"
CXX_FLAGS="$CXX_FLAGS -fmodules -fimplicit-modules -fmodules-cache-path=modules-cache -DMODULES -fretain-comments-from-system-headers"
CXXM_FLAGS="$CXX_FLAGS --precompile -x c++-module"

DIR=$(pwd)
COMP_DB="compile_commands.json"

dbEntry() {
    cmd=$1
    inFile=$2
    outFile=$3
    echo "{"
    echo "\"directory\":\"$DIR\","
    echo "\"file\":\"$inFile\","
    echo "\"output\":\"$outFile\","
    echo "\"command\":\"$cmd\""
    echo "}"
}

echo "[" > $COMP_DB

inFile="../a.cppm"
outFile="a.pcm"
cmd="$CXX -c $CXXM_FLAGS $inFile -o $outFile -Xclang -emit-module-interface"

dbEntry "$cmd" $inFile $outFile >> $COMP_DB

$cmd

inFile="../a.cpp"
outFile="a.o"
cmd="$CXX -c $CXX_FLAGS -fmodule-file=a.pcm $inFile -o $outFile"

echo "," >> $COMP_DB
dbEntry "$cmd" $inFile $outFile >> $COMP_DB

# $CXX $CXX_FLAGS a.o a.pcm -o test_mod

echo "]" >> $COMP_DB
