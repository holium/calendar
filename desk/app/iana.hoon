/-  *timezones
/+  iana-parser, parser-util,
    verb, dbug, default-agent
/=  f-  /ted/fetch-timezone
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 next=(unit @da) iana-data=(unit iana)]
+$  card  card:agent:gall
--
::
%-  agent:dbug
%+  verb  |
=|  state-0
=*  state  -
=<
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> [bowl ~])
    cc    |=(cards=(list card) ~(. +> [bowl cards]))
::
++  on-init   on-init:def
++  on-save   !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  `this(state old)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ?+    mark  (on-poke:def mark vase)
      %noun
    ?+    q.vase  (on-poke:def mark vase)
        %start-thread
      =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
      =/  ta-now  `@ta`(scot %da now.bowl)
      =/  start-args
        [~ `tid byk.bowl(r da+now.bowl) %fetch-timezone !>(~)]
      :_(this [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]~)
    ==
      %iana-action
    =/  axn  !<(action:iana vase)
    ?-    -.axn
        %leave-iana
    ?>  ?=(^ next)
    =/  nxt=@da  u.next
    :_  this(next ~, iana-data ~)
    :~  [%give %fact ~[/change] noun+!>(0)]
        [%pass /timer %arvo %b %rest nxt]
    ==
    ::
        %watch-iana
    ?^  next  `this :: already watching, ignore
    =/  nxt=@da  (add now.bowl ~d1)
    :_  this(next (some nxt))
    [%pass /timers %arvo %b %wait nxt]~
    ::  
        %import-blob
      =^  cards  state
        abet:(import-blob:hc data.axn)
      [cards this]
    ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?.  ?=([%change ~] path)
    (on-watch:def path)
  :_(this [%give %fact ~ noun+!>(0)]~)
::
++  on-leave  on-leave:def
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %iana ~]  ``iana-data+!>(iana-data)
    [%x %watch ~]  ``loob+!>(?=(^ next))
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%thread *]
    ?+    -.sign  (on-agent:def wire sign)
        %poke-ack
      ?~  p.sign
        %-  (slog leaf+"Thread started successfully" ~)
        `this
      %-  (slog leaf+"Thread failed to start" u.p.sign)
      `this
    ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %thread-fail
        =/  err  !<  (pair term tang)  q.cage.sign
        %-  (slog leaf+"Thread failed: {(trip p.err)}" q.err)
        `this
          %thread-done
        =/  res  (trip !<(term q.cage.sign))
        %-  (slog leaf+"Result: {res}" ~)
        `this
      ==
    ==
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%timers ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
        [%behn %wake *]
      ?^  error.sign-arvo
        (on-arvo:def wire sign-arvo)
      ?~  next  ~&('%iana: unexpected timer' `this)
      =/  nxt=@da  (add now.bowl ~d1)
      :_  this(next (some nxt))
      :~  [%pass /timers %arvo %b %wait nxt]
          [%pass /thread %agent [our dap]:bowl %poke noun+!>(%start-thread)]
      ==
    ==
  ==
::
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
+*  core  .
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
::
++  import-blob
  |=  data=@t
  ^-  _core
  =/  =wall  (turn (to-wain:format data) trip)
  =/  =iana  (parse-timezones:iana-parser wall)
  =/  cap=@ud  1.000.000 :: limit timezones for each continent for faster testing
  =.  zones.iana
    %-  ~(gas by *zones:^iana)
    (scag cap ~(tap by zones.iana))
  =/  new-iana-data=^iana
    ?~  iana-data  *^iana
    u.iana-data
  =:  zones.new-iana-data  (~(uni by zones.new-iana-data) zones.iana)
      rules.new-iana-data  (~(uni by rules.new-iana-data) rules.iana)
      links.new-iana-data  (~(uni by links.new-iana-data) links.iana)
    ==
  =.  core  :: notify watchers
    ?:  =(iana-data `new-iana-data)  core
    (emit %give %fact ~[/change] noun+!>(0))
  core(iana-data `new-iana-data)
--
