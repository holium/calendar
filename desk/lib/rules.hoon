/-  *rules
:: Import hardcoded recurrence rules
::
/~  hard-both  rule  /lib/rule/both
/~  hard-left  rule  /lib/rule/left
/~  hard-fuld  rule  /lib/rule/fuld
/~  hard-jump  rule  /lib/rule/jump
::
=>  |%
    +$  cache
      $:  to-to-boths=(map rid to-to-both)
          to-to-lefts=(map rid to-to-left)
          to-to-fulldays=(map rid to-to-fullday)
          to-to-jumps=(map rid to-to-jump)
      ==
    +$  card  card:agent:gall
    +$  sign  sign:agent:gall
    --
=|  cards=(list card)
|_  [=bowl:gall rules=(map rid rule) =cache]
+*  this   .
++  abet  [(flop cards) rules]
++  emit  |=(=card this(cards [card cards]))
++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
::
++  en-path
  |=  =rid
  ^-  path
  =|  host=@ta  
  =?  host  ?=(^ p.rid)  (scot %p u.p.rid)
  /rule/[host]/[q.rid]/[r.rid]
:: reset hardcoded rules in on-init and on-load
::
++  hardcode
  ^+  rules
  :: purge hardcoded
  =.  rules
    %-  ~(gas by *(map rid rule))
    %+  murn
      ~(tap by rules)
    |=  [=rid rule]
    ?~  p.rid :: null source means hardcoded
      ~ 
    (some +<)
  :: replace hardcoded
  |^
  %-  ~(gas by rules)
  ;:  weld
    ((lead %both) hard-both)
    ((lead %left) hard-left)
    ((lead %fuld) hard-fuld)
    ((lead %jump) hard-jump)
  ==
  ++  lead
    |=  type=rule-type
    |=  hard=(map term rule)
    ^-  (list [rid rule])
    %+  turn  ~(tap by hard)
    |=  [=term =rule]
    [[~ type term] rule]
  --
++  make-rule
  |=  =rid
  ^+  this
  =/  =rule  (~(got by rules) rid)
  :: TODO: catch %rule-failed-to-parse and %rule-failed-to-compile
  ::
  =+  (slap !>(..arg) (ream hoon.rule)) :: compile against lib/time-utils.hoon
  %=    this
      cache
    ?+  q.rid  cache
      %both  cache(to-to-boths (~(put by to-to-boths.cache) rid !<(to-to-both -)))
      %left  cache(to-to-lefts (~(put by to-to-lefts.cache) rid !<(to-to-left -)))
      %fuld  cache(to-to-fulldays (~(put by to-to-fulldays.cache) rid !<(to-to-fullday -)))
      %jump  cache(to-to-jumps (~(put by to-to-jumps.cache) rid !<(to-to-jump -)))
    ==
  ==
::
++  cache-rules
  ^+  cache
  =.  cache  *^cache
  =/  rules=(list [rid rule])
    ~(tap by rules)
  |-  ?~  rules  cache
  =/  [=rid =rule]  i.rules
  $(rules t.rules, this (make-rule rid))
::
++  follow-rule
  |=  =rid
  ^-  _this
  ?~  p.rid  this
  =/  =wire  (en-path rid)
  =/  =dock  [u.p.rid dap.bowl]
  ?:  (~(has by wex.bowl) wire dock)  this
  (emit %pass wire %agent dock %watch wire)
::
++  follow-rules
  |=  rules=(list rid)
  ^-  _this
  ?~  rules  this
  $(rules t.rules, this (follow-rule i.rules))
::
++  handle-rule-action
  |=  axn=rule-action
  ^-  _this
  ?>  =(src our):bowl
  ?>  ?=(^ p.p.axn) :: can't edit hardcoded rules
  ?>  =(our.bowl u.p.p.axn)
  ?-    -.q.axn
      %create
    this(rules (~(put by rules) [p rule.q]:axn))
    ::
      %update
    =/  =rule  (~(got by rules) p.axn)
    =.  rule   (do-updates rule fields.q.axn)
    =.  rules  (~(put by rules) p.axn rule)
    :: emit fields as updates
    ::
    %-  emil
    %+  turn  fields.q.axn
    =/  =path  (en-path p.axn)
    |=  upd=rule-field
    ^-  card
    [%give %fact ~[path] rule-update+!>(upd)]
    ::
      %delete
    =.  rules  (~(del by rules) p.axn)
    (emit %give %kick ~[(en-path p.axn)] ~)
  ==
::
++  handle-rule-update
  |=  [=rid upd=rule-update]
  ^-  _this
  =/  =rule  (~(got by rules) rid)
  =.  rule   (do-update upd rule)
  this(rules (~(put by rules) rid rule))
::
++  do-update
  |=  [upd=rule-update =rule]
  ^+  rule
  ?-  -.upd
    %rule  rule.upd
    %name  rule(name name.upd)
    %parm  rule(parm parm.upd)
    %hoon  rule(hoon hoon.upd)
  ==
::
++  do-updates
  |=  [=rule upds=(list rule-update)]
  ^+  rule
  |-  ?~  upds  rule
  %=  $
    upds  t.upds
    rule  (do-update i.upds rule)
  ==
--
