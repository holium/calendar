/+  *timezones-json
|_  pyk=peek
++  grow
  |%
  ++  noun  pyk
  ++  json
    =,  enjs:format
    %.  pyk
    |=  pyk=peek
    ^-  ^json
    ?-  -.pyk
      %zones  (zones:enjs zones.pyk)
      %zone   (zone:enjs zone.pyk)
      %flags  a+(turn flags.pyk |=(=zid s+(zid:enjs zid)))
    ==
  --
++  grab
  |%
  ++  noun  peek
  --
++  grad  %noun
--
