v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -60 100 {}
N -30 -90 -30 80 {lab=n1}
N 30 -90 30 80 {lab=n2}
N -110 -0 -30 -0 {lab=n1}
N 30 0 100 0 {lab=n2}
N 0 -90 0 -70 {lab=VDD}
N -0 60 0 80 {lab=VSS}
N -0 -180 0 -130 {lab=clk_bar}
N 0 120 0 170 {lab=clk}
C {iopin.sym} 100 0 0 0 {name=p1 lab=n2}
C {iopin.sym} -110 0 0 1 {name=p2 lab=n1}
C {lab_wire.sym} 0 -70 1 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 0 80 1 0 {name=p4 sig_type=std_logic lab=VSS}
C {iopin.sym} -130 -170 0 1 {name=p5 lab=VDD}
C {iopin.sym} -130 -140 0 1 {name=p6 lab=VSS}
C {ipin.sym} 0 -180 0 0 {name=p7 lab=clk_bar}
C {ipin.sym} 0 170 0 0 {name=p8 lab=clk
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 0 100 3 0 {name=M3
W=Wn
L=LL
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 0 -110 1 0 {name=M4
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
model=pfet_01v8_lvt
spiceprefix=X
}
