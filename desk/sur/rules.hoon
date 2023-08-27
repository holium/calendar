/+  *time-utils
|%
+$  rule-type  ?(%both %left %fuld %jump %skip)
:: source, type and name
:: null for source means the rule is hardcoded
:: versioning recommended but not enforced
::
+$  rule-flag  (trel (unit ship) rule-type term)
+$  rid        rule-flag
:: parameter structure for a given recurrence rule
:: order matters for frontend parameter display
::
+$  parm  (list (pair @t term))
+$  args  (map @t arg)
:: both: the rule determines both left and right ends
:: left: the rule determines the left end, and the
::       right end is determined by duration
:: fuld: fullday (must be divisible by ~d1)
:: jump: for timezones; UTC-time at which we jump to a new offset
:: skip: a skip exception denoting a skipped instance
::
+$  kind  
  $%  [%both lz=(unit zone-flag) rz=(unit zone-flag)]
      [%left tz=(unit zone-flag) d=@dr]
      [%fuld ~]
      [%skip ~]
  ==
::
+$  rule  [name=@t =parm hoon=@t]
::
+$  span-exception
  $%  rule-exception
      [%bad-index l=(unit localtime) r=(unit localtime)]
      [%out-of-bounds tz=(unit zone-flag) d=@da] :: right end out-of-bounds
      $:  %out-of-order 
          l=[loc=localtime utc=@da] 
          r=[loc=localtime utc=@da]
      ==
      [%failed-to-retrieve-tz-to-utc tz=(unit zone-flag)]
      [%failed-to-retrieve-utc-to-tz tz=(unit zone-flag)]
  ==
::
+$  span-instance     (each span span-exception)
+$  fullday-instance  (each fullday rule-exception)
+$  jump-instance     (each jump rule-exception)
:: types for basic recurrence rule functions
::
+$  to-both        $-(@ud (each [dext dext] rule-exception))
:: only start (left) is specified; end (right) comes from duration
::
+$  to-left        $-(@ud (each dext rule-exception))
::
+$  to-span        $-(@ud span-instance)
+$  to-fullday     $-(@ud fullday-instance)
+$  to-jump        $-(@ud jump-instance)
::
+$  to-to-both     $-(args to-both)
+$  to-to-left     $-(args to-left)
+$  to-to-fullday  $-(args to-fullday)
+$  to-to-jump     $-(args to-jump)
::
+$  rule-field
  $%  [%name name=@t]
      [%parm =parm]
      [%hoon hoon=@t]
  ==
::
+$  rule-update  $%(rule-field [%rule =rule])
::
+$  rule-action
  %+  pair  rid
  $%  [%create =rule]
      [%update fields=(list rule-field)]
      [%delete ~]
  ==
::
++  crud
  |$  [create update delete]
  $%  [%c p=create]
      [%u p=update]
      [%d p=delete]
  ==
--
