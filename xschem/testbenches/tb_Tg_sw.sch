v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 80 70 {}
N -70 0 -50 0 {lab=n1}
N -30 20 -30 40 {lab=VSS}
N 30 20 30 40 {lab=clk_bar}
N -30 -50 -30 -30 {lab=VDD}
N 30 -50 30 -30 {lab=clk}
N 60 0 80 0 {lab=n2}
C {Analog/TG_switch.sym} 0 0 0 0 {name=x1 Wn=3.0 Wp=10.0 LL=0.35}
C {iopin.sym} -30 -50 0 1 {name=p5 lab=VDD}
C {iopin.sym} -30 40 0 1 {name=p6 lab=VSS}
C {ipin.sym} 30 40 0 1 {name=p7 lab=clk_bar}
C {ipin.sym} 30 -50 0 1 {name=p8 lab=clk
}
C {iopin.sym} 80 0 0 0 {name=p1 lab=n2}
C {iopin.sym} -70 0 0 1 {name=p2 lab=n1}
C {code_shown.sym} -70 150 0 0 {name=s1 only_toplevel=false value=".include /foss/designs/tb_switch_tg.spice"}
C {launcher.sym} 40 210 0 0 {name=h1
descr=backannotate
tclcommand="xschem annotate_op"}
