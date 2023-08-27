/-  *timezones
=>  |%
    +$  card  card:agent:gall
    +$  sign  sign:agent:gall
    --
=|  cards=(list card)
|_  [=bowl:gall zones=(map zid zone)]
+*  this   .
++  abet  [(flop cards) zones]
++  emit  |=(=card this(cards [card cards]))
++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
++  sour  (scot %p our.bowl)
++  snow  (scot %da now.bowl)
++  to-to-jumps  .^((map rid to-to-jump) %gx /[sour]/calendar/[snow]/to-to-jumps/noun)
++  emil-zon
  |=  [cards=(list card) =zid zon=zone]
  (emil(zones (~(put by zones) zid zon)) cards)
::
++  get-to-jump
  |=  [=rid =args]
  ^-  to-jump
  ?>  ?=(%jump q.rid)
  =/  =to-to-jump
    (~(got by to-to-jumps) rid)
  (to-to-jump args)
::
++  create-rule
  |=  [=zid =tid dom=[l=@ud r=@ud] name=@t offset=delta =rid =args]
  ^-  _this
  (emil-zon abot:(create-rule:(abed:zn zid) tid dom name offset rid args))
::
++  delete-rule
  |=  [=zid =tid]
  ^-  _this
  (emil-zon abot:(delete-rule:(abed:zn zid) tid))
