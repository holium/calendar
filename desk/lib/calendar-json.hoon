/-  *calendar, b=boxes
|%
++  dr-to-unix-ms  |=(d=@dr `@ud`(div d (div ~s1 1.000)))
++  to-unix-ms     |=(d=@da `@ud`(dr-to-unix-ms (sub d ~1970.1.1)))
++  dedot  |=(=@t (crip (murn (trip t) |=(=@t ?:(=('.' t) ~ (some t))))))
++  nimb
  |=  [s=? a=@u]
  ^-  json
  :-  %n
  ?:  =(0 a)  '0'
  =-  ?:(s - (cat 3 '-' -))
  %-  crip
  %-  flop
  |-  ^-  ^tape
  ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))]) 
::
++  enjs
  =,  enjs:format
  |%
  ++  rule-flag  |=(rid (rap 3 ?~(p '~' (scot %p u.p)) '/' q '/' r ~))
  ++  zone-flag  |=(z=(unit ^zone-flag) ?~(z '~' (rap 3 (scot %p p.u.z) q.u.z ~)))
  ++  pool-id    |=(=id:p (rap 3 (scot %p host.id) '/' name.id ~))
  ++  iref       |=(^iref (rap 3 eid '/' (scot %ud i) ~))
  ::
  ++  dext
    |=  =^dext
    ^-  json
    %-  pairs
    :~  [%i (numb i.dext)]
        [%d (numb (to-unix-ms d.dext))]
    ==
  ::
  ++  delta  |=(=^delta `json`(nimb sign.delta (dr-to-unix-ms d.delta)))
  ::
  ++  localtime
    |=  loc=^localtime
    ^-  json
    %-  pairs
    :~  [%tz s+(zone-flag tz.loc)]
        [%i (numb i.loc)]
        [%d (numb (to-unix-ms d.loc))]
    ==
  ::
  ++  arg
    |=  =^arg
    ^-  json
    ?-  -.arg
      %ud  (frond %ud (numb p.arg))
      %da  (frond %da (numb (to-unix-ms p.arg)))
      %od  (frond %od s+p.arg)
      %dr  (frond %dr (numb (dr-to-unix-ms p.arg)))
      %dl  (frond %dl (delta p.arg))
      %dx  (frond %dx (dext p.arg))
      %wl  (frond %wl a+(turn p.arg numb))
    ==
  ::
  ++  args
    |=  =^args
    ^-  json
    %-  pairs
    %+  turn  ~(tap by args)
    |=  [=@t a=^arg]
    ^-  [@t json]
    [t (arg a)]
  ::
  ++  dom  |=([l=@ud r=@ud] `json`(pairs ~[l+(numb l) r+(numb r)]))
  ++  meta
    |=  =^meta
    ^-  json
    %-  pairs
    :~  [%name s+name.meta]
        [%description s+description.meta]
        [%color s+color.meta]
    ==
  ::
  ++  metamap
    |=  mep=(map mid ^meta)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by mep)
    |=  [=mid met=^meta]
    ^-  [@t json]
    [mid (meta met)]
  ::
  ++  fuld-args
    |=  ful=(map aid [rid ^args])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by ful)
    |=  [=aid =rid ags=^args]
    ^-  [@t json]
    :-  aid
    %-  pairs
    :~  [%rid s+(rule-flag rid)]
        [%args (args ags)]
    ==
  ::
  ++  fullday  |=(ful=^fullday `json`(numb (to-unix-ms ful)))
  ::
  ++  rule-exception
    |=  rex=^rule-exception
    ^-  json
    ?-  -.rex
      %skip  s+%skip
      %rule-error  (frond %rule-error s+msg.rex)
    ==
  ::
  ++  kind
    |=  =^kind
    ^-  json
    %+  frond  -.kind
    ?-  -.kind
      %both  (pairs ~[lz+s+(zone-flag lz.kind) rz+s+(zone-flag rz.kind)])
      %left  (pairs ~[tz+s+(zone-flag tz.kind) d+(numb (dr-to-unix-ms d.kind))])
      %fuld  ~
      %skip  ~
    ==
  ::
  ++  span-args
    |=  spa=(map aid [rid ^kind ^args])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by spa)
    |=  [=aid =rid kid=^kind ags=^args]
    ^-  [@t json]
    :-  aid
    %-  pairs
    :~  [%rid s+(rule-flag rid)]
        [%kind (kind kid)]
        [%args (args ags)]
    ==
  ::
  ++  span
    |=  =^span
    ^-  json
    %-  pairs
    :~  [%start (numb (to-unix-ms l.span))]
        [%end (numb (to-unix-ms r.span))]
    ==
  ::
  ++  span-exception
    |=  pex=^span-exception
    ^-  json
    ?:  ?=(?(%skip %rule-error) -.pex)  (rule-exception pex)
    %+  frond  -.pex
    ?-  -.pex
      :: TODO: convert actual error information
      %bad-index                      ~
      %out-of-bounds                  ~
      %out-of-order                   ~
      %failed-to-retrieve-tz-to-utc   ~ 
      %failed-to-retrieve-utc-to-tz   ~
    ==
  ::
  ++  span-instance
    |=  ins=^span-instance
    ^-  json
    ?-  -.ins
      %&  (frond %instance (span +.ins))
      %|  (frond %exception (span-exception +.ins))
    ==
  ::
  ++  fullday-instance
    |=  ins=^fullday-instance
    ^-  json
    ?-  -.ins
      %&  (frond %instance (fullday +.ins))
      %|  (frond %exception (rule-exception +.ins))
    ==
  ::
  ++  instance
    |=  ins=^instance
    ^-  json
    %+  frond  -.ins
    ?-  -.ins
      %skip  ~
      %span  (span-instance p.ins)
      %fuld  (fullday-instance p.ins)
    ==
  ::
  ++  instances
    |=  ins=(map @ud instance-row)
    ^-  json
    :-  %a
    %+  turn
      (sort ~(tap by ins) |=([[a=@ud *] [b=@ud *]] `?`(lth a b)))
    |=  [idx=@ud =aid =mid =rsvps i=^instance]
    ^-  json
    %-  pairs
    :~  idx+s+(dedot (scot %ud idx))
        aid+s+aid  mid+s+mid
        instance+(instance i)
    ==
  ::
  ++  event
    |=  ven=^event
    ^-  json
    %-  pairs
    :~  [%dom (dom dom.ven)]
        [%def-rule s+def-rule.ven]
        [%def-data s+def-data.ven]
        [%rules (span-args rules.ven)]
        [%metadata (metamap metadata.ven)]
        [%instances (instances instances.ven)]
    ==
  ::
  ++  events
    |=  events=(map eid ^event)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by events)
    |=  [=eid ven=^event]
    ^-  [@t json]
    [eid (event ven)]
  ::
  ++  rdate
    |=  ven=^rdate
    ^-  json
    %-  pairs
    :~  [%date (pairs ~[m+(numb m) d+(numb d)]:[date.ven .])]
        [%metadata (meta metadata.ven)]
    ==
  ::
  ++  rdates
    |=  rdates=(map eid ^rdate)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by rdates)
    |=  [=eid ven=^rdate]
    ^-  [@t json]
    [eid (rdate ven)]
  ::
  ++  roles
    |=  roles=(map @p role)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by roles)
    |=  [ship=@p =role]
    ^-  [@t json]
    [(scot %p ship) s+role]
  ::
  ++  scry
    |=  scry=roles-scry
    ^-  json
    %-  pairs
    :~  [%dude s+dude.scry]
        [%path (path path.scry)]
    ==
  ::
  ++  calendar
    |=  cal=^calendar
    ^-  json
    %-  pairs
    :~  [%title s+title.cal]
        [%description s+description.cal]
        [%events (events events.cal)]
        [%rdates (rdates rdates.cal)]
        [%default-role s+default-role.cal]
        [%roles (roles roles.cal)]
        [%scry (scry scry.cal)]
        [%publish b+publish.cal]
    ==
  ::
  ++  calendars
    |=  calendars=(map cid ^calendar)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by calendars)
    |=  [=cid cal=^calendar]
    ^-  [@t json]
    [(pool-id cid) (calendar cal)]
  ::
  ++  event-field
    |=  fel=^event-field
    ^-  json
    %+  frond  -.fel
    ?-  -.fel
      %def-rule  s+aid.fel
      %def-data  s+mid.fel
    ==
  ::
  ++  instance-field
    |=  fel=^instance-field
    ^-  json
    %+  frond  -.fel
    ?-  -.fel
      %aid  s+aid.fel
      %mid  s+mid.fel
    ==
  ::
  ++  meta-field
    |=  fel=^meta-field
    ^-  json
    %+  frond  -.fel
    ?-  -.fel
      %name         s+name.fel
      %description  s+description.fel
      %color        s+color.fel
    ==
  ::
  ++  vupd-rule
    |=  p=(each [=aid =rid =^kind =^args] aid)
    ^-  json
    ?-    -.p
        %&
      %+  frond  %add
      %-  pairs
      :~  [%aid s+aid.p.p]
          [%rid s+(rule-flag rid.p.p)]
          [%kind (kind kind.p.p)]
          [%args (args args.p.p)]
      ==
      ::
        %|
      %+  frond  %del
      %-  pairs
      :~  [%aid s+p.p]
      ==
    ==
  ::
  ++  vupd-metadata
    |=  p=(crud [=mid =^meta] [=mid fel=^meta-field] mid)
    ^-  json
    ?-    -.p
        %c
      %+  frond  %create
      %-  pairs
      :~  [%mid s+mid.p.p]
          [%meta (meta meta.p.p)]
      ==
      ::
        %u
      %+  frond  %update
      %-  pairs
      :~  [%mid s+mid.p.p]
          [%meta (meta-field fel.p.p)]
      ==
      ::
        %d
      %+  frond  %delete
      %-  pairs
      :~  [%mid s+p.p]
      ==
    ==
  ::
  ++  vupd-instance
    |=  p=(each [idx=@ud instance-row] @ud)
    ^-  json
    ?-    -.p
        %&
      %+  frond  %add
      %-  pairs
      :~  [%idx s+(dedot (scot %ud idx.p.p))]
          [%aid s+aid.p.p]
          [%mid s+mid.p.p]
          [%instance (instance i.p.p)]
      ==
      ::
        %|
      %+  frond  %del
      %-  pairs
      :~  [%idx s+(dedot (scot %ud p.p))]
      ==
    ==
  ::
  ++  event-update
    |=  upd=^event-update
    ^-  json
    ?:  ?=(?(%def-rule %def-data) -.upd)
      (event-field upd)
    %+  frond  -.upd
    ?-    -.upd
        %dom       (dom dom.upd)
        %rule      (vupd-rule p.upd)
        %metadata  (vupd-metadata p.upd)
        %instance  (vupd-instance p.upd)
    ==
  ::
  ++  rdate-update
    |=  upd=^rdate-update
    ^-  json
    %+  frond  -.upd
    ?-    -.upd
        %date   (pairs ~[m+(numb m) d+(numb d)]:[date.upd .])
        %meta   (meta-field +.upd)
    ==
  ::
  ++  calendar-field
    |=  fel=^calendar-field
    ^-  json
    %+  frond  -.fel
    ?-  -.fel
      %title         s+title.fel
      %description   s+description.fel
      %default-role  s+role.fel
      %publish       b+b.fel
      %role          (cfel-role p.fel)
      %roles-scry    (scry scry.fel)
    ==
  ::
  ++  cfel-role
    |=  p=(each [ship=@p =role] @p)
    ^-  json
    ?-    -.p
        %&
      %+  frond  %add
      %-  pairs
      :~  [%ship s+(scot %p ship.p.p)]
          [%role s+role.p.p]
      ==
      ::
        %|
      %+  frond  %del
      %-  pairs
      :~  [%ship s+(scot %p p.p)]
      ==
    ==
  ::
  ++  cupd-event
    |=  p=(crud [=eid =^event] [=eid upd=^event-update] eid)
    ^-  json
    ?-    -.p
        %c
      %+  frond  %create
      %-  pairs
      :~  [%eid s+eid.p.p]
          [%event (event event.p.p)]
      ==
      ::
        %u
      %+  frond  %update
      %-  pairs
      :~  [%eid s+eid.p.p]
          [%event-update (event-update upd.p.p)]
      ==
      ::
        %d
      %+  frond  %delete
      %-  pairs
      :~  [%eid s+p.p]
      ==
    ==
  ::
  ++  cupd-rdate
    |=  p=(crud [=eid =^rdate] [=eid upd=^rdate-update] eid)
    ^-  json
    ?-    -.p
        %c
      %+  frond  %create
      %-  pairs
      :~  [%eid s+eid.p.p]
          [%rdate (rdate rdate.p.p)]
      ==
      ::
        %u
      %+  frond  %update
      %-  pairs
      :~  [%eid s+eid.p.p]
          [%rdate-update (rdate-update upd.p.p)]
      ==
      ::
        %d
      %+  frond  %delete
      %-  pairs
      :~  [%eid s+p.p]
      ==
    ==
  ::
  ++  calendar-update
    |=  upd=^calendar-update
    ^-  json
    ?:  ?=  $?  %title    %description  %default-role
                %publish  %role         %roles-scry
            ==
        -.upd
      (calendar-field upd)
    %+  frond  -.upd
    ?-  -.upd
      %calendar  (calendar cal.upd)
      %event     (cupd-event p.upd)
      %rdate     (cupd-rdate p.upd)
    ==
  ::
  ++  calendar-updates
    |=(upds=(list ^calendar-update) a+(turn upds calendar-update))
  ::
  ++  ui-calendar-update
    |=  upd=^ui-calendar-update
    ^-  json
    %+  frond  -.upd
    ?-    -.upd
        %event
      %+  frond  +<.upd
      ?-  +<.upd
        %del  (pairs [%eid s+eid.upd]~)
        %put  (pairs ~[[%eid s+eid.upd] [%event (event event.upd)]])
      ==
      ::
        %rdate
      %+  frond  +<.upd
      ?-  +<.upd
        %del  (pairs [%eid s+eid.upd]~)
        %put  (pairs ~[[%eid s+eid.upd] [%rdate (rdate rdate.upd)]])
      ==
    ==
  ::
  ++  parm
    |=  =^parm
    ^-  json
    %-  pairs
    %+  turn  parm
    |=  [=@t =term]
    ^-  [@t json]
    [t s+term]
  ::
  ++  rule
    |=  =^rule
    ^-  json
    %-  pairs
    :~  [%name s+name.rule]
        [%parm (parm parm.rule)]
        [%hoon s+hoon.rule]
    ==
  ::
  ++  rules
    |=  rules=(map rid ^rule)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by rules)
    |=  [=rid rul=^rule]
    ^-  [@t json]
    [(rule-flag rid) (rule rul)]
  ::
  ++  real-instance
    |=  =^real-instance
    ^-  json
    %-  pairs
    :~  [%rid s+(rule-flag rid.real-instance)]
        [%kind (kind kind.real-instance)]
        [%args (args args.real-instance)]
        [%meta (meta meta.real-instance)]
        :-  %i
        ?-  -.i.real-instance
          %span  (span p.i.real-instance)
          %fuld  (fullday p.i.real-instance)
        ==
    ==
  ++  range
    |=  =^range
    ^-  json
    %-  pairs
    %+  turn  ~(tap by range)
    |=  [i=^iref ins=^real-instance]
    ^-  [@t json]
    [(iref i) (real-instance ins)]
  ::
  ++  invite
    |=  =invite:b
    ^-  json
    %-  pairs
    :~  [%inviter s+(scot %p inviter.invite)]
        [%msg s+msg.invite]
    ==
  ++  incoming-invites
    |=  inv=(map cid invite:b)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by inv)
    |=  [=cid vit=invite:b]
    ^-  [@t json]
    [(pool-id cid) (invite vit)]
  ++  outgoing-invites
    |=  inv=(map [cid @p] invite:b)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by inv)
    |=  [[=cid =@p] vit=invite:b]
    ^-  [@t json]
    :_  (invite vit)
    (rap 3 (pool-id cid) '/' (scot %p p) ~)
  ++  boxes
    |=  =boxes:b
    ^-  json
    %-  pairs
    :~  [%incoming-invites (incoming-invites incoming-invites.boxes)]
        [%outgoing-invites (outgoing-invites outgoing-invites.boxes)]
    ==
  --
