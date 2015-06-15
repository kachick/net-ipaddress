net-ipaddress
==============

[![Build Status](https://secure.travis-ci.org/kachick/net-ipaddress.png)](http://travis-ci.org/kachick/net-ipaddress)
[![Gem Version](https://badge.fury.io/rb/net-ipaddress.png)](http://badge.fury.io/rb/net-ipaddress)
[![Dependency Status](https://gemnasium.com/kachick/net-ipaddress.svg)](https://gemnasium.com/kachick/net-ipaddress)

Description
------------

Utils for ipaddresses

Features
--------

* Usuful methods
* Immutable
* Now, supporting version4

Usage
-----

### Setup

```ruby
require 'net/ipaddress'
include Net
```

### Basic

```ruby
ip1 = IPAddress('192.168.1.1/24')
ip2 = IPAddress('192.168.1.10/24')
ip3 = IPAddress('192.168.0.0/16')
ip1.segment? ip2 #=> true
ip2.segment? ip1 #=> true
ip1.segment? ip3 #=> false
ip1.cover? ip3   #=> false
ip3.cover? ip1   #=> true
```

### IPAddr <-> Net::IPAddress

```ruby
require 'net/ipaddress/ext/ipaddr'

IPAddr.new('192.168.1.1/24') == IPAddress('192.168.1.1/24').network #=> true
```

Requirements
------------

* [Ruby 2.0.0 or later](http://travis-ci.org/#!/kachick/net-ipaddress)

Installation
-------------

```shell
$ gem install net-ipaddress
```

Link
----

* [code](https://github.com/kachick/net-ipaddress)
* [issues](https://github.com/kachick/net-ipaddress/issues)
* [CI](http://travis-ci.org/#!/kachick/net-ipaddress)
* [gem](https://rubygems.org/gems/net-ipaddress)
* [API-documents](http://www.rubydoc.info/github/kachick/net-ipaddress)

License
-------

The MIT X11 License  
Copyright (c) 2012 Kenichi Kamiya  
See MIT-LICENSE for further details.
