v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -570 10 -540 10 {lab=OUTp}
N -480 10 -440 10 {lab=#net1}
N -380 10 -350 10 {lab=OUTn}
N -460 10 -460 70 {lab=#net1}
N -460 70 -370 70 {lab=#net1}
N -460 110 -370 110 {lab=CMFB_ref}
N -520 110 -460 110 {lab=CMFB_ref}
N -330 120 -330 150 {lab=VSS}
N -330 40 -330 60 {lab=CMFB}
N -330 40 -280 40 {lab=CMFB}
N -110 30 -110 50 {lab=CMFB_ref}
N 0 30 0 50 {lab=VDD}
N 100 30 100 50 {lab=Ibias}
N 180 30 180 50 {lab=VSS}
N 270 -30 270 -10 {lab=INp}
N 420 -30 420 -10 {lab=INn}
N -680 10 -630 10 {lab=VSS}
N -290 10 -240 10 {lab=VSS}
N 10 300 60 300 {lab=fb_m}
N 10 410 60 410 {lab=fb_p}
N 410 210 450 210 {lab=CMFB}
N 140 260 180 260 {lab=ch_OUTp}
N 140 450 180 450 {lab=ch_OUTn}
N 510 340 510 360 {lab=VSS}
N 520 200 520 220 {lab=VDD}
N 530 340 530 360 {lab=Ibias}
N 410 180 430 180 {lab=CMFB_ref}
N 60 260 70 260 {lab=fb_m}
N 60 260 60 300 {lab=fb_m}
N 130 260 140 260 {lab=ch_OUTp}
N 60 410 60 450 {lab=fb_p}
N 60 450 70 450 {lab=fb_p}
N 130 450 140 450 {lab=ch_OUTn}
N -30 410 10 410 {lab=fb_p}
N -30 300 10 300 {lab=fb_m}
N -110 300 -90 300 {lab=CMFB_ref}
N -110 410 -90 410 {lab=CMFB_ref}
N 240 260 260 260 {lab=CMFB_ref}
N 240 450 260 450 {lab=CMFB_ref}
N 240 300 270 300 {lab=INn}
N 240 400 270 400 {lab=INp}
N 130 300 180 300 {lab=ch_OUTp}
N 130 260 130 300 {lab=ch_OUTp}
N 130 400 180 400 {lab=ch_OUTn}
N 130 400 130 450 {lab=ch_OUTn}
N 340 50 340 60 {lab=ac_p}
N 340 60 340 70 {lab=ac_p}
N -30 260 -30 300 {lab=fb_m}
N -90 260 -90 300 {lab=CMFB_ref}
N -30 370 -30 410 {lab=fb_p}
N -90 370 -90 410 {lab=CMFB_ref}
N 310 60 340 60 {lab=ac_p}
N 310 100 320 100 {lab=0}
N 320 100 320 130 {lab=0}
N 320 130 340 130 {lab=0}
N 270 110 270 130 {lab=0}
N 270 130 320 130 {lab=0}
N 350 60 380 60 {lab=ac_p}
N 370 100 380 100 {lab=0}
N 420 110 420 130 {lab=0}
N 370 130 420 130 {lab=0}
N 340 130 370 130 {lab=0}
N 370 100 370 130 {lab=0}
N 340 60 350 60 {lab=ac_p}
N 110 -270 130 -270 {lab=CMFB}
N -40 -390 -40 -360 {lab=VDD}
N -40 -180 -40 -150 {lab=VSS}
N -70 -160 -70 -130 {lab=Ibias}
N 300 -320 330 -320 {lab=ch_OUTp}
N 300 -220 330 -220 {lab=ch_OUTn}
N 10 -330 220 -330 {lab=OUTp}
N 220 -330 220 -320 {lab=OUTp}
N 220 -220 220 -210 {lab=OUTn}
N 10 -210 220 -210 {lab=OUTn}
N -250 -320 -230 -320 {lab=INn}
N -250 -220 -230 -220 {lab=INp}
N -210 -360 -210 -340 {lab=VDD}
N -210 -200 -210 -180 {lab=VSS}
N -170 -200 -170 -180 {lab=VDD}
N -170 -360 -170 -340 {lab=VSS}
N 240 -350 240 -340 {lab=VDD}
N 240 -200 240 -190 {lab=VSS}
N 280 -350 280 -340 {lab=VSS}
N 280 -200 280 -190 {lab=VDD}
N -150 -320 -110 -320 {lab=#net2}
N -150 -220 -110 -220 {lab=#net3}
N -170 -200 -170 -180 {lab=VDD}
C {res.sym} -510 10 3 1 {name=R5
value=100Meg
footprint=1206
device=resistor
m=1}
C {res.sym} -410 10 3 1 {name=R6
value=100Meg
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} -550 10 0 0 {name=p9 sig_type=std_logic lab=OUTp}
C {lab_wire.sym} -370 10 0 1 {name=p10 sig_type=std_logic lab=OUTn}
C {vcvs.sym} -330 90 0 0 {name=E1 value=200}
C {iopin.sym} -520 110 0 1 {name=p11 lab=CMFB_ref}
C {lab_wire.sym} -330 150 0 0 {name=p12 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -310 40 0 1 {name=p13 sig_type=std_logic lab=CMFB}
C {lab_wire.sym} -110 30 0 1 {name=p14 sig_type=std_logic lab=CMFB_ref}
C {vsource.sym} -110 80 0 0 {name=V1 value=0.9 savecurrent=false}
C {lab_wire.sym} 0 30 0 1 {name=p16 sig_type=std_logic lab=VDD}
C {vsource.sym} 0 80 0 0 {name=V2 value=1.8 savecurrent=false}
C {lab_wire.sym} 100 30 0 1 {name=p18 sig_type=std_logic lab=Ibias}
C {isource.sym} 100 80 0 0 {name=I0 value=15.4u}
C {lab_wire.sym} 180 30 0 1 {name=p21 sig_type=std_logic lab=VSS}
C {vsource.sym} 180 80 0 0 {name=V3 value=0 savecurrent=false
lab=VSS}
C {gnd.sym} -110 110 0 0 {name=l1 lab=0}
C {gnd.sym} 0 110 0 0 {name=l2 lab=0}
C {gnd.sym} 100 110 0 0 {name=l3 lab=0}
C {gnd.sym} 180 110 0 0 {name=l4 lab=0}
C {lab_wire.sym} 270 -30 0 1 {name=p15 sig_type=std_logic lab=INp}
C {vsource.sym} 340 100 0 0 {name=V4 value="dc 0 ac 1" savecurrent=false
lab=INp}
C {lab_wire.sym} 420 -30 0 1 {name=p17 sig_type=std_logic lab=INn}
C {capa.sym} -600 10 1 1 {name=C5
m=1
value=150f
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} -680 10 2 1 {name=p19 sig_type=std_logic lab=VSS}
C {capa.sym} -320 10 3 0 {name=C7
m=1
value=150f
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} -240 10 2 0 {name=p22 sig_type=std_logic lab=VSS}
C {gnd.sym} 340 130 0 0 {name=l5 lab=0}
C {code_shown.sym} -660 300 0 0 {name=s1 only_toplevel=false value=".include /foss/designs/tb_ch_OTA.spice"}
C {launcher.sym} -540 220 0 0 {name=h1
descr=backannotate
tclcommand="xschem annotate_op"}
C {lab_wire.sym} 10 300 0 1 {name=p23 sig_type=std_logic lab=fb_m}
C {lab_wire.sym} 10 410 0 1 {name=p24 sig_type=std_logic lab=fb_p}
C {lab_wire.sym} 150 450 0 1 {name=p25 sig_type=std_logic lab=ch_OUTn}
C {lab_wire.sym} 150 260 0 1 {name=p26 sig_type=std_logic lab=ch_OUTp}
C {lab_wire.sym} 510 350 2 1 {name=p27 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 520 210 0 1 {name=p28 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 530 350 2 0 {name=p29 sig_type=std_logic lab=Ibias}
C {lab_wire.sym} 420 210 0 1 {name=p30 sig_type=std_logic lab=CMFB}
C {lab_wire.sym} 420 180 0 1 {name=p31 sig_type=std_logic lab=CMFB_ref}
C {capa.sym} -60 300 3 1 {name=C6
m=1
value=4.2p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 100 260 3 1 {name=C8
m=1
value=7p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 100 450 3 1 {name=C9
m=1
value=7p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} -60 410 3 1 {name=C10
m=1
value=4.2p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 210 260 3 0 {name=C11
m=1
value=400f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 210 450 3 0 {name=C12
m=1
value=400f
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} -110 300 3 1 {name=p32 sig_type=std_logic lab=CMFB_ref}
C {lab_wire.sym} -110 410 3 0 {name=p33 sig_type=std_logic lab=CMFB_ref}
C {lab_wire.sym} 260 260 1 0 {name=p34 sig_type=std_logic lab=CMFB_ref}
C {lab_wire.sym} 260 450 1 1 {name=p35 sig_type=std_logic lab=CMFB_ref}
C {ind.sym} 210 300 3 1 {name=Lfb
m=1
value=1G
footprint=1206
device=inductor}
C {ind.sym} 210 400 1 1 {name=Lfb1
m=1
value=1G
footprint=1206
device=inductor}
C {lab_wire.sym} 260 400 2 0 {name=p36 sig_type=std_logic lab=INp}
C {lab_wire.sym} 250 300 0 1 {name=p37 sig_type=std_logic lab=INn}
C {capa.sym} 270 20 0 0 {name=C14
m=1
value=1m
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 340 50 0 1 {name=p38 sig_type=std_logic lab=ac_p}
C {res.sym} -60 260 1 1 {name=R7
value=1T
footprint=1206
device=resistor
m=1}
C {res.sym} -60 370 1 1 {name=R8
value=1T
footprint=1206
device=resistor
m=1}
C {vcvs.sym} 270 80 0 1 {name=E2 value=0.5}
C {capa.sym} 420 20 0 1 {name=C19
m=1
value=1m
footprint=1206
device="ceramic capacitor"}
C {vcvs.sym} 420 80 0 0 {name=E3 value=-0.5}
C {Analog/FullyDiffOTA.sym} 10 -450 0 0 {name=x1}
C {Analog/chopper.sym} -190 -270 0 0 {name=x2}
C {Analog/chopper.sym} 260 -270 0 0 {name=x3}
C {lab_wire.sym} -70 -130 0 1 {name=p1 sig_type=std_logic lab=Ibias}
C {lab_wire.sym} -40 -150 0 1 {name=p2 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -40 -380 0 1 {name=p3 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 40 -330 0 1 {name=p4 sig_type=std_logic lab=OUTp}
C {lab_wire.sym} 40 -210 0 1 {name=p5 sig_type=std_logic lab=OUTn}
C {lab_wire.sym} -240 -220 0 0 {name=p6 sig_type=std_logic lab=INp}
C {lab_wire.sym} -240 -320 0 0 {name=p7 sig_type=std_logic lab=INn}
C {lab_wire.sym} -210 -360 0 1 {name=p8 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -210 -180 2 0 {name=p20 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 240 -350 0 1 {name=p39 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 240 -190 2 0 {name=p40 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 330 -320 0 1 {name=p45 sig_type=std_logic lab=ch_OUTp}
C {lab_wire.sym} 330 -220 0 1 {name=p46 sig_type=std_logic lab=ch_OUTn}
C {lab_wire.sym} 120 -270 0 1 {name=p47 sig_type=std_logic lab=CMFB}
C {lab_wire.sym} -170 -360 2 0 {name=p41 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -170 -190 0 1 {name=p42 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 280 -190 0 1 {name=p43 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 280 -350 2 0 {name=p44 sig_type=std_logic lab=VSS}
