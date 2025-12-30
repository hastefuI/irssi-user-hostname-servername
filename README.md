# irssi-user-hostname-servername
A patch for [Irssi](https://github.com/irssi/irssi/) that allows customization of the USER command’s hostname and servername parameters.

## Overview
The USER command is sent as part of connection registration to identify the user, as defined in the original IRC protocol specification [RFC-1459](https://www.rfc-editor.org/rfc/rfc1459.html#section-4.1.3):
```
Command: USER
Parameters: <username> <hostname> <servername> <realname>

The USER message is used at the beginning of connection to specify
the username, hostname, servername and realname of a new user.  It is
also used in communication between servers to indicate new user
arriving on IRC, since only after both USER and NICK have been
received from a client does a user become registered.

Between servers USER must to be prefixed with client's NICKname.
Note that hostname and servername are normally ignored by the IRC
server when the USER command comes from a directly connected client
(for security reasons), but they are used in server to server
communication.
```

By default, Irssi sends the local username and server address for the `<hostname>` and `<servername>` parameters in the USER command, which cannot be customized via settings or scripting.

Most traditional IRC daemons ignore client-supplied values for these parameters. However, some implementations that pre-date widespread adoption of [RFC-2812](https://www.rfc-editor.org/rfc/rfc2812.html#section-3.1.3) rely on them for client identification.

This patch introduces two new Irssi settings, `user_hostname` and `user_servername`, which allow the hostname and servername values to override the defaults used in the USER command.

## Quick Start

### Docker
```sh
$ docker build -t irssi-user-hostname-servername .
$ docker run -it --rm irssi-user-hostname-servername
```

### Manual Build
Clone Irssi, apply the [patch](./irssi-user-hostname-servername.patch), and build from source:
```sh
$ git clone https://github.com/irssi/irssi.git
$ cd irssi
$ git apply irssi-user-hostname-servername.patch
# Follow the remaining instructions from:
# https://github.com/irssi/irssi/blob/master/INSTALL
```

## Usage
Set a custom user hostname and servername:
```
/set user_hostname <value>
/set user_servername <value>
```

**Important:** The value must be a single word (no spaces). If spaces are included, the setting is silently ignored and defaults are used.

## Example
Set the user hostname and servername, then connect to a server:
```
/set user_hostname gateway
/set user_servername trophy
/connect tolsun.oulu.fi 6667
```

The following USER command will be sent:
```log
USER username gateway trophy :realname
```

## Issues
For troubleshooting purposes, be sure to include the version of Irssi you're using when opening an issue.

## License
Licensed under [MIT License](https://opensource.org/licenses/MIT), see [LICENSE](./LICENSE) for details.

Copyright (c) 2025 hasteful.
