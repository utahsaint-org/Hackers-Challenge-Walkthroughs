Convert to unix time/epoc

Key: 1337313370

This is one way to do the coversion (on OSX):
`date -ju -f "%Y/%m/%d %T" "2012/05/18 03:56:10" +"%s"`
  --@voldemortensen
  
There are several online converters as well.
