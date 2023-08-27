/-  *timezones
/+  *parser-util, tz=timezones, util=time-utils
|%
++  opt  |*(=rule ;~(pose (cook some rule) (easy ~)))
++  from-digits
  |=  l=(list @)
  `@ud`(roll l |=([cur=@ud acc=@ud] (add (mul 10 acc) cur)))
:: parse one or two digits
::
++  one-or-two  (cook from-digits (stun [1 2] dit))
::  parse into [hours=@ud ~[minutes=@ud seconds=@ud]]
::  seconds might not be present though.
::
++  parse-time-to-dits
  ;~(plug one-or-two (stun [0 2] (cook tail ;~(plug col one-or-two))))
::
++  dits-to-dr
  |=  [hr=@ud l=(list @ud)]
  ^-  @dr
  =/  hours=@dr  (mul hr ~h1)
  ?~  l  hours
  =/  minutes=@dr  (mul i.l ~m1)
  =/  seconds=@dr  ?~(t.l ~s0 (mul i.t.l ~s1))
  :(add hours minutes seconds)
::  +parse-time: rule for parsing time in HH:MM or HH:MM:SS format. does
::  not assume leading zeros (will parse 1:00 and 01:00 identically).
::  parses 0 as ~s0, 1 as ~h1, etc.
::
++  parse-time  (cook dits-to-dr parse-time-to-dits)
::  +parse-delta: rule for parsing signed time cord in HH:MM or HH:MM:SS format.
::  see +parse-time for specifics.
::
++  parse-delta  ;~(plug optional-sign parse-time)
::
++  parse-ugz-sw
    %+  stun  [0 1]
    ;~  pose
      (jest 'u')  (jest 'g')  (jest 'z') :: UTC/Greenwich/Zulu
      (jest 's')                         :: standard local time
      (jest 'w')                         :: wallclock (default)
    ==
::
++  letter-to-usw
  |=  l=(list @t)
  ^-  usw:iana
  ?~  l  %wallclock :: default
  ?+  i.l  ~|(%usw-error !!)
    ?(%u %g %z)  %utc
    %s           %standard
    %w           %wallclock
  ==
::
++  parse-usw  (cook letter-to-usw parse-ugz-sw)
::
++  parse-at   (cook |*([a=* b=*] [b a]) ;~(plug parse-time parse-usw))
::
++  parse-gte  ;~(plug (plus alf) ;~(pfix (jest '>=') (stun [1 2] dit)))
::
++  gte-to-aft
  |=  [w=tape l=(list @t)]
  ^-  rule-on:iana
  [%aft (from-digits l) ;;(wkd:tz (crip (cass w)))]
::
++  parse-aft  (cook gte-to-aft parse-gte)
++  parse-dat  (cook |=(l=(list @) [%dat (from-digits l)]) (stun [1 2] dit))
::
++  parse-ord-wkd  ;~(pfix (jest 'last') (plus alf))
++  wkd-to-int
  |=(w=tape [%int %last ;;(wkd:tz (crip (cass w)))])
++  parse-int  (cook wkd-to-int parse-ord-wkd)
::  +parse-on: rule for parsing the 'ON' component of a rule-entry.
::  Is also used to parse part of the 'UNTIL' component
::
++  parse-on  ;~(pose parse-aft parse-dat parse-int)
::
++  parse-mnt  (cook |=(t=tape ;;(mnt:tz (crip (cass t)))) (plus alp))
++  parse-year  (cook from-digits (plus dit))
::  +can-skip: skip lines that are all whitespace and comments (start
::  with '#') as well as blank lines.
::
++  can-skip
  |=  line=tape
  ^-  ?
  ?|  (matches line whitespace)
      (startswith line (jest '#'))
      =(line "")
  ==
