:+  'Yearly nth Weekday of Month'
  :~  ['Start Year' %ud]
      ['Month' %ud]
      ['Ordinal' %od]
      ['Weekday' %ud]
      ['Time' %dr]
      ['Offset' %dl]
  ==
'''
|=  args=(map @t arg)
=/  year=@ud   +:;;($>(%ud arg) (~(got by args) 'Start Year'))
=/  month=@ud  +:;;($>(%ud arg) (~(got by args) 'Month'))
=/  =ord       +:;;($>(%od arg) (~(got by args) 'Ordinal'))
=/  w=@ud      +:;;($>(%ud arg) (~(got by args) 'Weekday'))
=/  time=@dr   +:;;($>(%dr arg) (~(got by args) 'Time'))
=/  =delta     +:;;($>(%dl arg) (~(got by args) 'Offset'))
^-  $-(@ud (each jump rule-exception))
|=  idx=@ud
=/  day=(unit @da)  (nth-weekday [& (add year idx)] month ord w)
?~  day
  [%| %rule-error (crip "This date does not exist.")]
[%& (apply-delta (add u.day time) delta)]
'''