::
++  dejs
  =,  dejs:format
  |%
  :: json parsing for +each
  ::
  ++  ea
    |*  [a=mold b=mold]
    |=  [h=@ t=*]
    ?+  h  !!
      %y  ;;([%.y a] [0 t])
      %n  ;;([%.n b] [1 t])
    ==
  ::
  ++  role  (cook ^role ;~(pose (jest 'viewer') (jest 'guest') (jest 'member') (jest 'admin')))
  ++  calendar-field
    ^-  $-(json ^calendar-field)
    %-  of
    :~  [%title so]
        [%description so]
        [%default-role (su role)]
        [%publish bo]
        :-  %role
        %+  cu  (ea ,[@p ^role] @p)
        :~  y+(ot ~[ship+(su fed:ag) role+(su role)])
            n+(ot ~[ship+(su fed:ag)])
        ==
    ==
  ::
  ++  instance-field
    ^-  $-(json ^instance-field)
    %-  of
    :~  [%aid so]
        [%mid so]
    ==
  ::
  ++  async-create
    ^-  $-(json ^async-create)
    |=  jon=json
    %.  jon
    %-  of
    :~  [%calendar (cu |=([=@t d=@t] [t d ~ ~]) (ot ~[title+so description+so]))]
        [%event (ot ~[cid+(su pool-id) dom+dom rid+rid kind+kind args+args meta+meta])]
        [%event-until (ot ~[cid+(su pool-id) until+di rid+rid kind+kind args+args meta+meta])]
        [%event-rule (ot ~[cid+(su pool-id) eid+so rid+rid kind+kind args+args])]
        [%event-metadata (ot ~[cid+(su pool-id) eid+so meta+meta])]
    ==
  ::
  ++  calendar-action
    ^-  $-(json ^calendar-action)
    %-  ot
    :~
      [%p (su pool-id)]
      :-  %q
      %-  of
      :~  [%update (ar calendar-field)]
          [%delete ul]
      ==
    ==
  ::
  ++  event-action
    ^-  $-(json ^event-action)
    %-  ot
    :~
      [%p (ot ~[cid+(su pool-id) eid+so])]
      :-  %q
      %-  of
      :~  [%create (ot ~[dom+dom aid+so rid+rid kind+kind args+args mid+so meta+meta])]
          [%create-until (ot ~[start+ni until+di aid+so rid+rid kind+kind args+args mid+so meta+meta])]
          [%update-instances (ot ~[dom+dom fields+(ar instance-field)])]
          [%update-domain (ot ~[dom+dom])]
          [%delete ul]
      ==
    ==
  ::
  ++  rdate-action
    ^-  $-(json ^rdate-action)
    %-  ot
    :~
      [%p (su pool-id)]
      :-  %q
      %-  of
      :~  [%create (ot ~[date+md-date meta+meta])]
          [%delete (ot ~[eid+so])]
      ==
    ==
  ::
  ++  boxes-async-invite
    ^-  $-(json async-invite:b)
    %-  ot
    :~  [%cid (su pool-id)]
        [%ship (su fed:ag)]
        [%msg so]
    ==
  ::
  ++  boxes-invite-action
    ^-  $-(json invite-action:b)
    %-  ot
    :~
      [%p (su pool-id)]
      :-  %q
      %-  of
      :~  [%invite (ot ~[ship+(su fed:ag)])]
          [%cancel (ot ~[ship+(su fed:ag)])]
          [%kick (ot ~[ship+(su fed:ag)])]
          [%accept ul]
          [%reject ul]
      ==
    ==
  ::
  ++  boxes-join-action
    ^-  $-(json join-action:b)
    %-  ot
    :~
      [%p (su pool-id)]
      :-  %q
      %-  of
      :~  [%join ul]
          [%leave ul]
      ==
    ==
  ::
  ++  dom      `$-(json [@ud @ud])`(ot ~[l+ni r+ni])
  ++  meta     `$-(json ^^meta)`(ot ~[name+so description+so color+so])
  ++  md-date  `$-(json [@ud @ud])`(ot ~[m+ni d+ni])
  ++  kind
    %-  of
    :~  [%both (ot ~[lz+zone-flag rz+zone-flag])]
        [%left (ot ~[tz+zone-flag d+dr])]
        [%fuld ul]
    ==
  ++  dr  (cu |=(t=@ud `@dr`(div (mul ~s1 t) 1.000)) ni)
  ++  dx  (ot ~[[%i ni] [%d di]])
  ++  delta-sign  (su (cook |=(=@t =('+' t)) ;~(pose (just '+') (just '-'))))
  ++  dl
    %-  ot
    :~  [%sign delta-sign]
        [%d dr]
    ==
  ++  od
    %-  su
    %+  cook  ord
    ;~  pose
      (jest 'first')
      (jest 'second')
      (jest 'third')
      (jest 'fourth')
      (jest 'last')
    ==
  ::
  ++  zone-flag  |=(jon=json ?~(jon ~ (some ((su zflag) jon))))
  ++  zflag      ;~(plug ;~(pfix sig fed:ag) (cook crip (star prn)))
  ++  pool-id
    ;~  (glue fas)
      ;~(pfix sig fed:ag)
      (cook crip (star prn))
    ==
  ::
  ++  rid        `$-(json ^rid)`(su rflag)
  ++  rflag
    ;~  (glue fas)
      ;~(pose (cook some ;~(pfix sig fed:ag)) (cold ~ sig))
      (cook rule-type ;~(pose (jest 'left') (jest 'both') (jest 'fuld')))
      (cook crip (star prn))
    ==
  ::
  ++  arg
    ^-  $-(json ^arg)
    %-  of
    :~  [%ud ni]
        [%da di]
        [%od od]
        [%dr dr]
        [%dl dl]
        [%dx dx]
        [%wl (cu (list wkd-num) (ar ni))]
    ==
  ::
  ++  args
    |=  jon=json
    ^-  ^args
    ?>  &(?=(^ jon) ?=(%o -.jon))
    %-  ~(gas by *^args)
    %+  turn  ~(tap by p.jon)
    |=  [=@t a=json]
    [t (arg a)]
  --
--