::
++  is-zone-line  |=(line=tape `?`(startswith line (jest 'Zone')))
++  is-rule-line  |=(line=tape `?`(startswith line (jest 'Rule')))
++  is-link-line  |=(line=tape `?`(startswith line (jest 'Link')))
::  +parse-zone: given lines, produce zone and continuation
::
++  parse-zone
  |=  lines=wall
  |^  ^-  [zone:iana wall]
  ?>  ?=(^ lines)
  ::  first line is different than continuation line so we process it
  ::  separately.
  =/  [name=@t first-line=tape]  (parse-first-line i.lines)
  =|  entries=(list zone-entry:iana)
  =/  lines=wall  [first-line t.lines]
  |-  ?~  lines  [[name entries] ~]
  ?:  (can-skip i.lines)  $(lines t.lines)
  =/  entry=(unit zone-entry:iana)  (parse-zone-entry i.lines)
  ::  if entry is ~, then the line was not parseable as a continuation
  ::  to the current zone - bail out.
  ?~  entry          [[name entries] lines]
  ?~  until.u.entry  [[name [u.entry entries]] t.lines]
  $(lines t.lines, entries [u.entry entries])
  ::
  ++  parse-name  (plus ;~(pose aln cab fas hep))
  ++  parse-first-line
    |=  line=tape
    ^-  [@t tape]
    =;  [@t ~ name=tape continuation=tape]  [(crip name) continuation]
    (scan line ;~(plug (jest 'Zone') whitespace parse-name (plus next)))
  ::  +parse-zone-entry: parses a continuation line
  ::
  ++  parse-zone-entry
    |=  line=tape
    ^-  (unit zone-entry:iana)
    %+  rust  line
    ;~  plug
      ;~(pfix whitespace parse-delta)       :: STDOFF
      ;~(pfix whitespace parse-zone-rule)   :: RULES
      ;~(pfix whitespace parse-format)      :: FORMAT
      (opt ;~(pfix whitespace parse-until)) :: UNTIL
    ==
  ::
  ++  parse-format  (cook crip (plus ;~(pose aln cen hep fas lus)))
  ::
  ++  parse-zone-rule
    |^ :: beware of order of parsing hep
    ;~(pose delta-rule nothing-rule named-rule)
    ++  delta-rule
      (cook |=(d=delta `zone-rules:iana`[%delta d]) parse-delta)
    ++  nothing-rule  (cook |=(* `zone-rules:iana`[%nothing ~]) hep)
    ++  named-rule
      %+  cook
        |=  name=tape
        `zone-rules:iana`[%rule `@ta`(crip name)]
      (plus ;~(pose alf cab hep))
    --
  ::
  ++  parse-until
    |^  (cook build-until parser)
    ++  parser
      ;~  plug
        parse-year :: whitespace already taken care of
        (opt ;~(pfix whitespace parse-mnt))
        (opt ;~(pfix whitespace parse-on))
        (opt ;~(pfix whitespace parse-at))
      ==
    ++  build-until
      |=  [y=@ud mnt=(unit mnt) on=(unit rule-on:iana) at=(unit at:iana)]
      ^-  (pair usw:iana @da)
      ?~  mnt  wallclock+(year [[& y] 1 [1 0 0 0 ~]])
      =/  m=@ud  (mnt-to-num:util u.mnt)
      ?~  on   wallclock+(year [[& y] m [1 0 0 0 ~]])
      =/  =usw:iana  ?~(at %wallclock p.u.at)
      =/  hmsf=@dr   ?~(at ~s0 q.u.at)
      =;  =time  [usw time]
      %+  add  hmsf  %-  need
      ?-    -.u.on
        %int  (nth-weekday:tz [& y] m ord.u.on (wkd-to-num:util wkd.u.on))
        %aft  (first-weekday-after:tz [& y] m d.u.on (wkd-to-num:util wkd.u.on))
        %dat  (date-of-month:tz [& y] m d.u.on)
      ==
    --
  --
