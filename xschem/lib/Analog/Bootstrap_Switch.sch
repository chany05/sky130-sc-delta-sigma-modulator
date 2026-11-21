v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 160 150 {}
N -40 170 40 170 {lab=n1}
N 250 170 320 170 {lab=n2}
N 220 170 220 190 {lab=VSS}
N 220 80 220 130 {lab=G}
N 40 170 190 170 {lab=n1}
N 110 120 110 170 {lab=n1}
N 80 90 80 110 {lab=VSS}
N 80 20 80 50 {lab=G}
N 80 20 220 20 {lab=G}
N 220 50 220 80 {lab=G}
N 110 90 110 120 {lab=n1}
N 220 20 220 50 {lab=G}
N 20 90 50 90 {lab=CBB}
N -90 -50 10 -50 {lab=CBT}
N -90 10 10 10 {lab=CBB}
N -150 90 -150 110 {lab=VSS}
N -150 30 -150 50 {lab=clk_bar}
N -200 90 -180 90 {lab=VSS}
N -170 30 -150 30 {lab=clk_bar}
N -120 90 20 90 {lab=CBB}
N -40 10 -40 90 {lab=CBB}
N -40 -100 -40 -50 {lab=CBT}
N -110 -100 -40 -100 {lab=CBT}
N -40 -100 30 -100 {lab=CBT}
N 290 -100 290 -80 {lab=VSS}
N 60 -160 60 -140 {lab=clk_bar}
N -140 -200 -140 -140 {lab=G}
N 180 -100 250 -100 {lab=G}
N -140 -200 130 -200 {lab=G}
N 220 -200 220 -100 {lab=G}
N 250 -100 260 -100 {lab=G}
N -220 -100 -170 -100 {lab=VDD}
N -220 -120 -220 -100 {lab=VDD}
N 90 -100 180 -100 {lab=G}
N 220 -100 220 20 {lab=G}
N 130 -200 220 -200 {lab=G}
N 290 -160 290 -140 {lab=VDD}
N 320 -100 340 -100 {lab=X}
N 370 -100 370 -80 {lab=VSS}
N 370 -160 370 -140 {lab=clk_bar}
N 400 -100 420 -100 {lab=VSS}
N 60 -100 60 -90 {lab=CBT}
N 30 -90 60 -90 {lab=CBT}
N 30 -100 30 -90 {lab=CBT}
N -140 -100 -140 -90 {lab=CBT}
N -140 -90 -110 -90 {lab=CBT}
N -110 -100 -110 -90 {lab=CBT}
C {sky130_fd_pr/nfet_01v8.sym} 220 150 3 1 {name=M1
W=WN
L=LL
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {iopin.sym} 320 170 0 0 {name=p1 lab=n2}
C {iopin.sym} -40 170 0 1 {name=p2 lab=n1}
C {lab_wire.sym} 220 170 1 1 {name=p4 sig_type=std_logic lab=VSS}
C {iopin.sym} -340 140 0 1 {name=p5 lab=VDD}
C {iopin.sym} -340 170 0 1 {name=p6 lab=VSS}
C {ipin.sym} -340 40 0 0 {name=p7 lab=clk_bar}
C {ipin.sym} -340 70 0 0 {name=p8 lab=clk
}
C {sky130_fd_pr/nfet_01v8.sym} 80 70 3 1 {name=M2
W=WN
L=LL
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 80 90 1 1 {name=p3 sig_type=std_logic lab=VSS}
C {sky130_fd_pr/cap_mim_m3_1.sym} 10 -20 0 0 {name=C1 model=cap_mim_m3_1 W=3 L=3 MF=5 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_2.sym} -90 -20 0 0 {name=C2 model=cap_mim_m3_2 W=3 L=3 MF=5 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} -150 70 1 0 {name=M3
W=WN
L=LL
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} -150 90 1 1 {name=p10 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -200 90 1 1 {name=p11 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -150 30 0 0 {name=p12 sig_type=std_logic lab=clk_bar}
C {sky130_fd_pr/nfet_01v8.sym} 290 -120 3 1 {name=M6
W=WN
L=LL
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 290 -100 1 1 {name=p15 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 60 -150 0 0 {name=p16 sig_type=std_logic lab=clk_bar}
C {lab_wire.sym} -220 -120 2 1 {name=p17 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/pfet_01v8.sym} -140 -120 1 0 {name=M7
W=Wp
L=LL
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 290 -160 2 1 {name=p18 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/nfet_01v8.sym} 370 -120 3 1 {name=M8
W=WN
L=LL
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 370 -100 1 1 {name=p19 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 370 -160 2 1 {name=p20 sig_type=std_logic lab=clk_bar}
C {lab_wire.sym} 410 -100 1 1 {name=p21 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -30 -100 0 0 {name=p22 sig_type=std_logic lab=CBT}
C {lab_wire.sym} -40 90 0 0 {name=p23 sig_type=std_logic lab=CBB}
C {lab_wire.sym} 220 20 0 0 {name=p24 sig_type=std_logic lab=G}
C {lab_wire.sym} 340 -100 0 0 {name=p25 sig_type=std_logic lab=X}
C {sky130_fd_pr/pfet_01v8.sym} 60 -120 1 0 {name=M4
W=Wp
L=LL
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
