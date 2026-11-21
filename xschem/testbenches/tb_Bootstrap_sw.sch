v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -180 70 {}
N -330 0 -310 0 {lab=n1}
N -290 20 -290 40 {lab=VSS}
N -230 20 -230 40 {lab=clk_bar}
N -290 -50 -290 -30 {lab=VDD}
N -230 -50 -230 -30 {lab=clk}
N -200 0 -180 0 {lab=n2}
C {iopin.sym} -290 -50 0 1 {name=p5 lab=VDD}
C {iopin.sym} -290 40 0 1 {name=p6 lab=VSS}
C {ipin.sym} -230 40 0 1 {name=p7 lab=clk_bar}
C {ipin.sym} -230 -50 0 1 {name=p8 lab=clk
}
C {iopin.sym} -180 0 0 0 {name=p1 lab=n2}
C {iopin.sym} -330 0 0 1 {name=p2 lab=n1}
C {code_shown.sym} -330 150 0 0 {name=s1 only_toplevel=false value=".include /foss/designs/tb_switch_bootstrap.spice"}
C {launcher.sym} -220 210 0 0 {name=h1
descr=backannotate
tclcommand="xschem annotate_op"}
C {Analog/Bootstrap_Switch.sym} -260 0 0 0 {name=x1 Wn=1.0 Wp=1.0 LL=0.15}
