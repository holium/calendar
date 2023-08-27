/-  *calendar, p=pools
/+  c=calendar, b=boxes, r=rules,
    server, dbug, verb, default-agent
:: Import to force compilation during development.
:: 
/=  a-  /mar/calendar/action
/=  a-  /mar/calendar/update
/=  a-  /mar/calendar/updates
/=  a-  /mar/calendar/ui-update
/=  a-  /mar/event/action
/=  a-  /mar/rule/action
/=  g-  /mar/goof
/=  p-  /mar/calendar/peek
/=  p-  /mar/calendar/vent
/=  ac  /mar/calendar/async-create
/=  as  /mar/vent-package
/=  c-  /ted/vines/calendar
::
|%
+$  state-0
  $:  %0
      rules=(map rid rule)
      calendars=(map cid calendar)
      =boxes:b
  ==
+$  cache
  $:  to-to-boths=(map rid to-to-both)
      to-to-lefts=(map rid to-to-left)
      to-to-fulldays=(map rid to-to-fullday)
      to-to-jumps=(map rid to-to-jump)
  ==
+$  inflated-state  [state-0 =cache]
+$  card     card:agent:gall
--
=|  inflated-state
=*  state  -<
=<
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    box   ~(. b [bowl state cache])
    cal   ~(. c [bowl state cache])
    rul   ~(. r [bowl rules cache])
    hc    ~(. +> [bowl ~])
