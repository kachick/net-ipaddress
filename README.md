# net-ipaddress

![Build Status](https://github.com/kachick/net-ipaddress/actions/workflows/test_behaviors.yml/badge.svg?branch=main)
[![Gem Version](https://badge.fury.io/rb/net-ipaddress.png)](http://badge.fury.io/rb/net-ipaddress)

ipaddress utilities (Currently supporting only for V4)

## Usage

Require Ruby 2.7 or later

Add below code into your Gemfile

```ruby
gem 'net-ipaddress', '~> 0.3.0'
```

### Overview

```ruby
require 'net/ipaddress'
```

```ruby
ip1 = Net::IPAddress('192.168.1.1/24')
ip2 = Net::IPAddress('192.168.1.10/24')
ip3 = Net::IPAddress('192.168.0.0/16')
ip1.segment?(ip2) #=> true
ip2.segment?(ip1) #=> true
ip1.segment?(ip3) #=> false
ip1.cover?(ip3)   #=> false
ip3.cover?(ip1)   #=> true
```

### IPAddr <-> Net::IPAddress

```ruby
require 'net/ipaddress/ext/ipaddr'

IPAddr.new('192.168.1.1/24') == Net::IPAddress('192.168.1.1/24').network #=> true
```

## Links

* [Repository](https://github.com/kachick/net-ipaddress)
* [API documents](https://kachick.github.io/net-ipaddress/)
