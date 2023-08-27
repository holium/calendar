:+  'Single'
  ['Time' %da]~
'''
|=  args=(map @t arg)
=/  =time  +:;;($>(%da arg) (~(got by args) 'Time'))
^-  $-(@ud (each jump rule-exception))
|=(@ud [%& time])
'''
