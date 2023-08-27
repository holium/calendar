/-  spider, timezones
/+  *strandio
=,  strand=strand:spider
=<
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
;<  our=@p  bind:m  get-our
;<  ~       bind:m  (poke [our %iana] watch-iana-poke)
%-  (slog leaf+(weld "importing all timezones from " url-prefix) ~)
=/  files=wall  files
|-  ^-  form:m
=*  loop  $ :: since each ;< introduces a new $ we need to bind this.
?~  files  (pure:m !>(~))
%-  (slog leaf+"requesting {i.files}" ~)
;<  data=@t  bind:m  (fetch-cord (weld url-prefix i.files))
;<  ~        bind:m  (poke [our %iana] (make-import-poke data))
loop(files t.files)
|%
++  watch-iana-poke
  ^-  cage
  :-  %iana-action
  !>  ^-  action:iana:timezones
  [%watch-iana ~]
::
++  make-import-poke
  |=  data=@t
  ^-  cage
  :-  %iana-action
  !>  ^-  action:iana:timezones
  [%import-blob data]
::
++  url-prefix  "https://raw.githubusercontent.com/eggert/tz/main/"
++  files
  ^-  wall
  :~  "northamerica"
      "asia"
      "australasia"
      "africa"
      "antarctica"
      "europe"
      "southamerica"
  ==
--
