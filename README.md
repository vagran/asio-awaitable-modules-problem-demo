Demonstrates problem reported [here](https://github.com/chriskohlhoff/asio/issues/880).

Use the latest Clang (tested with Clang 12 on Ubuntu).

```
git submodule update --init
cd build
../build.sh
export LD_LIBRARY_PATH=/opt/clang-12/lib
./test
./test_mod
```
