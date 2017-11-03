# DESCRIPTION: #

~~~~
It's "time" to bring your "epoch" l33t skills:

    Saturday, April 20, 2069 6:55:37 PM GMT-06:00 DST
~~~~

## Hint ##

~~~~
$ man Time::Local

timegm( $sec, $min, $hour, $mday, $mon, $year );
~~~~


# WALKTHROUGH: #

Find GMT time epoch for 6 hours before the target, then add 6 hours worth of seconds to get the actual epoch:

~~~~
$ perl -MTime::Local -le 'print timegm(37,55,18, 20,3,2069) + 6*3600;'
~~~~
