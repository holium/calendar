/-  *timezones
|%
++  dejs
  =,  dejs:format
  |%
  ++  iana-action
    ^-  $-(json action:iana)
    %-  of
    :~  [%leave-iana ul]
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  enjs-at
    |=  at=(pair usw:iana @dr)
    ^-  json
    =/  =tarp  (yell q.at)
    %-  pairs
    :~  [%type s+p.at]
        [%d (numb d.tarp)]
        [%h (numb h.tarp)]
        [%m (numb m.tarp)]
        [%s (numb s.tarp)]
    ==
  ::
  ++  enjs-delta
    |=  delta
    ^-  json
    %-  pairs
    :~  [%sign b+sign]
        [%diff (to-hms d)]
    ==
  ::
  ++  to-hms
    |=  =@dr
    ^-  json
    =/  hms  (yell dr)
    %-  pairs
    :~  [%h (numb h.hms)]
        [%m (numb m.hms)]
        [%s (numb s.hms)]
    ==
  ::
  ++  enjs-zone-rules
    |=  =zone-rules:iana
    ^-  json
    %+  frond  -.zone-rules
    ?-  -.zone-rules
      %nothing  ~
      %delta    (enjs-delta delta.zone-rules)
      %rule     s+name.zone-rules
    ==
  ::
  ++  enjs-until
    |=  =until:iana
    ^-  json
    ?~  until  ~
    (pairs ~[p+s+p.u.until q+s+(scot %da q.u.until)])
  ::
  ++  enjs-rule-on
    |=  =rule-on:iana
    ^-  json
    ?-  -.rule-on
      %int  (pairs ~[[%type s+%int] [%ord s/ord.rule-on] [%wkd s+wkd.rule-on]])
      %aft  (pairs ~[[%type s+%aft] [%d (numb d.rule-on)] [%wkd s+wkd.rule-on]])
      %dat  (pairs ~[[%type s+%dat] [%d (numb d.rule-on)]])
    ==
  ::
  ++  enjs-rule-entry
    |=  =rule-entry:iana
    ^-  json
    %-  pairs
    :~  from+s+(scot %ud from.rule-entry)
        to+?-(-.to.rule-entry %max s+%max, %only s+%only, %year s+(scot %ud y.to.rule-entry))
        in+s+in.rule-entry
        on+(enjs-rule-on on.rule-entry)
        at+(frond p.at.rule-entry s/(scot %dr q.at.rule-entry))
        save+(enjs-delta save.rule-entry)
        letter+s+letter.rule-entry
    ==
  ::
  ++  enjs-zone-entry
    |=  =zone-entry:iana
    ^-  json
    %-  pairs
    :~  stdoff+(enjs-delta stdoff.zone-entry)
        rules+(enjs-zone-rules rules.zone-entry)
        format+s+format.zone-entry
        until+(enjs-until until.zone-entry)
    ==
  ::
  ++  enjs-iana-rule
    |=  =rule:iana
    ^-  json
    %-  pairs
    :~  name+s+name.rule
        entries+a+(turn ~(tap in entries.rule) enjs-rule-entry)
    ==
  ::
  ++  enjs-iana-zone
    |=  =zone:iana
    ^-  json
    %-  pairs
    :~  name+s+name.zone
        entries+a+(turn entries.zone enjs-zone-entry)
    ==
  ::
  ++  enjs-iana-zones
    |=  =zones:iana
    ^-  json
    =-  o/(malt -)
    ^-  (list [@t json])
    %+  turn  ~(tap by zones)
    |=  [t=@ta =zone:iana]
    [t (enjs-iana-zone zone)]
  ::
  ++  enjs-rules
    |=  =rules:iana
    ^-  json
    =-  o/(malt -)
    ^-  (list [@t json])
    %+  turn  ~(tap by rules)
    |=  [t=@ta =rule:iana]
    [t (enjs-iana-rule rule)]
  ::
  ++  enjs-links
    |=  =links:iana
    ^-  json
    =-  o/(malt -)
    ^-  (list [@t json])
    %+  turn  ~(tap by links)
    |=([k=@t v=@t] [k s+v])
  ::
  ++  enjs-iana-data
    |=  iana-data=(unit iana)
    ^-  json
    ?~  iana-data  ~
    %-  pairs
    :~  zones+(enjs-iana-zones zones.u.iana-data)
        rules+(enjs-rules rules.u.iana-data)
        links+(enjs-links links.u.iana-data)
    ==
  --
--
