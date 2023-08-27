/-  *timezones, *rules
/+  timezones
|_  [=bowl:gall iana] 
+*  n  ~(. timezones [bowl ~])
:: Given a rule entry, get a first pass at the rule parameters
::
++  rule-entry-to-rid-args
  |=  rule-entry:iana
  ^-  [rid:n args:n]
  ?-    -.on
      %int
    :-  [~ %jump %yearly-nth-weekday-of-month-0]
    %-  ~(gas by *args)
    :~  ['Start Year' ud+from]
        ['Month' ud+(mnt-to-num in)]
        ['Ordinal' od+ord.on]
        ['Weekday' ud+(wkd-to-num wkd.on)]
        ['Time' dr+q.at]
        ['Offset' dl+*delta] :: This is updated in a later pass...
    ==
    ::
      %aft
    :-  [~ %jump %yearly-first-weekday-after-date-0]
    %-  ~(gas by *args)
    :~  ['Start Year' ud+from]
        ['Month' ud+(mnt-to-num in)]
        ['Day' ud+d.on]
        ['Weekday' ud+(wkd-to-num wkd.on)]
        ['Time' dr+q.at]
        ['Offset' dl+*delta] :: This is updated in a later pass...
    ==
    ::
      %dat
    :-  [~ %jump %yearly-on-date-0]
    %-  ~(gas by *args)
    :~  ['Start Year' ud+from]
        ['Month' ud+(mnt-to-num in)]
        ['Day' ud+d.on]
        ['Time' dr+q.at]
        ['Offset' dl+*delta] :: This is updated in a later pass...
    ==
  ==
:: Given a rule entry, get the parameters for creating a
:: "rule" of our explicit instance-based kind.
:: Add one rule for each year so that specific
:: utc/standard/wallclock jump time is handled for each instance
::
++  rule-entry-to-create-rule-parms
  |=  re=rule-entry:iana
  ^-  (list [tid:n dom=[l=@ud r=@ud] @t delta rid:n args:n])
  =/  name=@t       letter.re :: This name will be fixed in a later pass...
  =/  offset=delta  save.re   :: This will be updated in a later pass...
  =/  [=rid:n =args:n]  (rule-entry-to-rid-args re)
  =/  num=@ud
    ?-  -.to.re
      %year  (sub y.to.re from.re)
      %only  0
      %max   100 :: only 100 iterations if it goes into present time
    ==
  :: Return rule creation parms one for each year of this rule-entry
  |-
  =.  args  (~(put by args) 'Start Year' ud+(add from.re num))
  :-  [(scot %uv (sham [re num])) [0 0] name offset rid args]
  ?:  =(0 num)  ~
  $(num (dec num))
:: Use this to reference already-created rules
::
++  get-rule-entry-tids
  |=  re=rule-entry:iana
  ^-  (list tid:n)
  =/  num=@ud
    ?-  -.to.re
      %year  (sub y.to.re from.re)
      %only  0
      %max   100 :: only 100 iterations if it goes into present time
    ==
  |-
  :-  (scot %uv (sham [re num]))
  ?:  =(0 num)  ~
  $(num (dec num))
:: Create rules in a zone based on given parameters...
::
++  create-rules-in-zone
  |=  [=zid:n =zone:n rules=(list [tid:n [@ud @ud] @t delta rid:n args:n])]
  ^-  zone:n
  =/  core  ~(. zn:n [zid zone])
  |-  ?~  rules  zon:abet:core
  %=  $
    rules  t.rules
    core   (create-rule:core i.rules)
  ==
::
++  enta-name
  |=  =@t
  ^-  @ta
  =-  ?>(((sane %ta) -) -)
  %-  crip
  %+  turn  (cass (trip t))
  |=(=@t ?.(=('/' t) t '_'))
