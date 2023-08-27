/-  *timezones
|%
++  dr-to-unix-ms  |=(d=@dr `@ud`(div d (div ~s1 1.000)))
++  to-unix-ms
  |=  d=@da
  ^-  [? @ud]
  ?:  (gte d ~1970.1.1)
    [& (dr-to-unix-ms (sub d ~1970.1.1))]
  [| (dr-to-unix-ms (sub ~1970.1.1 d))]
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
  ++  zid        |=(=^zid (rap 3 (scot %p p.zid) '/' q.zid ~))
  ++  dom        |=([l=@ud r=@ud] `json`(pairs ~[l+(numb l) r+(numb r)]))
  ++  iref       |=(^iref (rap 3 tid '/' (scot %ud i) ~))
  ::
  ++  dext
    |=  =^dext
    ^-  json
    %-  pairs
    :~  [%i (numb i.dext)]
        [%d (nimb (to-unix-ms d.dext))]
    ==
  ::
  ++  delta  |=(=^delta `json`(nimb sign.delta (dr-to-unix-ms d.delta)))
  ::
  ++  arg
    |=  =^arg
    ^-  json
    ?-  -.arg
      %ud  (frond %ud (numb p.arg))
      %da  (frond %da (nimb (to-unix-ms p.arg)))
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
  ++  jump  |=(jmp=^jump `json`(nimb (to-unix-ms jmp)))
  ::
  ++  rule-exception
    |=  rex=^rule-exception
    ^-  json
    ?-  -.rex
      %skip  s+%skip
      %rule-error  (frond %rule-error s+msg.rex)
    ==
  ::
  ++  jump-instance
    |=  ins=^jump-instance
    ^-  json
    ?-  -.ins
      %&  (frond %instance (jump +.ins))
      %|  (frond %exception (rule-exception +.ins))
    ==
  ::
  ++  instances
    |=  ins=(map @ud ^jump-instance)
    ^-  json
    :-  %a
    %+  turn  ~(tap by ins)
    |=  [idx=@ud i=^jump-instance]
    ^-  json
    %-  pairs
    :~  idx+s+(dedot (scot %ud idx))
        instance+(jump-instance i)
    ==
  ::
  ++  tz-rule
    |=  rul=^tz-rule
    ^-  json
    %-  pairs
    :~  [%dom (dom dom.rul)]
        [%name s+name.rul]
        [%offset (delta offset.rul)]
        [%rid s+(rule-flag rid.rule.rul)]
        [%args (args args.rule.rul)]
        [%instances (instances instances.rul)]
    ==
  ::
  ++  order
    |=  order=((mop @da ^iref) lth)
    ^-  json
    =/  tap=(list [@da ^iref])
      (tap:((on @da ^iref) lth) order)
    :-  %a
    %+  turn  tap
    |=  [t=@da i=^iref]
    ^-  json
    %-  pairs
    :~  [%t (nimb (to-unix-ms t))]
        [%i s+(iref i)]
    ==
  ::
  ++  rules
    |=  rules=(map tid ^tz-rule)
    ^-  json
    =-  o/(malt -)
    ^-  (list [@t json])
    %+  turn  ~(tap by rules)
    |=  [k=tid v=^tz-rule]
    [k (tz-rule v)]
  ::
  ++  offsets
    |=  offsets=(jug ^delta tid)
    ^-  json
    :-  %a
    %+  turn  ~(tap by offsets)
    |=  [d=^delta tids=(set tid)]
    %-  pairs
    :~  [%offset (delta d)]
        [%tids a+(turn ~(tap in tids) |=(=tid s+tid))]
    ==
  ::
  ++  zone
    |=  zon=^zone
    ^-  json
    %-  pairs
    :~  [%name s+name.zon]
        [%order (order order.zon)]
        [%rules (rules rules.zon)]
        [%offsets (offsets offsets.zon)]
    ==
  ::
  ++  zones
    |=  zones=(map ^zid ^zone)
    ^-  json
    =-  o/(malt -)
    ^-  (list [@t json])
    %+  turn  ~(tap by zones)
    |=  [k=^zid v=^zone]
    [(zid k) (zone v)]
  --
--