::
++  parse-rule
  |=  lines=wall
  |^  ^-  [rule:iana wall]
  =;  [entries=(list rule-entry:iana) name=@ta continuation=wall]
    ?~  entries  !! :: must have at least one entry
    [`rule:iana`[name (sy entries)] continuation]
  =|  entries=(list rule-entry:iana)
  =|  rule-name=@ta
  |-  ?~  lines  [entries rule-name ~]
  ::  FIXME: currently special cases out lines containing '<=' as well.
  ::  This is only used once as of 02/21/2021 - for Rule 'Zion'
  ::  and isn't currently supported.
  ?:  ?|  (can-skip i.lines)
          =-  ~?(- skip-lte+i.lines -)
          !=((find "<=" i.lines) ~)
      ==
    $(lines t.lines)
  ?.  (is-rule-line i.lines)  [entries rule-name lines]
  =/  [name=@ta entry=rule-entry:iana]  (parse-rule-entry i.lines)
  ?:  =(*@ta name)  ~|(%need-rule-name !!)
  ?:  &(?=(^ entries) !=(name rule-name))  [entries rule-name lines]
  $(lines t.lines, entries [entry entries], rule-name name)
  ::  +parse-rule-entry: produce rule entry and name from a line
  ::
  ++  parse-rule-entry
    |=  line=tape
    |^  ^-  [@ta rule-entry:iana]
    %+  scan  line
    ;~  pfix
      ;~(plug (jest 'Rule') whitespace) :: ignore 'Rule' identifier
      ;~  (glue whitespace)
        parse-name                :: NAME
        parse-year                :: FROM (year)
        parse-to                  :: TO 
        ;~  pfix
          ;~(plug hep whitespace) :: ignore vestigial column
          parse-mnt               :: IN
        ==
        parse-on                         :: ON
        parse-at                         :: AT
        parse-delta                      :: SAVE
        parse-letter                     :: LETTER/S
      ==
    ==
    ++  parse-name    (cook crip (plus ;~(pose alf cab hep)))
    ++  parse-letter  (cook crip (plus ;~(pose aln hep lus)))
    ++  parse-to
      ;~  pose
        (cook (lead %year) parse-year)
        (cold [%only ~] (jest 'only'))
        (cold [%max ~] (jest 'max'))
      ==
    --
  --
::  +parse-link: parse a link line (creates timezone alias). head of
::  cell is the name of the alias and the tail is the existing zone.
::
++  parse-link
  |=  line=tape
  ^-  [@t @t]
  =/  tokens=wall  (split line whitespace)
  [(crip (snag 2 tokens)) (crip (snag 1 tokens))]
::
++  clean-line
  |=  line=tape
  ^-  tape
  =.  line  (remove-inline-comments line)
  (strip-trailing-whitespace line)
::  +parse-timezones: top level parser to go from file contents to
::  rules and zones (keyed by name)
::
++  parse-timezones
  |=  lines=wall
  ^-  iana
  =|  iana-data=iana
  =.  lines  (turn lines clean-line)
  |-  ?~  lines  iana-data
  :: SKIP LINES
  :: 
  ?:  (can-skip i.lines)  $(lines t.lines)
  :: PARSE RULE
  ::
  ?:  (is-rule-line i.lines)
    =/  [=rule:iana continuation=wall]  (parse-rule lines)
    %=    $
        lines  continuation
        rules.iana-data
      ?~  get=(~(get by rules.iana-data) name.rule)
        (~(put by rules.iana-data) name.rule rule)
      =.  rule  [name.rule (~(uni in entries.rule) entries.u.get)]
      (~(put by rules.iana-data) name.rule rule)
    ==
  :: PARSE ZONE
  ::
  ?:  (is-zone-line i.lines)
    =/  [=zone:iana continuation=wall]  (parse-zone lines)
    %=    $
        lines  continuation
        zones.iana-data
      ?<  (~(has by zones.iana-data) name.zone)
      (~(put by zones.iana-data) name.zone zone)
    ==
  :: PARSE LINK
  ::
  ?:  (is-link-line i.lines)
    =/  [alias=@t real=@t]  (parse-link i.lines)
    %=    $
        lines  t.lines
        links.iana-data
      ?<  (~(has by links.iana-data) alias)
      (~(put by links.iana-data) alias real)
    ==
  :: SKIP UNPARSEABLE
  ~&  [%unparseable-timezone-line i.lines]
  $(lines t.lines)
--
