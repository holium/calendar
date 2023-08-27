:+  'Yearly First Weekday After Date'
  :~  ['Start Year' %ud]
      ['Month' %ud]
      ['Day' %ud]
      ['Weekday' %ud]
      ['Time' %dr]
      ['Offset' %dl]
  ==
'''
|=  args=(map @t arg)
=/  year=@ud   +:;;($>(%ud arg) (~(got by args) 'Start Year'))
=/  month=@ud  +:;;($>(%ud arg) (~(got by args) 'Month'))
=/  date=@ud   +:;;($>(%ud arg) (~(got by args) 'Day'))
=/  w=@ud      +:;;($>(%ud arg) (~(got by args) 'Weekday'))
=/  time=@dr   +:;;($>(%dr arg) (~(got by args) 'Time'))
=/  =delta     +:;;($>(%dl arg) (~(got by args) 'Offset'))
^-  $-(@ud (each jump rule-exception))
|=  idx=@ud
=/  day=(unit @da)  (first-weekday-after [& (add year idx)] month date w)
?~  day
  [%| %rule-error (crip "This date does not exist.")]
[%& (apply-delta (add u.day time) delta)]
'''
