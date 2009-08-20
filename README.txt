= sh.inatra

CGI shell script framework looks like sinatra.

== Description

sh.inatra is a Web CGI application framework for bash script.
It's a parody of "sinatra" in Ruby.

sh.inatra is just a joke soft (but it works!),
so don't use in your production code.

== Requirements

* bash 3.2
* rm command (I suppose you already have it)
* Apache

== Install

Just copy sh.inatra.sh to some directory.

== Examples

  #!/bin/bash

  . /opt/sh.inatra/sh.inatra.sh

  get '/hello' && {
    echo 'Hello, World'
  }

  get '/say/*/to/*' && {
    echo Say ${params_splat[0]} to ${params_splat[1]}
  }

== Functions

(TBD)

=== get pathname
=== post pathname
=== content_type some-type [:charset some-charset]
=== status some-http-status
=== redirect pathname

== Debug tool

You can run your sh.inatra scripts in command line for debug.

$ sh inatra /path/to/hello.cgi

== License

The MIT License

Copyright (c) 2009 emasaka

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
