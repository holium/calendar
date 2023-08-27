/-  *rules
|%
+$  zid  zone-flag :: defined in time-utils
+$  tid  @tatid
::
+$  tz-rule
  $:  dom=[l=@ud r=@ud]
      name=@t
      offset=delta
      rule=[=rid =args]
      instances=(map @ud jump-instance)
  ==
::
+$  iref  [=tid i=@ud]
::
+$  zone
  $:  name=@t
      order=((mop @da iref) lth)
      rules=(map tid tz-rule)
      offsets=(jug delta tid)
  ==
::
+$  tz-rule-field
  $%  [%name name=@t]
      [%offset offset=delta]
  ==
::
+$  tz-rule-update
  $%  :: direct replace
      ::
      tz-rule-field
      [%dom dom=[l=@ud r=@ud]]
      [%rule =rid =args]
      :: put / del
      ::
      [%instance p=(each [idx=@ud int=jump-instance] @ud)]
  ==
::
+$  zone-field
  $%  [%name name=@t]
  ==
::
+$  zone-update
  $%  :: replace whole zone
      ::
      [%zone zon=zone]
      :: direct replace
      ::
      zone-field
      :: create / update / delete
      ::
      [%rule p=(crud [=tid rul=tz-rule] [=tid =tz-rule-update] tid)]
  ==
::
+$  peek
  $%  [%zones zones=(map zid zone)]
      [%zone =zone]
      [%flags flags=(list zid)]
  ==
::
+$  action
  $%  [%add-zone =flag=path =zone]
      [%put-zone =flag=path =zone] :: add or replace
      [%del-zone =flag] :: delete or unfollow
      [%get-zone =flag] :: follow zone at flag from the ship in p.flag
      [%watch =ship] :: follow all zones from ship
      [%leave =ship] :: stop following zones from ship
      :: modify live timezone
      ::
      [%spawn-zone =flag name=cord] :: create an empty live timezone
      [%shift-zone =flag offset=delta] :: shift zone to new offset
      :: [%edit-ruleset =flag rules=(list rule-data)] :: edit live rules
      [%freeze-zone =flag] :: freeze a live zone
  ==
::
++  iana
  =<  iana
  |%
  +$  iana   [=zones =rules =links]
  +$  links  (map @t @t)
  +$  rules  (map @ta rule)
  +$  rule   [name=@ta entries=(set rule-entry)]
  +$  usw    ?(%utc %standard %wallclock)
  ::
  +$  rule-entry
    $:  from=@ud
        to=rule-to
        in=mnt
        on=rule-on
        =at
        save=delta
        letter=@t
    ==
  ::
  +$  at  (pair usw @dr)
  ::
  +$  rule-to
    $%  [%year y=@ud]
        [%only ~]
        [%max ~]
    ==
  ::
  +$  rule-on
    $%  [%int =ord =wkd]  :: recurs yrly on ord w of m
        [%aft d=@ud =wkd] :: recurs yrly on first w after d of m
        [%dat d=@ud]      :: recurs yrly on d of m
    ==
  ::
  +$  zones  (map @ta zone)
  ::
  +$  zone   [name=@ta entries=(list zone-entry)]
  ::
  +$  zone-entry
    $:  stdoff=delta
        rules=zone-rules
        format=@t
        =until
    ==
  ::
  +$  until  (unit (pair usw @da))
  ::
  +$  zone-rules
    $%  [%nothing ~]
        [%delta =delta]
        [%rule name=@ta]
    ==
  ::
  +$  action
    $%  [%watch-iana ~]
        [%leave-iana ~]
        [%import-blob data=@t]
    ==
  --
--
