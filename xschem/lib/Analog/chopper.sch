v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -70 -20 {}
N 90 -140 90 -120 {lab=clk}
N 30 -70 30 -50 {lab=VSS}
N 30 -140 30 -120 {lab=VDD}
N 90 -70 90 -50 {lab=clk_b}
N -70 -90 10 -90 {lab=IN1}
N 120 -90 270 -90 {lab=OUT1}
N -60 -90 -60 -10 {lab=IN1}
N 90 -20 90 0 {lab=clk_b}
N 30 50 30 70 {lab=VSS}
N 30 -20 30 0 {lab=VDD}
N 90 50 90 70 {lab=clk}
N -60 -10 -60 30 {lab=IN1}
N -60 30 10 30 {lab=IN1}
N 120 30 260 30 {lab=OUT2}
N 270 280 280 280 {lab=OUT2}
N 90 120 90 140 {lab=clk_b}
N 30 190 30 210 {lab=VSS}
N 30 120 30 140 {lab=VDD}
N 90 190 90 210 {lab=clk}
N -60 170 10 170 {lab=IN2}
N 30 300 30 320 {lab=VSS}
N 90 300 90 320 {lab=clk_b}
N -60 280 10 280 {lab=IN2}
N 120 280 260 280 {lab=OUT2}
N 260 280 270 280 {lab=OUT2}
N -70 280 -60 280 {lab=IN2}
N -60 170 -60 280 {lab=IN2}
N -80 280 -70 280 {lab=IN2}
N -80 -90 -70 -90 {lab=IN1}
N 260 30 260 280 {lab=OUT2}
N 270 -90 280 -90 {lab=OUT1}
N 270 -90 270 170 {lab=OUT1}
N 120 170 270 170 {lab=OUT1}
N 90 230 90 250 {lab=clk}
N 30 300 30 320 {lab=VSS}
N 30 230 30 250 {lab=VDD}
N 90 300 90 320 {lab=clk_b}
C {iopin.sym} -80 -90 0 1 {name=p1 lab=IN1}
C {iopin.sym} -80 280 0 1 {name=p2 lab=IN2}
C {iopin.sym} 280 -90 0 0 {name=p3 lab=OUT1}
C {iopin.sym} 280 280 0 0 {name=p4 lab=OUT2}
C {lab_wire.sym} 30 -60 1 1 {name=p5 sig_type=std_logic lab=VSS}
C {Analog/TG_switch.sym} 60 -90 0 0 {name=x1 Wn=4.0 Wp=14.0 LL=0.35}
C {lab_wire.sym} 30 -130 1 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 30 60 1 1 {name=p6 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 30 -10 1 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 30 200 1 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 30 130 1 0 {name=p10 sig_type=std_logic lab=VDD}
C {iopin.sym} -180 -90 0 1 {name=p12 lab=clk}
C {iopin.sym} -180 -60 0 1 {name=p13 lab=clk_b}
C {lab_wire.sym} 90 -130 0 1 {name=p14 sig_type=std_logic lab=clk}
C {lab_wire.sym} 90 60 2 0 {name=p15 sig_type=std_logic lab=clk}
C {lab_wire.sym} 90 200 2 0 {name=p16 sig_type=std_logic lab=clk}
C {lab_wire.sym} 30 310 1 1 {name=p18 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 30 240 1 0 {name=p19 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 90 240 0 1 {name=p20 sig_type=std_logic lab=clk}
C {iopin.sym} -290 -90 0 1 {name=p11 lab=VDD}
C {iopin.sym} -290 -60 0 1 {name=p17 lab=VSS}
C {lab_wire.sym} 90 -10 0 1 {name=p21 sig_type=std_logic lab=clk_b}
C {lab_wire.sym} 90 -60 2 0 {name=p22 sig_type=std_logic lab=clk_b}
C {lab_wire.sym} 90 130 0 1 {name=p23 sig_type=std_logic lab=clk_b}
C {lab_wire.sym} 90 310 2 0 {name=p24 sig_type=std_logic lab=clk_b}
C {Analog/TG_switch.sym} 60 30 0 0 {name=x2 Wn=4.0 Wp=14.0 LL=0.35}
C {Analog/TG_switch.sym} 60 170 0 0 {name=x3 Wn=4.0 Wp=14.0 LL=0.35}
C {Analog/TG_switch.sym} 60 280 0 0 {name=x4 Wn=4.0 Wp=14.0 LL=0.35}
