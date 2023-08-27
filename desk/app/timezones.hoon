/-  *timezones
/+  timezones, cv=iana-converter,
    verb, dbug, default-agent
:: import to force compilation during development
::
/=  j-   /lib/timezones-json
/=  z-   /mar/zone/peek
/=  i-   /mar/iana-data
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 zones=(map zid zone)]
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
    tz    ~(. timezones [bowl zones])
    hc    ~(. +> [bowl ~])
    cc    |=(cards=(list card) ~(. +> [bowl cards]))
::
++  on-init  
  ^-  (quip card _this)
  :_(this [%pass /iana-change %agent [our.bowl %iana] %watch /change]~)
::
++  on-save  !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  :_  this(state old)
  [%pass /iana-change %agent [our.bowl %iana] %watch /change]~
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %timezone-action
    !!
    :: ?>  =(src our):bowl
    :: =/  axn  !<(action vase)
    :: ?-    -.axn
    ::     %add-zone
    ::   =/  =flag  [our.bowl flag-path.axn]
    ::   ?<  (~(has by zones) flag)
    ::   =/  cards=(list card)
    ::     =/  upd=update  [%flags ~[flag]]
    ::     [%give %fact ~[/all] timezone-update+!>(upd)]~
    ::   [cards this(zones (~(put by zones) flag [| zone.axn]))]
    ::   ::
    ::     %put-zone
    ::   =/  =flag  [our.bowl flag-path.axn]
    ::   =/  cards=(list card)
    ::     ?.  (~(has by zones) flag)
    ::       =/  upd=update  [%flags ~[flag]]
    ::       [%give %fact ~[/all] timezone-update+!>(upd)]~
    ::     =/  upd=update  [%zone [| zone.axn]]
    ::     [%give %fact ~[[%zone q.flag]] timezone-update+!>(upd)]~
    ::   [cards this(zones (~(put by zones) flag [| zone.axn]))]
    ::   ::
    ::     %del-zone
    ::   =/  cards=(list card)
    ::     [%give %kick ~[[%zone q.flag.axn]] ~]~
    ::   [cards this(zones (~(del by zones) flag.axn))]
    ::   ::
    ::     %get-zone
    ::   =^  cards  state
    ::     abet:(follow-flag flag.axn)
    ::   [cards this]
    ::   ::
    ::     %watch
    ::   :_  this
    ::   [%pass /ship/(scot %p ship.axn) %agent [ship.axn dap.bowl] %watch /all]~
    ::   ::
    ::     %leave
    ::   =/  cards=(list card)
    ::     [%pass /ship/(scot %p ship.axn) %agent [ship.axn dap.bowl] %leave ~]~
    ::   =.  zones
    ::     %-  ~(gas by *^zones)
    ::     %+  murn  ~(tap by zones)
    ::     |=  [=flag data=[_| zone]]
    ::     ?:  =(ship.axn p.flag)
    ::       ~
    ::     (some [flag data])
    ::   [cards this]
    ::   ::
    ::     %spawn-zone
    ::   `this
    ::   ::
    ::     %shift-zone
    ::   `this
    ::   ::
    ::   ::   %edit-ruleset
    ::   :: `this
    ::   ::
    ::     %freeze-zone
    ::   `this
    :: ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
    [%ui ~]  `this
    ::
    ::   [%all ~]
    :: :: all your timezones are publicly available
    :: ::
    :: =/  flags=(list flag)
    ::   %+  murn  ~(tap in ~(key by zones))
    ::   |=(=flag ?.(=(p.flag our.bowl) ~ (some flag)))
    :: :_(this [%give %fact ~ timezone-update+!>(flags+flags)]~)
    :: ::
    ::   [%zone ^]
    :: =/  =flag  [our.bowl t.path]
    :: =/  [live=_| =zone]  (~(got by zones) flag)
    :: =/  upd=update  [%zone live zone]
    :: :_(this [%give %fact ~ timezone-update+!>(upd)]~)
  ==
::
++  on-leave  on-leave:def
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %zones ~]  ``zone-peek+!>(zones+zones)
    [%x %flags ~]  ``zone-peek+!>(flags+~(tap in ~(key by zones)))
    ::
      [%x %zone p=@ta q=@ta ~]
    =/  =zid   [(slav %p p.pole) q.pole]
    ``zone-peek+!>(zone+(~(got by zones) zid))
    ::
      [%x %tz-to-utc-list p=@ta q=@ta ~]
    :-  ~  :-  ~  :-  %noun  !>  %-  mole
    =/  =zid   [(slav %p p.pole) q.pole]
    tz-to-utc-list:(abed:zn:tz zid)
    ::
      [%x %tz-to-utc p=@ta q=@ta ~]
    :-  ~  :-  ~  :-  %noun  !>  %-  mole
    =/  =zid   [(slav %p p.pole) q.pole]
    tz-to-utc:(abed:zn:tz zid)
    ::
      [%x %utc-to-tz p=@ta q=@ta ~]
    :-  ~  :-  ~  :-  %noun  !>  %-  mole
    =/  =zid   [(slav %p p.pole) q.pole]
    utc-to-tz:(abed:zn:tz zid)
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%iana-change ~]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        %.  `this
        %-  slog
        :_  ~  
        leaf+"%timezone: follow %iana /change succeeded!"
      %.  `this
      %-  slog
      :_  u.p.sign
      leaf+"%timezone: follow %iana /change failed!"
    ::
        %kick
      ~&  "{<dap.bowl>}: got kick on %iana /change, resubscribing..."
      :_(this [%pass wire %agent [src dap]:bowl %watch wire]~)
    ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %noun
        =/  iana-data=(unit iana)  .^((unit iana) %gx /(scot %p our.bowl)/iana/(scot %da now.bowl)/iana/iana-data)
        =.  zones  ~(convert-iana-zones-new cv [bowl (fall iana-data [~ ~ ~])])
        `this
      ==
    ==
      [%ship @ta ~]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        %.  `this
        %-  slog
        :_  ~  
        leaf+"%timezone: joining /{<i.wire>} succeeded!"
      %.  `this
      %-  slog
      :_  u.p.sign
      leaf+"%timezone: joining /{<i.wire>} failed!"
    ::
        %kick
      ~&  "{<dap.bowl>}: got kick, resubscribing..."
      :_(this [%pass wire %agent [src dap]:bowl %watch wire]~)
    ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %timezone-update
        !!
        :: =/  upd  !<(update q.cage.sign)
        :: ?+    -.upd  (on-agent:def wire sign)
        ::     %flags
        ::   =/  flags  (skim flags.upd |=(=flag =(p.flag (slav %p i.wire))))
        ::   =^  cards  state
        ::     abet:(follow-flags flags)
        ::   [cards this]
        :: == 
      ==
    ==
      [%flag @ta @ta ~]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        %.  `this
        %-  slog
        :_  ~  
        leaf+"%timezone: joining /{<i.wire>}/{<i.t.wire>} succeeded!"
      %.  `this
      %-  slog
      :_  u.p.sign
      leaf+"%timezone: joining /{<i.wire>}/{<i.t.wire>} failed!"
    ::
        %kick
      ~&  "{<dap.bowl>}: got kick, resubscribing..."
      :_(this [%pass wire %agent [src dap]:bowl %watch wire]~)
    ::
        %fact
      !!
      :: =/  =flag  (de-path t.wire)
      :: ?+    p.cage.sign  (on-agent:def wire sign)
      ::     %timezone-update
      ::   =/  upd  !<(update q.cage.sign)
      ::   ?+    -.upd  (on-agent:def wire sign)
      ::       %zone
      ::     `this(zones (~(put by zones) flag [live zone]:upd))
      ::   == 
      :: ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
+*  core  .
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
::
:: ++  en-path  |=(=flag `path`[(scot %p p.flag) q.flag])
:: ++  de-path
::   |=  path=[i=@ta t=path]
::   ^-  flag
::   [(slav %p i.path) t.path]
:: ::
:: ++  follow-ship
::   |=  =ship
::   ^-  _core
::   ?<  =(ship our.bowl)
::   =/  =wire  /(scot %p ship)
::   (emit %pass wire %agent [ship dap.bowl] %watch /all)
:: ::
:: ++  follow-flag
::   |=  =flag
::   ^-  _core
::   ?<  =(p.flag our.bowl)
::   =/  =wire  [(scot %p p.flag) q.flag]
::   (emit %pass wire %agent [p.flag dap.bowl] %watch `path`[%zone q.flag])
:: ::
:: ++  follow-flags
::   |=  flags=(list flag)
::   ^-  _core
::   ?~  flags  core
::   $(flags t.flags, core (follow-flag:core i.flags))
:: ::
:: ++  iana-flags
::   ^-  (list flag)
::   %+  murn  ~(tap in ~(key by zones))
::   |=  =flag
::   ?.  ?&  =(p.flag our.bowl)
::           ?>(?=(^ q.flag) ?=(%iana i.q.flag))
::       ==
::     ~
::   ~&  flag
::   (some flag)
:: ::
:: ++  purge-iana
::   ^-  ^zones
::   %-  ~(gas by *^zones)
::   %+  murn  ~(tap by zones)
::   |=  [=flag live=_| =zone]
::   ?:  ?&  =(p.flag our.bowl)
::           ?>(?=(^ q.flag) ?=(%iana i.q.flag))
::       ==
::     ~
::   (some [flag live zone])
--