:: A "raw rule" is a rule which has not been updated with the zone
:: offset yet...
::
++  iana-rule-to-raw-rule-zone
  |=  =rule:iana
  ^-  [zid:n zone:n]
  =/  =zid:n  [our.bowl (rap 3 'iana_raw-rule_' (enta-name name.rule) ~)]
  ~&  [%making-raw-rule zid]
  =|  =zone:n
  =.  name.zone  name.rule
  =/  rules  (zing (turn ~(tap in entries.rule) rule-entry-to-create-rule-parms))
  [zid (create-rules-in-zone zid zone rules)]
:: Initialize all the existing iana rules as "raw rule" zones
::
++  all-raw-rule-zones
  ^-  (map zid:n zone:n)
  %-  ~(gas by *(map zid:n zone:n))
  (turn ~(val by rules) iana-rule-to-raw-rule-zone)
:: Correct a iana rule name based on a iana zone name
::
++  new-rule-name
  |=  [=tz-rule:n format=@t]
  ^-  @t
  ?:  =('%z' format)
    =/  sign=tape  ?:(sign.offset.tz-rule "+" "-")
    =/  d=tape     (scow %dr d.offset.tz-rule)
    (crip "UTC {sign} {d}")
  =/  name=tape  (trip format)
  =/  s  (find "%s" name)
  ?:  ?=(^ s)
    %-  crip
    ;:  weld
      (scag u.s name)
      (trip name.tz-rule)
      (slag (add u.s 2) name)
    ==
  =/  f  (find "/" name)
  ?:  ?=(^ f)
    ?:  =([& ~s0] offset.tz-rule)
      (crip (scag u.f name))
    (crip (slag +(u.f) name))
  ?.  |(=('-' name.tz-rule) =('' name.tz-rule))
    name.tz-rule
  (crip name)
:: based on raw-rule and zone offset, get the properly adjusted
:: rule (where the offset is ABSOLUTE relative to UTC)
::
++  raw-rule-zone-adjust-offset
  |=  [offset=delta =rule:iana =zid:n =zone:n]
  ^-  zone:n
  =/  old   ~(. zn:n [zid zone])
  =/  core  ~(. zn:n [zid zone])
  =/  rules  ~(tap in entries.rule)
  |-
  ?~  rules  zon:abet:core
  =/  tids=(list tid:n)  (get-rule-entry-tids i.rules)
  |-
  ?~  tids  ^$(rules t.rules)
  =/  =tz-rule:n  (~(got by rules.zone) i.tids)
  :: update offset according to zone
  ::
  =/  new-offset=delta  (compose-deltas offset offset.tz-rule)
  =.  core  (update-rule:core i.tids [%offset new-offset]~)
  :: update args according to zone offset
  ::
  =/  [=rid:n =args:n]  rule.tz-rule
  =.  args
    ?-    p.at.i.rules
        %utc
      (~(put by args) 'Offset' dl+*delta)
      ::
        %standard
      (~(put by args) 'Offset' dl+offset)
      ::
        %wallclock
      :: get only instance of the rule
      ::
      =/  jmp=jump-instance  (~(got by instances.tz-rule) l.dom.tz-rule)
      ?.  ?=(%& -.jmp)  args
      :: get previous offset
      ::
      ?~  pof=(~(pof or:old order.zone) p.jmp)
        (~(put by args) 'Offset' dl+offset)
      (~(put by args) 'Offset' dl+(compose-deltas offset u.pof))
    ==
  $(tids t.tids, core (update-rule-args:core i.tids rid args))
:: based on all raw rules, a rule name and the zone offset
:: get the properly adjusted rule
:: (where the offset is ABSOLUTE relative to UTC)
::
++  get-offsetted-rule
  |=  [new-rules=(map zid:n zone:n) name=@t stdoff=delta]
  ^-  [zid:n zone:n]
  =/  rule-id=zid:n  [our.bowl (rap 3 'iana_raw-rule_' (enta-name name) ~)]
  =/  rule=zone:n    (~(got by new-rules) rule-id)
  =/  old=rule:iana  (~(got by rules) name)
  :: adjust offset with zone offset
  ::
  [rule-id (raw-rule-zone-adjust-offset stdoff old rule-id rule)]
