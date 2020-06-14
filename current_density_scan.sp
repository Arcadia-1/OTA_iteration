$ id / w scan vs. gm / id 
$ zhang zhishuai, April 2020 


*  *  *  *  *  *  *  *  *  * define parameters *  *  *  *  *  *  *  *  *  * 
.param vdd = 3V 
+Wid1 = 10um 
+Wid2 = 10um 

*  *  *  *  *  *  *  *  *  * define stimulii *  *  *  *  *  *  *  *  *  * 
vd avdd 0 dc = vdd 
vgn gn 0 dc = gs'
vgp gp 0 dc = 'vdd - gs'


*  *  *  *  *  *  *  *  *  * define main circuit *  *  *  *  *  *  *  *  *  * 
mn1 avdd gn 0 0 nch214 L W = Wid1 
mp1 0 gp avdd avdd pch214 L W = Wid2 


*  *  *  *  *  *  *  *  *  * analysis options *  *  *  *  *  *  *  *  *  * 
.op
.dc gs 0.4V 1.4V 5mV L 0.35um 0.80um 0.05um 

.probe gm_id_n = par('gmo(mn1)/i(mn1)') 
.probe gm_id_p = par('gmo(mp1)/i(mp1)') 
.probe id_w_n = par('i(mn1)/Wid1') 
.probe id_w_p = par('i(mp1)/Wid2') 
.probe ft_n = par('1/2/3.14159*gmo(mn1)/(-cgsbo(mn1))') 
.probe ft_p = par('1/2/3.14159*gmo(mp1)/(-cgsbo(mp1))') 

.probe ov_n = par('gs-vth(mn1)') 
.probe ov_p = par('vdd-gs-vth(mp1)') 
.probe L 

*  *  *  *  *  *  *  *  *  * options and libraries *  *  *  *  *  *  *  *  *  * 
.options post brief dccap 
.lib './ee214_hspice.txt' nominal 
.end