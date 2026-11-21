v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 5 -2520 -1350 2750 -1350 2750 1610 -2520 1610 -2520 -1350 {}
N 610 -150 610 -130 {lab=VCM}
N 710 -150 710 -130 {lab=VDD}
N 810 -150 810 -130 {lab=Ibias}
N 910 -150 910 -130 {lab=VSS}
N 1010 -150 1010 -130 {lab=VREFp}
N 1110 -150 1110 -130 {lab=VREFn}
N 1220 -150 1220 -130 {lab=Vbias}
N 610 20 610 40 {lab=clk1_nd}
N 710 20 710 40 {lab=clk1e_nd}
N 610 140 610 160 {lab=clk2_nd}
N 710 140 710 160 {lab=clk2e_nd}
N -420 60 -420 90 {lab=Vbias}
N -410 60 -410 90 {lab=VREFn}
N -400 60 -400 90 {lab=VREFp}
N -390 60 -390 90 {lab=VCM}
N -340 60 -340 90 {lab=clk1_nd}
N -330 60 -330 90 {lab=clk2_nd}
N -320 60 -320 90 {lab=clk1e_nd}
N -310 60 -310 90 {lab=clk2e_nd}
N -270 -10 -240 -10 {lab=OUTp}
N -270 0 -240 0 {lab=OUTn}
N -500 -30 -470 -30 {lab=INPUTp}
N -500 -20 -470 -20 {lab=INPUTn}
N -500 10 -470 10 {lab=DAC}
N -500 20 -470 20 {lab=DAC_b}
N -380 -100 -380 -70 {lab=VDD}
N -370 -100 -370 -70 {lab=Ibias}
N -360 -100 -360 -70 {lab=VSS}
N -80 70 -80 100 {lab=#net1}
N -80 70 -20 70 {lab=#net1}
N -40 50 -20 50 {lab=clk1}
N 160 50 190 50 {lab=DAC}
N 160 70 190 70 {lab=DAC_b}
N -100 -100 -60 -100 {lab=VDD}
N -80 -60 -60 -60 {lab=clk1_nd}
N -80 -60 -80 -40 {lab=clk1_nd}
N 160 -80 190 -80 {lab=clk1}
N 60 -80 80 -80 {lab=#net2}
N -80 160 -80 190 {lab=VSS}
C {Analog/SC_Integrator.sym} -370 0 0 0 {name=x1}
C {vsource.sym} 610 -100 0 0 {name=V1 value=0.9 savecurrent=false}
C {lab_wire.sym} 710 -150 0 1 {name=p16 sig_type=std_logic lab=VDD}
C {vsource.sym} 710 -100 0 0 {name=V2 value=1.8 savecurrent=false}
C {lab_wire.sym} 810 -150 0 1 {name=p18 sig_type=std_logic lab=Ibias}
C {isource.sym} 810 -100 0 0 {name=I0 value=10.25u}
C {lab_wire.sym} 910 -150 0 1 {name=p21 sig_type=std_logic lab=VSS}
C {vsource.sym} 910 -100 0 0 {name=V3 value=0 savecurrent=false
lab=VSS}
C {gnd.sym} 610 -70 0 0 {name=l1 lab=0}
C {gnd.sym} 710 -70 0 0 {name=l2 lab=0}
C {gnd.sym} 810 -70 0 0 {name=l3 lab=0}
C {gnd.sym} 910 -70 0 0 {name=l4 lab=0}
C {code_shown.sym} 830 -250 0 0 {name=s1 only_toplevel=false value=".include /foss/designs/tb_DeltaSigmaADC.spice"}
C {launcher.sym} 630 -250 0 0 {name=h1
descr=backannotate
tclcommand="xschem annotate_op"}
C {lab_wire.sym} 610 -150 0 1 {name=p11 sig_type=std_logic lab=VCM}
C {vsource.sym} 1010 -100 0 0 {name=Vrefp value=1.5 savecurrent=false}
C {gnd.sym} 1010 -70 0 0 {name=Vrefp1 lab=0}
C {lab_wire.sym} 1010 -150 0 1 {name=Vrefp2 sig_type=std_logic lab=VREFp}
C {vsource.sym} 1110 -100 0 0 {name=Vrefn value=0.3 savecurrent=false}
C {gnd.sym} 1110 -70 0 0 {name=Vrefp4 lab=0}
C {lab_wire.sym} 1110 -150 0 1 {name=Vrefp5 sig_type=std_logic lab=VREFn}
C {lab_wire.sym} 1220 -150 0 1 {name=p9 sig_type=std_logic lab=Vbias}
C {vsource.sym} 1220 -100 0 0 {name=V6 value=0.68 savecurrent=false}
C {gnd.sym} 1220 -70 0 0 {name=l13 lab=0}
C {vsource.sym} 610 70 0 1 {name=Vclk1_nd value="PULSE 0 1.8 2n 0.1n 0.1n 238n 488.28n" savecurrent=false}
C {gnd.sym} 610 100 0 0 {name=l7 lab=0}
C {lab_wire.sym} 610 20 0 1 {name=p58 sig_type=std_logic lab=clk1_nd}
C {vsource.sym} 710 70 0 0 {name=Vclk1e_nd value="PULSE 0 1.8 2n 0.1n 0.1n 237n 488.28n" savecurrent=false}
C {gnd.sym} 710 100 0 1 {name=l8 lab=0}
C {lab_wire.sym} 710 20 0 1 {name=p59 sig_type=std_logic lab=clk1e_nd}
C {vsource.sym} 610 190 0 1 {name=Vclk2_nd value="PULSE 0 1.8 246.14n 0.1n 0.1n 238n 488.28n" savecurrent=false}
C {gnd.sym} 610 220 0 0 {name=l9 lab=0}
C {lab_wire.sym} 610 140 0 1 {name=p84 sig_type=std_logic lab=clk2_nd}
C {vsource.sym} 710 190 0 0 {name=Vclk2e_nd value="PULSE 0 1.8 246.14n 0.1n 0.1n 237n 488.28n" savecurrent=false}
C {gnd.sym} 710 220 0 1 {name=l10 lab=0}
C {lab_wire.sym} 710 140 0 1 {name=p85 sig_type=std_logic lab=clk2e_nd}
C {lab_wire.sym} -420 80 3 0 {name=p1 sig_type=std_logic lab=Vbias}
C {lab_wire.sym} -410 80 3 0 {name=p2 sig_type=std_logic lab=VREFn}
C {lab_wire.sym} -400 80 3 0 {name=p3 sig_type=std_logic lab=VREFp}
C {lab_wire.sym} -390 80 3 0 {name=p4 sig_type=std_logic lab=VCM}
C {lab_wire.sym} -340 80 3 0 {name=p5 sig_type=std_logic lab=clk1_nd}
C {lab_wire.sym} -330 80 3 0 {name=p6 sig_type=std_logic lab=clk2_nd}
C {lab_wire.sym} -320 80 3 0 {name=p7 sig_type=std_logic lab=clk1e_nd}
C {lab_wire.sym} -310 80 3 0 {name=p8 sig_type=std_logic lab=clk2e_nd}
C {lab_wire.sym} -250 -10 0 1 {name=p10 sig_type=std_logic lab=OUTp}
C {lab_wire.sym} -250 0 0 1 {name=p12 sig_type=std_logic lab=OUTn}
C {lab_wire.sym} -490 -30 0 0 {name=p13 sig_type=std_logic lab=INPUTp}
C {lab_wire.sym} -490 -20 0 0 {name=p14 sig_type=std_logic lab=INPUTn}
C {lab_wire.sym} -490 10 0 0 {name=p19 sig_type=std_logic lab=DAC}
C {lab_wire.sym} -490 20 0 0 {name=p20 sig_type=std_logic lab=DAC_b}
C {lab_wire.sym} -380 -90 3 1 {name=p22 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -360 -90 3 1 {name=p23 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -370 -90 3 1 {name=p24 sig_type=std_logic lab=Ibias}
C {bsource.sym} -80 130 0 0 {name=B_Quantizer VAR=V FUNC="0.9*(1 + tanh(1000*(v(OUTn)-v(OUTp))))" m=1}
C {sky130_stdcells/dfxbp_1.sym} 70 60 0 0 {name=x2 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__}
C {lab_wire.sym} -80 -40 0 0 {name=p34 sig_type=std_logic lab=clk1_nd}
C {lab_wire.sym} -80 -100 0 0 {name=p35 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 180 -80 2 0 {name=p38 sig_type=std_logic lab=clk1}
C {sky130_stdcells/nand2_1.sym} 0 -80 0 0 {name=x18 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 120 -80 0 0 {name=x19 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {lab_wire.sym} -30 50 0 0 {name=p25 sig_type=std_logic lab=clk1}
C {lab_wire.sym} -80 180 1 1 {name=p26 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 180 50 0 1 {name=p27 sig_type=std_logic lab=DAC}
C {lab_wire.sym} 180 70 0 1 {name=p28 sig_type=std_logic lab=DAC_b}
C {opin.sym} -570 -260 0 0 {name=p15 lab=OUTp}
C {opin.sym} -570 -240 0 0 {name=p17 lab=OUTn}
C {ipin.sym} -500 -300 0 0 {name=p29 lab=INPUTp}
C {ipin.sym} -500 -280 0 0 {name=p30 lab=INPUTn}