::
++  zn
  =|  [upds=(list zone-update) old=zone]
  |_  [=zid zon=zone]
  +*  this  .
  ++  abed
    |=  =^zid
    ^-  _this
    =/  zon=zone
      (~(got by zones) zid)
    this(zid zid, zon zon, old zon)
  ++  abet
    ^-  [upds=(list zone-update) =^zid zon=zone]
    [upds zid zon]
  ++  card-abet
    ^-  [cadz=(list card) =^zid zon=zone]
    :_  [zid zon]
    %+  turn  (flop upds)
    |=  upd=zone-update
    `card`[%give %fact ~[/temp] zone-update+!>(upd)]
  ++  emit  |=(upd=zone-update this(upds [upd upds]))
  ++  emil  |=(upds=(list zone-update) this(upds (weld upds ^upds)))
  ++  abot
    =.  upds  (flop upds)
    =/  new=zone  zon:(do-updates:this(zon old) upds)
    :: ?:  =(zon new)
      card-abet
    :: ~|("non-equivalent-updates" !!)
  ::
  ++  init
    |=  name=@t
    ^-  _this
    =.  zon  *zone :: initialize with bunt
    this(name.zon name)
  ::
  ++  create-rule
    |=  [=tid dom=[l=@ud r=@ud] name=@t offset=delta =rid =args]
    ^-  _this
    =|  rul=tz-rule
    =.  this  (do-update %rule %c tid rul)
    (do-updates upds:abet:(init:(abed:rl tid) dom name offset rid args))
  ::
  ++  update-rule
    |=  [=tid fields=(list tz-rule-field)]
    ^-  _this
    (do-updates upds:abet:(do-updates:(abed:rl tid) fields))
  ::
  ++  update-rule-args
    |=  [=tid =rid =args]
    ^-  _this
    (do-updates upds:abet:(update-args:(abed:rl tid) rid args))
  ::
  ++  update-rule-domain
    |=  [=tid dom=[l=@ud r=@ud]]
    ^-  _this
    (do-updates upds:abet:(update-domain:(abed:rl tid) dom))
  ::
  ++  clip-rules
    |=  [l=(unit @da) r=(unit @da)]
    ^-  _this
    =/  =(map tid dom=[l=@ud r=@ud])  (~(clp or order.zon) l r)
    =/  tids  ~(tap in ~(key by rules.zon))
    |-  ?~  tids  this
    ?~  get=(~(get by map) i.tids)
      $(tids t.tids, this (delete-rule i.tids))
    $(tids t.tids, this (update-rule-domain i.tids u.get))
  ::
  ++  delete-rule  |=(=tid `_this`(do-update %rule %d tid))
  :: order core
  ::
  ++  or
    |_  ord=((mop @da iref) lth)
    ++  ron  ((on @da iref) lth)
    ++  get-time
      |=  =iref
      ^-  (unit time)
      =/  rul=tz-rule  (~(got by rules.zon) tid.iref)
      ?~  int=(~(get by instances.rul) i.iref)  ~
      ?-  -.u.int
        %|  ~
        %&  (some p.u.int)
      ==
    ::
    ++  del
      |=  =iref
      ^+  ord
      =/  time=(unit time)  (get-time iref)
      ?~  time  ord
      +:(del:ron ord u.time)
    ::
    ++  put
      |=  [=iref =jump]
      ^+  ord
      (put:ron ord jump iref)
    :: replace
    ::
    ++  rep
      |=  [=iref =jump]
      ^+  ord
      =.  ord  (del iref)
      (put iref jump)
    :: replace many
    ::
    ++  rap
      |=  =(list [iref jump])
      ^+  ord
      ?~  list  ord
      $(list t.list, ord (rep i.list))
    :: previous rule
    ::
    ++  pul
      |=  =time
      ^-  (unit [i=@ud rule=tz-rule])
      =/  t=(unit [@da =iref])  (ram:ron (lot:ron ord ~ `time))
      ?~(t ~ `[i.iref.u.t (~(got by rules.zon) tid.iref.u.t)])
    :: previous offset
    ::
    ++  pof  |=(=time `(unit delta)`?~(p=(pul time) ~ `offset:rule:u.p))
    ::
    ++  clp
      |=  [l=(unit @da) r=(unit @da)]
      ^-  (map tid dom=[l=@ud r=@ud])
      ?>  ?~(l & ?~(r & (lte u.l u.r)))
      =|  =(map tid dom=[l=@ud r=@ud])
      =/  clipped=(list [@da =iref])
        (tap:ron (lot:ron ord l r))
      |-  ?~  clipped  map
      =/  [=tid i=@ud]  iref.i.clipped
      ?~  get=(~(get by map) tid)
        $(clipped t.clipped, map (~(put by map) tid [i i]))
      =?  l.dom.u.get  (lth i l.dom.u.get)  i
      =?  r.dom.u.get  (gth i r.dom.u.get)  i
      $(clipped t.clipped, map (~(put by map) tid dom.u.get))
    --
  ::
  ++  tz-to-utc-list
    ^-  ^tz-to-utc-list
    |=  time=@da
    ^-  (list @da)
    :: time ordered list of valid candidates
    ::
    |^  (sort candidates lth)
    ++  candidates
      :: invert this time for all offsets of the timezone
      ::
      ^-  (list @da)
      %+  murn  ~(tap in ~(key by offsets.zon))
      |=  offset=delta
      ^-  (unit @da)
      ?.((validate-time (invert-delta time offset) offset) ~ `time)
    ::
    ++  validate-time
      :: check whether a candidate could have been validly
      :: generated by the given offset
      ::
      |=  [=utc=^time offset=delta]
      ^-  ?
      ?~  pof=(~(pof or order.zon) utc-time)  |
      =(offset u.pof)
    --
  ::
  ++  tz-to-utc
    ^-  ^tz-to-utc
    |=  =dext
    ^-  (unit @da)
    :: generate all possible times
    ::
    =/  times=(list @da)  (tz-to-utc-list d.dext)
    :: return the time at the requested index
    ::
    ?:((lte (lent times) i.dext) ~ (some (snag i.dext times)))
  ::
  ++  utc-to-tz
    ^-  ^utc-to-tz
    |=  time=@da
    ^-  (unit dext)
    ?~  pof=(~(pof or order.zon) time)  ~
    =/  tz-time           (apply-delta time u.pof)
    =/  times=(list @da)  (tz-to-utc-list tz-time)
    ?~  idx=(find [time]~ times)  ~
    (some [u.idx tz-time])
  ::
  ++  rl
    =|  upds=(list tz-rule-update)
    |_  [=tid rul=tz-rule]
    +*  this  .
    ++  abet
      :_  [tid rul]
      ^=  upds
      %+  turn  (flop upds)
      |=  upd=tz-rule-update
      [%rule %u tid upd]
    ++  abed
      |=  =^tid
      %=  this
        tid  tid
        rul  (~(got by rules.zon) tid)
      ==
    ++  emit  |=(upd=tz-rule-update this(upds [upd upds]))
    ++  init-base
      |=  [dom=[l=@ud r=@ud] name=@t offset=delta =rid =args]
      ^-  _this
      ?>  (lte dom)
      =.  this  (do-update %name name)
      =.  this  (do-update %dom dom)
      =.  this  (do-update %offset offset)
      (do-update %rule rid args)
    ::
    ++  init
      |=  [dom=[l=@ud r=@ud] name=@t offset=delta =rid =args]
      ^-  _this
      ?>  (lte dom)
      =.  this           (init-base dom name offset rid args)
      =.  instances.rul  (dummies dom)
      (instantiate (gulf dom))
    ::
    ++  dummies
      |=  dom=[l=@ud r=@ud]
      ^-  (map @ud jump-instance)
      %-  ~(gas by *(map @ud jump-instance))
      (turn (gulf dom) |=(idx=@ud [idx %| %skip ~]))
    ::
    ++  instantiate
      |=  idx=(list @ud)
      ^-  _this
      ?~  idx  this
      :: IMPORTANT: cached computation
      ::
      =/  new=jump-instance  (~+((get-to-jump rule.rul)) i.idx)
      =.  this  (do-update %instance %& i.idx new)
      $(idx t.idx)
    ::
    ++  update-args
      |=  [=rid =args]
      ^-  _this
      =.  this  (do-update %rule rid args)
      (instantiate (gulf dom.rul))
    ::
    ++  update-domain
      |=  dom=[l=@ud r=@ud]
      ^-  _this
      ?>  (lte dom)
      =.  this  (do-update %dom dom)
      =.  instances.rul  (dummies dom)
      (instantiate (gulf dom))
    ::
    ++  do-update
      |=  upd=tz-rule-update
      ^-  _this
      :: when doing updates, re-accumulates the updates in upds
      ::
      =-  (emit(rul -) upd)
      ?-    -.upd
        :: direct replace
        ::
        %name    rul(name name.upd)
        %dom     rul(dom dom.upd)
        %offset  rul(offset offset.upd)
        %rule    rul(rule [rid args]:upd)
        :: put / del
        ::
          %instance
        ?-  -.p.upd
          %&  rul(instances (~(put by instances.rul) p.p.upd))
          %|  rul(instances (~(del by instances.rul) p.p.upd))
        ==
      ==
    ::
    ++  do-updates
      |=  upds=(list tz-rule-update)
      ^-  _this
      |-  ?~  upds  this
      $(upds t.upds, this (do-update i.upds))
    --
  ::
  ++  reorder
    |=  [=tid upd=tz-rule-update]
    ^-  zone
    ?.  ?=(%instance -.upd)  zon :: ignore non-instance updates
    ?-    -.p.upd
        %|
      :: delete an instance
      ::
      zon(order (~(del or order.zon) [tid p.p.upd]))
      ::
        %&
      ?.  ?=(%& -.int.p.p.upd)  zon :: ignore exceptions
      :: replace this instance in order
      ::
      %=    zon
          order
        %-  ~(rep or order.zon)
        :-  [tid idx.p.p.upd]
        p.int.p.p.upd
      ==
    ==
  ::
  ++  add-offsets
    |=  [=tid upd=tz-rule-update]
    ^-  zone
    ?.  ?=(%offset -.upd)  zon :: ignore non-offset updates
    =/  old=delta  offset:(~(got by rules.zon) tid)
    =.  offsets.zon  (~(del ju offsets.zon) old tid)
    zon(offsets (~(put ju offsets.zon) offset.upd tid))
  ::
  ++  do-update
    |=  *
    =/  upd  ;;(zone-update +<) :: problems with +crud
    ^-  _this
    :: re-emit the update and modify the calendar
    :: when doing updates, re-accumulates the updates in upds
    ::
    =-  (emit(zon -) upd)
    ?-    -.upd
      %zone  zon.upd
      :: direct replace
      ::
      %name  zon(name name.upd)
      :: updates
      ::
        %rule
      ?-    -.p.upd
        %c  zon(rules (~(put by rules.zon) p.p.upd))
        %d  zon(rules (~(del by rules.zon) p.p.upd))
        ::
          %u
        =/  [=tid upd=tz-rule-update]  p.p.upd
        =.  zon  (reorder tid upd) :: do first; relies on old zon state
        =.  zon  (add-offsets tid upd) :: do first; relies on old zon state
        zon(rules (~(put by rules.zon) tid rul:(do-update:(abed:rl tid) upd)))
      ==
    ==
  ++  do-updates
    |=  upds=(list zone-update)
    ^-  _this
    |-  ?~  upds  this
    $(upds t.upds, this (do-update i.upds))
  --
--