::
++  on-init
  ^-  (quip card _this)
  =.  rules.state  hardcode:rul
  =.  cache        cache-rules:rul
  :_  this
  :~  [%pass /pools/home %agent [our.bowl %pools] %watch /home]
      [%pass /eyre/connect %arvo %e %connect `/apps/calendar dap.bowl]
  ==
::
++  on-save   !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  =.  state  old
  =.  rules.state  hardcode:rul
  =.  cache        cache-rules:rul
  `this
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ~&  %hitting-on-poke
  :: forward vent requests directly to the vine
  ::
  ?:  ?=(%vent-request mark)  :_(this ~[(to-vine:vio vase bowl)])
  ::
  ?+    mark  (on-poke:def mark vase)
      %noun
    ?^  q.vase  `this
    =/  idx=@  q.vase
    ?:  =(0 idx)  `this
    =.  idx  (dec idx)
    =/  =kind  [%left ~ ~h1]
    =/  =args  (my ~[['Start' %da ~2000.1.1] ['Period' %dr ~d1]])
    ~&  ((get-to-span:ca:cal [~ %left %periodic-0] kind args) idx)
    =.  args   (my ~[['Start' %dx [0 ~2000.1.1]] ['End' %dx [0 ~2000.1.2]]])
    ~&  ((get-to-span:ca:cal [~ %both %single-0] both+[~ ~] args) idx)
    =.  args   (my ['Start' %dx [0 ~2010.1.5]]~)
    ~&  ((get-to-span:ca:cal [~ %left %single-0] left+[~ ~h1] args) idx)
    =.  args   (my ['Date' %da ~2054.3.23]~)
    ~&  ((get-to-fullday:ca:cal [~ %fuld %single-0] fuld+~ args) idx)
    `this
    ::
      %handle-http-request
    :: re-interpret as vent-request
    ::
    =^  cards  this
      (on-poke vent-request+!>([[our now]:bowl mark q.vase]))
    [cards this]
    ::
      %handle-http-response
    =+  !<([eyre-id=@ta pay=simple-payload:http] vase)
    :_(this (give-simple-payload:app:server eyre-id pay))
    ::
      %calendar-async-create
    :: re-interpret as vent-request
    ::
    =^  cards  this
      (on-poke vent-request+!>([[our now]:bowl mark q.vase]))
    [cards this]
    ::
      %boxes-invite-gesture
    =^  cards  state
      abet:(handle-invite-gesture:box !<(invite-gesture:b vase))
    [cards this]
    ::
      %boxes-invite-action
    :: re-interpret as vent-request
    ::
    =^  cards  this
      (on-poke vent-request+!>([[our now]:bowl mark q.vase]))
    [cards this]
    ::
      %boxes-process
    ?>  =(src our):bowl
    =^  cards  state
      abet:(handle-process:box !<(process:b vase))
    [cards this]
    ::
      %boxes-join-action
    :: re-interpret as vent-request
    ::
    =^  cards  this
      (on-poke vent-request+!>([[our now]:bowl mark q.vase]))
    [cards this]
    ::
      %rule-action
    =^  cards  rules :: rules! not state
      abet:(handle-rule-action:rul !<(rule-action vase))
    [cards this]
    ::
      %calendar-action
    =/  axn=calendar-action  !<(calendar-action vase)
    ?>  =(host.p.axn our.bowl)
    ?-    +<.axn
        %create
      =^  cards  state
        abet:(create-calendar:cal [p +.q]:axn)
      [cards this]
      ::
        %update
      =^  cards  state
        abet:(update-calendar:cal [p fields.q]:axn)
      [cards this]
      ::
        %update-graylist
      =^  cards  state
        abet:(update-graylist:cal [p fields.q]:axn)
      [cards this]
      ::
        %delete
      =^  cards  state
         abet:(delete-calendar:cal p.axn)
      [cards this]
    ==
    ::
      %event-action
    =+  !<(axn=event-action vase)
    ?.  =(host.cid.p.axn our.bowl)
      ?>  =(src our):bowl
      :_(this [%pass / %agent [host.cid.p.axn dap.bowl] %poke mark vase]~)
    ?-    +<.axn
        %create
      ~&  %creating-event-0
      =^  cards  state
         abet:(create-event:cal [cid.p eid.p +.q]:axn)
      ~&  cal-updated+(~(got by calendars) cid.p.axn)
      [cards this]
      ::
        %create-until
      ~&  %creating-event-until-0
      =^  cards  state
         abet:(create-event-until:cal [cid.p eid.p +.q]:axn)
      ~&  cal-updated+(~(got by calendars) cid.p.axn)
      [cards this]
      ::
        %update
      =^  cards  state
         abet:(update-event:cal [cid.p eid.p +.q]:axn)
      [cards this]
      ::
        %delete
      =^  cards  state
         abet:(delete-event:cal p.axn)
      [cards this]
      ::
        %create-rule
      =^  cards  state
         abet:(create-event-rule:cal [cid.p eid.p +.q]:axn)
      [cards this]
      ::
        %update-rule
      =^  cards  state
         abet:(update-event-rule:cal [cid.p eid.p +.q]:axn)
      [cards this]
      ::
        %delete-rule
      =^  cards  state
         abet:(delete-event-rule:cal [cid.p eid.p +.q]:axn)
      [cards this]
      ::
        %create-metadata
      =^  cards  state
         abet:(create-event-metadata:cal [cid.p eid.p +.q]:axn)
      [cards this]
      ::
        %update-metadata
      =^  cards  state
         abet:(update-event-metadata:cal [cid.p eid.p +.q]:axn)
      [cards this]
      ::
        %delete-metadata
      =^  cards  state
         abet:(delete-event-metadata:cal [cid.p eid.p +.q]:axn)
      [cards this]
      ::
        %update-instances
      =^  cards  state
         abet:(update-event-instances:cal [cid.p eid.p +.q]:axn)
      [cards this]
      ::
        %update-domain
      =^  cards  state
         abet:(update-event-domain:cal [cid.p eid.p +.q]:axn)
      [cards this]
    ==
    ::
      %rdate-action
    =/  axn=rdate-action  !<(rdate-action vase)
    ?>  =(host.p.axn our.bowl)
    ?+    +<.axn  !!
        %create
      =^  cards  state
         abet:(create-date:cal [p +.q]:axn)
      [cards this]
      ::
        %delete
      =^  cards  state
         abet:(delete-date:cal [p eid.q]:axn)
      [cards this]
    ==
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ~&  %hitting-on-watch
  ?+    pole  (on-watch:def pole)
    [%vent @ @ ~]       `this
    [%http-response *]  `this
    ::
      [%ui %calendar host=@ name=@ ~]
    ?>  =(src our):bowl
    =/  =cid  [(slav %p host.pole) name.pole]
    =/  =calendar  (~(got by calendars) cid)
    :_(this [%give %fact ~[pole] calendar-update+!>([%calendar calendar])]~)
    ::
    [%home ~]      `this
      [%calendar host=@ name=@ ~]
    =/  =cid  [(slav %p host.pole) name.pole]
    :: assert we are the host
    ::
    ?>  =(host.cid our.bowl)
    =/  =calendar  (~(got by calendars) cid)
    :: assert pool membership
    ::
    ?>  (has-in-pool-members:cal cid src.bowl)
    :: give initial update
    ::
    :_(this [%give %fact ~[pole] calendar-updates+!>([%calendar calendar]~)]~)
    ::
      [%rule host=@ type=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    =/  =rid  [(some host) ;;(rule-type type.pole) name.pole]
    :: assert we are the host
    ::
    ?>  =(host our.bowl)
    =/  =rule  (~(got by rules) rid)
    :: give initial update
    ::
    :_(this [%give %fact ~[pole] rule-update+!>([%rule rule])]~)
  ==
::
++  on-leave  on-leave:def
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
      [%x %url-prefix ~]
    :-  ~  :-  ~  :-  %tape  !>
    %-  head:en-purl:html
    .^(hart:eyre %e /(scot %p our.bowl)/host/(scot %da now.bowl))
    ::
    [%x %rules ~]        ``calendar-peek+!>([%rules rules])
    [%x %calendars ~]    ``calendar-peek+!>([%calendars calendars])
    [%x %boxes ~]        ``boxes-peek+!>([%boxes boxes])
    [%x %to-to-jumps ~]  ``noun+!>(to-to-jumps.cache)
    ::
      [%x %rule p=@ q=rule-type r=@ ~]
    =/  src=(unit ship)  ?~(p.pole ~ (some (slav %p p.pole)))
    =/  =rid  [src [q r]:pole]
    ``calendar-peek+!>([%rule (~(got by rules) rid)])
    ::
      [%x %calendar host=@ name=@ ~]
    =/  =cid  [(slav %p host.pole) name.pole]
    ``calendar-peek+!>([%calendar (~(got by calendars) cid)])
    ::
      [%x %range host=@ name=@ l=@ r=@ ~]
    =/  =cid  [(slav %p host.pole) name.pole]
    =/  l=@da  (from-unix-ms:chrono:userlib (rash l.pole dem))
    =/  r=@da  (from-unix-ms:chrono:userlib (rash r.pole dem))
    =/  =calendar  (~(got by calendars) cid)
    ``calendar-peek+!>([%range (~(get-range ca:cal cid calendar) l r)])
    ::
      [%x %default-role host=@ name=@ ~]
    =/  =cid  [(slav %p host.pole) name.pole]
    =/  =role  default-role:(~(got by calendars) cid)
    ``calendar-peek+!>([%role (some role)])
    ::
      [%x %role host=@ name=@ ship=@ ~]
    =/  =cid   [(slav %p host.pole) name.pole]
    =/  =ship  (slav %p ship.pole)
    =/  role=(unit role)  (get-role:cal cid ship)
    ``calendar-peek+!>([%role role])
    ::
      [%x %roles-gate ~]
    :-  ~  :-  ~  :-  %noun  !>
    |=  [=cid =ship]
    ^-  (unit role)
    =/  =pool:p  (get-pool:cal cid)
    ?.  (~(has in members.pool) ship)  ~
    =/  =calendar  (~(got by calendars) cid)
    %-  some
    %+  ~(gut by roles.calendar)
      ship
    default-role.calendar
    ::
      [%x %all-bindings ~]
    =;  the-thing  ``json+!>(the-thing)
    %-  pairs:enjs:format
    %+  turn
      .^  (list [binding:eyre * action:eyre])  %e
          /(scot %p our.bowl)/bindings/(scot %da now.bowl)
      ==
    |=  [=binding:eyre * =action:eyre]
    ^-  [@t json]
    :-  (spat path.binding)
    ?-  -.action
      %gen             [%s (crip "desk: {<desk.generator.action>}")]
      %app             [%s (crip "app: {<app.action>}")]
      %authentication  [%s '%authentication']
      %logout          [%s '%logout']
      %channel         [%s '%channel']
      %scry            [%s '%scry']
      %name            [%s '%name']
      %four-oh-four    [%s '%four-oh-four']
    ==
  == 
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ~&  %hitting-on-agent
  ?+    pole  (on-agent:def pole sign)
      [%docket %http-response eyre-id=@ta ~]
    ~&  %docket-http-response
    ?+    -.sign  (on-agent:def pole sign)
        %watch-ack
      ?~  p.sign  `this
      :_(this [%give %kick ~[/http-response/[eyre-id.pole]] ~]~)
      ::
      %kick  :_(this [%give %kick ~[/http-response/[eyre-id.pole]] ~]~)
      ::
        %fact
      ?+    p.cage.sign  (on-agent:def pole sign)
          %http-response-header
        :_(this [%give %fact ~[/http-response/[eyre-id.pole]] cage.sign]~)
          %http-response-data
        :_(this [%give %fact ~[/http-response/[eyre-id.pole]] cage.sign]~)
      ==
    ==
      [%calendar host=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    =/  =cid       [host name.pole]
    ~&  %calendar
    ~&  cid+cid
    ?+    -.sign  (on-agent:def pole sign)
        %watch-ack
      ?~  p.sign
        ~&  %watch-ack
        ?:  =(host our.bowl)
          ~&  "STOP! Don't watch your own calendar!"
          :_(this [%pass pole %agent [our dap]:bowl %leave ~]~)
        :_(this [%give %fact ~[/home] calendar-home-update+!>([%calendar %& cid])]~)
      :: Delete calendar on watch-nack
      ::
      ~&  %watch-nack
      :_  this(calendars (~(del by calendars) cid))
      [%give %fact ~[/home] calendar-home-update+!>([%calendar %| cid])]~
      ::
        %kick
      ~&  %kick
      :: resubscribe on kick
      ::
      %-  (slog '%calendar: Got kick, resubscribing...' ~)
      :_(this [%pass pole %agent [host.cid dap.bowl] %watch pole]~)
      ::
        %fact
      ~&  %fact
      ~&  p.cage.sign
      ?.  =(p.cage.sign %calendar-updates)  (on-agent:def pole sign)
      =+  !<(upds=(list calendar-update) q.cage.sign)
      ~&  upds
      =^  cards  state
        abet:(handle-calendar-updates:cal cid upds)
      [cards this]
    ==
    ::
      [%rule host=@ type=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    =/  =rid  [(some host) ;;(rule-type type.pole) name.pole]
    ?+    -.sign  (on-agent:def pole sign)
        %watch-ack
      ?~  p.sign  `this
      :: Delete rule on watch-nack
      ::
      `this(rules (~(del by rules) rid))
      ::
        %kick
      :: resubscribe on kick
      ::
      %-  (slog '%calendar: Got kick, resubscribing...' ~)
      :_(this [%pass pole %agent [our dap]:bowl %watch pole]~)
      ::
        %fact
      ?.  =(p.cage.sign %rule-update)  (on-agent:def pole sign)
      =+  !<(upd=rule-update q.cage.sign)
      =^  cards  rules :: rules! not state
        abet:(handle-rule-update:rul rid upd)
      [cards this]
    ==
    ::
      [%pools %home ~]
    :: react to member and receipt updates
    ::
    ?+    -.sign  (on-agent:def pole sign)
        %kick
      :: resubscribe on kick
      ::
      %-  (slog '%calendar: Got kick, resubscribing...' ~)
      :_(this [%pass pole %agent [our.bowl %pools] %watch pole]~)
      ::
        %fact
      ?.  =(p.cage.sign %pools-home-update)  (on-agent:def pole sign)
      =/  upd=home-update:p  !<(home-update:p q.cage.sign)
      =^  cards  state
        abet:(handle-home-updates:box upd)
      [cards this]
    ==
    ::
      [%pool host=@ name=@ ~]
    :: react to member and receipt updates
    ::
    =/  host=ship  (slav %p host.pole)
    =/  =cid       [host name.pole]
    ?+    -.sign  (on-agent:def pole sign)
        %kick
      :: resubscribe on kick
      ::
      %-  (slog '%calendar: Got kick, resubscribing...' ~)
      :_(this [%pass pole %agent [our.bowl %pools] %watch pole]~)
      ::
        %fact
      ?.  =(p.cage.sign %pools-pool-update)  (on-agent:def pole sign)
      =/  upd=pool-update:p  !<(pool-update:p q.cage.sign)
      =^  cards  state
        abet:(handle-pool-updates:box cid upd)
      [cards this]
    ==
  ==
::
++  on-arvo
  |=  [=(pole knot) sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?+    pole  (on-arvo:def pole sign)
      [%vent p=@ta q=@ta ~]
    ?.  ?=([%khan %arow *] sign)  (on-arvo:def pole sign)
    %-  (slog ?:(?=(%.y -.p.sign) ~ p.p.sign))
    :_(this (vent-arow:vio pole p.sign))
    ::
      [%eyre %connect ~]
    ?>  ?=([%eyre %bound *] sign)
    ?:  accepted.sign
      ((slog leaf+"/calendar/public bound successfully!" ~) `this)
    ((slog leaf+"Binding /calendar/public failed!" ~) `this)
  ==
::
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
+*  core  .
    cc    ~(. cal [bowl cache])
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
--
