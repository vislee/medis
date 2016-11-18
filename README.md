## Medis

-------------------------------------------

Medis is based on redis2.0 added a part of memcached command


### Building Medis

--------------

It is as simple as:

    % make medis-server

Medis is just a single binary, but if you want to install it you can use
the "make install" target that will copy the binary in /usr/local/sbin
for default.


### Running Medis

-------------

To run Redis with the default configuration just type:

    % ./medis-server

If you want to provide your medis.conf, you have to run it using an additional
parameter (the path of the configuration file):

    % ./medis-server /path/to/medis.conf



### Playing with Medis

------------------

You can use redis-cli to play with Medis. Start a medis-server instance,
then in another terminal try the following:

    % redis-cli -h 127.0.0.01 -p 6379
    redis> ping
    PONG
    redis> set foo bar
    OK
    redis> get foo
    "bar"
    redis> incr mycounter
    (integer) 1
    redis> incr mycounter
    (integer) 2
    redis> 


You can also use telnet to play with Medis. Start a medis-server instance,
then in another terminal try the following:

    % telnet 127.0.0.1 11211
    Trying 127.0.0.1...
    Escape character is '^]'.
    set book 123 1000 5
    redis
    STORED
    get book
    VALUE book 123 5
    redis
    END
    quit
    Connection closed by foreign host.

    % redis-cli -h 127.0.0.01 -p 6379
    redis> ping
    PONG
    redis> get book
    "redis



### Support memcached command:

--------------------

set
add
replace
append
prepend
get
gets
delete
incr
decr


### Slaveof command mapping:

--------------------

set -> setex setflag
add -> set
replace -> set
append -> append
prepend -> prepend
delete -> del
incr -> incrby
decr -> decrby


### To add or modify some of the redis command:

--------------------------

append
prepend
setflag
getflag
