# libzbxpython-build

Build and test scripts for [libzbxpython](https://github.com/cavaliercoder/libzbxpython).

## Setup

* Clone python repo
* Clone `libzbxpython` sources into `./libzbxpython`
* Unzip Zabbix sources into `./zabbix-X.X.X` (currently 3.2.0)
* Build the Docker images with `make docker-image`

## Docker images

This repo uses Docker to create immutable build and test environments so that:

* Build and tests run in a known state
* Developer workstation is left alone
* Multiple operating systems can be tested quickly

## Build targets
  
* `make docker-image`:
  
  Builds Docker image required to build, package and test `libzbxpython`

* `make libzbxpython.so`:

  Compiles the main module in place (`./libzbxpython/src/libs/libzbxpython.so`)

* `make docker-agent`:

  Start the module in a Zabbix agent and log to stdout.

* `make docker-agent-shell`:

  Start the module in a Zabbix agent and open a shell in the container.

* `make docker-test`:
  
  Print the output of `zabbix_agentd -p` filtered for lines matching
  `/^python\./`.

* `sudo make docker-shell`:

  Start a shell in the build container.

## License

Copyright (c) 2016 Ryan Armstrong

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
