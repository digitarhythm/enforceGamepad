# NDLog
console log like NSLog

## Usage(CoffeeScript)
    
    echo = require("ndlog").echo
    form = require("ndlog").form
    
    foo = "123"
    bar = "456"
    echo("foo=%@, bar=%@", foo, bar)
    
    foo = "abc"
    bar = "def"
    str = form("foo=%@, bar=%@", foo, bar)
    console.log(str)

## output
    foo=123, bar=456
    foo=abc, bar=def

## explain
    'echo' is string display when 'NODE_ENV' environment is 'develop'.
     Not display when 'NODE_ENV' is not 'develop'.
     'form' is return format string.
     'form' is return zero binding number too.
     Write "%@" in the place where you want to display the variable.

## examplle
    echo("foo=%@", "abc") -> foo=abc
    echo("bar=%05@", 12) -> bar=00012



The MIT License (MIT)
Copyright (c) 2017 Hajime Oh-yake

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
