:+  'Yearly First Weekday After Date'
  :~  ['Start Year' %ud]
      ['Month' %ud]
      ['Day' %ud]
      ['Time' %dr]
      ['Offset' %dl]
  ==
'''
|=  args=(map @t arg)
=/  year=@ud   +:;;($>(%ud arg) (~(got by args) 'Start Year'))
=/  month=@ud  +:;;($>(%ud arg) (~(got by args) 'Month'))
=/  date=@ud   +:;;($>(%ud arg) (~(got by args) 'Day'))
=/  time=@dr   +:;;($>(%dr arg) (~(got by args) 'Time'))
=/  =delta     +:;;($>(%dl arg) (~(got by args) 'Offset'))
^-  $-(@ud (each jump rule-exception))
|=  idx=@ud
=/  day=(unit @da)  (date-of-month [& (add year idx)] month date)
?~  day
  [%| %rule-error (crip "This date does not exist.")]
[%& (apply-delta (add u.day time) delta)]
'''