:: convert a iana zone to our zone format
::
++  iana-zone-to-new-zone
  |=  [name=@t z=zone:iana new-rules=(map zid:n zone:n)]
  ^-  [zid:n zone:n]
  =/  =zid:n  [our.bowl (rap 3 'iana_' (enta-name name) ~)]
  ~&  [%converting zid]
  =|  =zone:n
  =.  name.zone  name.z
  =/  entries  (flop entries.z)
  =|  last=(unit @da)
  =|  next=(unit @da)  
  |-  ?~  entries  [zid zone]
  =.  next
    ?~  until.i.entries  ~
    ?-    p.u.until.i.entries
      %utc  `q.u.until.i.entries
      %standard  `(apply-delta q.u.until.i.entries stdoff.i.entries)
        %wallclock
      ?-    -.rules.i.entries
        %nothing  `(apply-delta q.u.until.i.entries stdoff.i.entries)
          %delta
        =/  offset=delta  (compose-deltas [stdoff delta.rules]:i.entries)
        `(apply-delta q.u.until.i.entries offset)
          %rule
        =/  [rule-id=zid:n rule=zone:n]
          ~+((get-offsetted-rule new-rules name.rules.i.entries stdoff.i.entries))
        =/  core  ~(. zn:n [rule-id rule])
        ?^  pof=(~(pof or:core order.rule) q.u.until.i.entries)
          `(apply-delta q.u.until.i.entries u.pof)
        `(apply-delta q.u.until.i.entries stdoff.i.entries)
      ==
    ==
  :: Add a single rule which jumps at the beginning of the "bout"
  ::
  =/  single=(list [tid:n [@ud @ud] @t delta rid:n args:n])
    :: if last is null, give default beginning of Jan 1, 1970
    =/  =time  (fall last ?~(next ~1800.1.1 (min ~1800.1.1 u.next)))
    =/  offset=delta
      ?-    -.rules.i.entries
        %nothing  stdoff.i.entries
        %delta    (compose-deltas [stdoff delta.rules]:i.entries)
          %rule
        =/  [rule-id=zid:n rule=zone:n]
          ~+((get-offsetted-rule new-rules name.rules.i.entries stdoff.i.entries))
        =/  core  ~(. zn:n [rule-id rule])
        ?^  pof=(~(pof or:core order.rule) time)
          u.pof
        stdoff.i.entries
      ==
    :: Name the single rule
    :: TODO: give rule name if applicable
    ::
    =/  sign=tape  ?:(sign.offset "+" "-")
    =/  d=tape     (scow %dr d.offset)
    =/  name=@t    (crip "UTC {sign} {d}")
    [(scot %uv (sham [last eny.bowl])) [0 0] name offset [~ %jump %single-0] (~(gas by *args:n) ['Time' da+time]~)]~
  :: Add overlapping rules
  ::
  =/  rules=(list [tid:n [@ud @ud] @t delta rid:n args:n])
    ?.  ?=(%rule -.rules.i.entries)  ~
    =/  [rule-id=zid:n rule=zone:n]
      ~+((get-offsetted-rule new-rules name.rules.i.entries stdoff.i.entries))
    =/  core  ~(. zn:n [rule-id rule])
    %+  turn  ~(tap by rules:zon:abet:(clip-rules:core last next))
    |=  [=tid:n =tz-rule:n]
    =.  name.tz-rule  (new-rule-name tz-rule format.i.entries)
    [tid [dom name offset rid.rule args.rule]:tz-rule]
  %=  $
    last     next
    entries  t.entries
    zone     (create-rules-in-zone zid zone (weld single rules))
  ==
:: Initialize rules to "raw rules" and convert all zones
::
++  convert-iana-zones-new
  ^-  (map zid:n zone:n)
  =/  new-rules=(map zid:n zone:n)  all-raw-rule-zones
  %-  ~(gas by *(map zid:n zone:n))
  %+  turn  ~(tap by zones)
  |=  [name=@t =zone:iana]
  (iana-zone-to-new-zone name zone new-rules)
--
