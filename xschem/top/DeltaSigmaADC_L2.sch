v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 300 -150 300 -130 {lab=VCM}
N 400 -150 400 -130 {lab=VDD}
N 780 10 780 30 {lab=Ibias1}
N 500 -150 500 -130 {lab=VSS}
N 600 -150 600 -130 {lab=VREFp}
N 700 -150 700 -130 {lab=VREFn}
N 810 -150 810 -130 {lab=Vbias1}
N 300 20 300 40 {lab=clk1_nd}
N 400 20 400 40 {lab=clk1e_nd}
N 300 140 300 160 {lab=clk2_nd}
N 400 140 400 160 {lab=clk2e_nd}
N -770 -10 -770 20 {lab=Vbias1}
N -760 -10 -760 20 {lab=VREFn}
N -750 -10 -750 20 {lab=VREFp}
N -740 -10 -740 20 {lab=VCM}
N -700 -10 -700 20 {lab=clk1_nd}
N -690 -10 -690 20 {lab=clk2_nd}
N -680 -10 -680 20 {lab=clk1e_nd}
N -670 -10 -670 20 {lab=clk2e_nd}
N -620 -80 -590 -80 {lab=OUTp_1}
N -620 -70 -590 -70 {lab=OUTn_1}
N -1000 -240 -1000 -210 {lab=VSS}
N -1000 -30 -1000 0 {lab=VSS}
N -850 -60 -820 -60 {lab=DAC}
N -850 -50 -820 -50 {lab=DAC_b}
N -730 -170 -730 -140 {lab=VDD}
N -720 -170 -720 -140 {lab=Ibias1}
N -710 -170 -710 -140 {lab=VSS}
N -390 70 -390 100 {lab=#net1}
N -390 70 -330 70 {lab=#net1}
N -350 50 -330 50 {lab=clk1}
N -150 50 -120 50 {lab=DAC}
N -150 70 -120 70 {lab=DAC_b}
N -410 -100 -370 -100 {lab=VDD}
N -390 -60 -370 -60 {lab=clk1_nd}
N -390 -60 -390 -40 {lab=clk1_nd}
N -150 -80 -120 -80 {lab=clk1}
N -250 -80 -230 -80 {lab=#net2}
N -390 160 -390 190 {lab=VSS}
N -780 330 -780 360 {lab=Vbias2}
N -770 330 -770 360 {lab=VREFn}
N -760 330 -760 360 {lab=VREFp}
N -750 330 -750 360 {lab=VCM}
N -700 330 -700 360 {lab=clk1_nd}
N -690 330 -690 360 {lab=clk2_nd}
N -680 330 -680 360 {lab=clk1e_nd}
N -670 330 -670 360 {lab=clk2e_nd}
N -630 260 -600 260 {lab=OUTp}
N -630 270 -600 270 {lab=OUTn}
N -860 240 -830 240 {lab=OUTn_1}
N -860 250 -830 250 {lab=OUTp_1}
N -860 280 -830 280 {lab=DAC}
N -860 290 -830 290 {lab=DAC_b}
N -740 170 -740 200 {lab=VDD}
N -730 170 -730 200 {lab=Ibias2}
N -720 170 -720 200 {lab=VSS}
N 860 10 860 30 {lab=Ibias2}
N 400 270 400 290 {lab=clkCh_nd}
N -660 -10 -660 10 {lab=clkCh_nd}
N -660 10 -660 20 {lab=clkCh_nd}
N -880 -150 -820 -150 {lab=#net3}
N -820 -150 -820 -100 {lab=#net3}
N -880 -90 -820 -90 {lab=#net4}
N -970 -90 -940 -90 {lab=#net4}
N -990 -150 -940 -150 {lab=#net3}
N -1000 -150 -990 -150 {lab=#net3}
N -1000 -90 -970 -90 {lab=#net4}
N 900 -150 900 -130 {lab=Vbias2}
N -660 0 -650 0 {lab=clkCh_nd}
N -650 -10 -650 0 {lab=clkCh_nd}
N -940 -150 -880 -150 {lab=#net3}
N -940 -90 -880 -90 {lab=#net4}
C {Analog/SC_Integrator.sym} -720 -80 0 0 {name=x1}
C {vsource.sym} 300 -100 0 0 {name=V1 value=0.9 savecurrent=false}
C {lab_wire.sym} 400 -150 0 1 {name=p16 sig_type=std_logic lab=VDD}
C {vsource.sym} 400 -100 0 0 {name=V2 value=1.8 savecurrent=false}
C {lab_wire.sym} 780 10 0 1 {name=p18 sig_type=std_logic lab=Ibias1}
C {isource.sym} 780 60 0 0 {name=I0 value=30.8u}
C {lab_wire.sym} 500 -150 0 1 {name=p21 sig_type=std_logic lab=VSS}
C {vsource.sym} 500 -100 0 0 {name=V3 value=0 savecurrent=false
lab=VSS}
C {gnd.sym} 300 -70 0 0 {name=l1 lab=0}
C {gnd.sym} 400 -70 0 0 {name=l2 lab=0}
C {gnd.sym} 780 90 0 0 {name=l3 lab=0}
C {gnd.sym} 500 -70 0 0 {name=l4 lab=0}
C {code_shown.sym} 520 -250 0 0 {name=s1 only_toplevel=false value=".include /foss/designs/tb_DeltaSigmaADC_trnoise.spice"}
C {launcher.sym} 320 -250 0 0 {name=h1
descr=backannotate
tclcommand="xschem annotate_op"}
C {lab_wire.sym} 300 -150 0 1 {name=p11 sig_type=std_logic lab=VCM}
C {vsource.sym} 600 -100 0 0 {name=Vrefp value=1.5 savecurrent=false}
C {gnd.sym} 600 -70 0 0 {name=Vrefp1 lab=0}
C {lab_wire.sym} 600 -150 0 1 {name=Vrefp2 sig_type=std_logic lab=VREFp}
C {vsource.sym} 700 -100 0 0 {name=Vrefn value=0.3 savecurrent=false}
C {gnd.sym} 700 -70 0 0 {name=Vrefp4 lab=0}
C {lab_wire.sym} 700 -150 0 1 {name=Vrefp5 sig_type=std_logic lab=VREFn}
C {lab_wire.sym} 810 -150 0 1 {name=p9 sig_type=std_logic lab=Vbias1}
C {vsource.sym} 810 -100 0 0 {name=V6 value=0.62 savecurrent=false}
C {gnd.sym} 810 -70 0 0 {name=l13 lab=0}
C {vsource.sym} 300 70 0 1 {name=Vclk1_nd value="PULSE 0 1.8 2n 0.1n 0.1n 238n 488.28n" savecurrent=false}
C {gnd.sym} 300 100 0 0 {name=l7 lab=0}
C {lab_wire.sym} 300 20 0 1 {name=p58 sig_type=std_logic lab=clk1_nd}
C {vsource.sym} 400 70 0 0 {name=Vclk1e_nd value="PULSE 0 1.8 2n 0.1n 0.1n 237n 488.28n" savecurrent=false}
C {gnd.sym} 400 100 0 1 {name=l8 lab=0}
C {lab_wire.sym} 400 20 0 1 {name=p59 sig_type=std_logic lab=clk1e_nd}
C {vsource.sym} 300 190 0 1 {name=Vclk2_nd value="PULSE 0 1.8 246.14n 0.1n 0.1n 238n 488.28n" savecurrent=false}
C {gnd.sym} 300 220 0 0 {name=l9 lab=0}
C {lab_wire.sym} 300 140 0 1 {name=p84 sig_type=std_logic lab=clk2_nd}
C {vsource.sym} 400 190 0 0 {name=Vclk2e_nd value="PULSE 0 1.8 246.14n 0.1n 0.1n 237n 488.28n" savecurrent=false}
C {gnd.sym} 400 220 0 1 {name=l10 lab=0}
C {lab_wire.sym} 400 140 0 1 {name=p85 sig_type=std_logic lab=clk2e_nd}
C {lab_wire.sym} -770 10 3 0 {name=p1 sig_type=std_logic lab=Vbias1}
C {lab_wire.sym} -760 10 3 0 {name=p2 sig_type=std_logic lab=VREFn}
C {lab_wire.sym} -750 10 3 0 {name=p3 sig_type=std_logic lab=VREFp}
C {lab_wire.sym} -740 10 3 0 {name=p4 sig_type=std_logic lab=VCM}
C {lab_wire.sym} -700 10 3 0 {name=p5 sig_type=std_logic lab=clk1_nd}
C {lab_wire.sym} -690 10 3 0 {name=p6 sig_type=std_logic lab=clk2_nd}
C {lab_wire.sym} -680 10 3 0 {name=p7 sig_type=std_logic lab=clk1e_nd}
C {lab_wire.sym} -670 10 3 0 {name=p8 sig_type=std_logic lab=clk2e_nd}
C {lab_wire.sym} -600 -80 0 1 {name=p10 sig_type=std_logic lab=OUTp_1}
C {lab_wire.sym} -600 -70 0 1 {name=p12 sig_type=std_logic lab=OUTn_1}
C {lab_wire.sym} -1000 -230 1 0 {name=p13 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -1000 -10 3 0 {name=p14 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -840 -60 0 0 {name=p19 sig_type=std_logic lab=DAC}
C {lab_wire.sym} -840 -50 0 0 {name=p20 sig_type=std_logic lab=DAC_b}
C {lab_wire.sym} -730 -160 3 1 {name=p22 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -710 -160 3 1 {name=p23 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -720 -160 3 1 {name=p24 sig_type=std_logic lab=Ibias1}
C {bsource.sym} -390 130 0 0 {name=B_Quantizer VAR=V FUNC="0.9*(1 + tanh(1000*(v(OUTn)-v(OUTp))))" m=1}
C {sky130_stdcells/dfxbp_1.sym} -240 60 0 0 {name=x2 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__}
C {lab_wire.sym} -390 -40 0 0 {name=p34 sig_type=std_logic lab=clk1_nd}
C {lab_wire.sym} -390 -100 0 0 {name=p35 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -130 -80 2 0 {name=p38 sig_type=std_logic lab=clk1}
C {sky130_stdcells/nand2_1.sym} -310 -80 0 0 {name=x18 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} -190 -80 0 0 {name=x19 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {lab_wire.sym} -340 50 0 0 {name=p25 sig_type=std_logic lab=clk1}
C {lab_wire.sym} -390 180 1 1 {name=p26 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -130 50 0 1 {name=p27 sig_type=std_logic lab=DAC}
C {lab_wire.sym} -130 70 0 1 {name=p28 sig_type=std_logic lab=DAC_b}
C {opin.sym} -880 -260 0 0 {name=p15 lab=OUTp}
C {opin.sym} -880 -240 0 0 {name=p17 lab=OUTn}
C {ipin.sym} -810 -300 0 0 {name=p29 lab=INPUTp}
C {ipin.sym} -810 -280 0 0 {name=p30 lab=INPUTn}
C {Analog/SC_Integrator_2.sym} -730 270 0 0 {name=x3}
C {lab_wire.sym} -780 350 3 0 {name=p31 sig_type=std_logic lab=Vbias2}
C {lab_wire.sym} -770 350 3 0 {name=p32 sig_type=std_logic lab=VREFn}
C {lab_wire.sym} -760 350 3 0 {name=p33 sig_type=std_logic lab=VREFp}
C {lab_wire.sym} -750 350 3 0 {name=p36 sig_type=std_logic lab=VCM}
C {lab_wire.sym} -700 350 3 0 {name=p37 sig_type=std_logic lab=clk1_nd}
C {lab_wire.sym} -690 350 3 0 {name=p39 sig_type=std_logic lab=clk2_nd}
C {lab_wire.sym} -680 350 3 0 {name=p40 sig_type=std_logic lab=clk1e_nd}
C {lab_wire.sym} -670 350 3 0 {name=p41 sig_type=std_logic lab=clk2e_nd}
C {lab_wire.sym} -610 260 0 1 {name=p42 sig_type=std_logic lab=OUTp}
C {lab_wire.sym} -610 270 0 1 {name=p43 sig_type=std_logic lab=OUTn}
C {lab_wire.sym} -850 280 0 0 {name=p46 sig_type=std_logic lab=DAC}
C {lab_wire.sym} -850 290 0 0 {name=p47 sig_type=std_logic lab=DAC_b}
C {lab_wire.sym} -740 180 3 1 {name=p48 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -720 180 3 1 {name=p49 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -730 180 3 1 {name=p50 sig_type=std_logic lab=Ibias2}
C {lab_wire.sym} -850 250 0 0 {name=p44 sig_type=std_logic lab=OUTp_1}
C {lab_wire.sym} -850 240 0 0 {name=p45 sig_type=std_logic lab=OUTn_1}
C {lab_wire.sym} 860 10 0 1 {name=p51 sig_type=std_logic lab=Ibias2}
C {isource.sym} 860 60 0 0 {name=I1 value=15.4u}
C {gnd.sym} 860 90 0 0 {name=l5 lab=0}
C {vsource.sym} 400 320 0 0 {name=Vclk_ch_nd value="PULSE 0 1.8 120n 0.1n 0.1n 488.18n 976.56n" savecurrent=false}
C {gnd.sym} 400 350 0 1 {name=l6 lab=0}
C {lab_wire.sym} 400 270 0 0 {name=p53 sig_type=std_logic lab=clkCh_nd}
C {lab_wire.sym} -660 10 3 0 {name=p54 sig_type=std_logic lab=clkCh_nd}
C {vsource.sym} -910 -200 1 0 {name=V4 value="dc 0 trnoise(63.7u 488.28n 0 0)" savecurrent=false}
C {vsource.sym} -1000 -180 2 0 {name=V7 value="dc 0 SIN(0.9  0.3 343.75)" savecurrent=false}
C {vsource.sym} -1000 -60 0 0 {name=V8 value="dc 0 SIN(0.9  -0.3 343.75)" savecurrent=false}
C {lab_wire.sym} 900 -150 0 1 {name=p52 sig_type=std_logic lab=Vbias2}
C {vsource.sym} 900 -100 0 0 {name=V9 value=0.69 savecurrent=false}
C {gnd.sym} 900 -70 0 0 {name=l11 lab=0}
C {noconn.sym} -940 -200 0 0 {name=l12}
C {noconn.sym} -880 -200 0 0 {name=l14}
