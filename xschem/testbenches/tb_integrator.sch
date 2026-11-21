v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -290 40 -290 70 {lab=Vbias1}
N -280 40 -280 70 {lab=VREFn}
N -270 40 -270 70 {lab=VREFp}
N -260 40 -260 70 {lab=VCM}
N -210 40 -210 70 {lab=clk1_nd}
N -200 40 -200 70 {lab=clk2_nd}
N -190 40 -190 70 {lab=clk1e_nd}
N -180 40 -180 70 {lab=clk2e_nd}
N -140 -30 -110 -30 {lab=OUTp}
N -140 -20 -110 -20 {lab=OUTn}
N -370 -10 -340 -10 {lab=DAC}
N -370 0 -340 0 {lab=DAC_b}
N -250 -120 -250 -90 {lab=VDD}
N -240 -120 -240 -90 {lab=Ibias1}
N -230 -120 -230 -90 {lab=VSS}
N -170 40 -170 60 {lab=clkCh_nd}
N -170 60 -170 70 {lab=clkCh_nd}
N -400 -100 -340 -100 {lab=INPUTp}
N -340 -100 -340 -50 {lab=INPUTp}
N -400 -40 -340 -40 {lab=INPUTn}
N 80 30 80 50 {lab=VCM}
N 180 30 180 50 {lab=VDD}
N 560 190 560 210 {lab=Ibias1}
N 280 30 280 50 {lab=VSS}
N 380 30 380 50 {lab=VREFp}
N 480 30 480 50 {lab=VREFn}
N 590 30 590 50 {lab=Vbias1}
N 110 190 110 210 {lab=clk1_nd}
N 210 190 210 210 {lab=clk1e_nd}
N 110 310 110 330 {lab=clk2_nd}
N 210 310 210 330 {lab=clk2e_nd}
N 210 440 210 460 {lab=clkCh_nd}
C {Analog/SC_Integrator.sym} -240 -20 0 0 {name=x1}
C {lab_wire.sym} -290 60 3 0 {name=p1 sig_type=std_logic lab=Vbias1}
C {lab_wire.sym} -280 60 3 0 {name=p2 sig_type=std_logic lab=VREFn}
C {lab_wire.sym} -270 60 3 0 {name=p3 sig_type=std_logic lab=VREFp}
C {lab_wire.sym} -260 60 3 0 {name=p4 sig_type=std_logic lab=VCM}
C {lab_wire.sym} -210 60 3 0 {name=p5 sig_type=std_logic lab=clk1_nd}
C {lab_wire.sym} -200 60 3 0 {name=p6 sig_type=std_logic lab=clk2_nd}
C {lab_wire.sym} -190 60 3 0 {name=p7 sig_type=std_logic lab=clk1e_nd}
C {lab_wire.sym} -180 60 3 0 {name=p8 sig_type=std_logic lab=clk2e_nd}
C {lab_wire.sym} -360 -10 0 0 {name=p19 sig_type=std_logic lab=DAC}
C {lab_wire.sym} -360 0 0 0 {name=p20 sig_type=std_logic lab=DAC_b}
C {lab_wire.sym} -250 -110 3 1 {name=p22 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -230 -110 3 1 {name=p23 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -240 -110 3 1 {name=p24 sig_type=std_logic lab=Ibias1}
C {opin.sym} -110 -30 0 0 {name=p15 lab=OUTp}
C {opin.sym} -110 -20 0 0 {name=p17 lab=OUTn}
C {ipin.sym} -400 -100 0 0 {name=p29 lab=INPUTp}
C {ipin.sym} -400 -40 0 0 {name=p30 lab=INPUTn}
C {lab_wire.sym} -170 60 3 0 {name=p54 sig_type=std_logic lab=clkCh_nd}
C {vsource.sym} 80 80 0 0 {name=V1 value=0.9 savecurrent=false}
C {lab_wire.sym} 180 30 0 1 {name=p16 sig_type=std_logic lab=VDD}
C {vsource.sym} 180 80 0 0 {name=V2 value=1.8 savecurrent=false}
C {lab_wire.sym} 560 190 0 1 {name=p18 sig_type=std_logic lab=Ibias1}
C {isource.sym} 560 240 0 0 {name=I0 value=30.8u}
C {lab_wire.sym} 280 30 0 1 {name=p21 sig_type=std_logic lab=VSS}
C {vsource.sym} 280 80 0 0 {name=V3 value=0 savecurrent=false
lab=VSS}
C {gnd.sym} 80 110 0 0 {name=l1 lab=0}
C {gnd.sym} 180 110 0 0 {name=l2 lab=0}
C {gnd.sym} 560 270 0 0 {name=l3 lab=0}
C {gnd.sym} 280 110 0 0 {name=l4 lab=0}
C {code_shown.sym} 300 -70 0 0 {name=s1 only_toplevel=false value=".include /foss/designs/tb_integrator_dac.spice"}
C {launcher.sym} 100 -70 0 0 {name=h1
descr=backannotate
tclcommand="xschem annotate_op"}
C {lab_wire.sym} 80 30 0 1 {name=p11 sig_type=std_logic lab=VCM}
C {vsource.sym} 380 80 0 0 {name=Vrefp value=1.5 savecurrent=false}
C {gnd.sym} 380 110 0 0 {name=Vrefp1 lab=0}
C {lab_wire.sym} 380 30 0 1 {name=Vrefp2 sig_type=std_logic lab=VREFp}
C {vsource.sym} 480 80 0 0 {name=Vrefn value=0.3 savecurrent=false}
C {gnd.sym} 480 110 0 0 {name=Vrefp4 lab=0}
C {lab_wire.sym} 480 30 0 1 {name=Vrefp5 sig_type=std_logic lab=VREFn}
C {lab_wire.sym} 590 30 0 1 {name=p9 sig_type=std_logic lab=Vbias1}
C {vsource.sym} 590 80 0 0 {name=V6 value=0.52 savecurrent=false}
C {gnd.sym} 590 110 0 0 {name=l13 lab=0}
C {vsource.sym} 110 240 0 1 {name=Vclk1_nd value="PULSE 0 1.8 2n 0.1n 0.1n 238n 488.28n" savecurrent=false}
C {gnd.sym} 110 270 0 0 {name=l7 lab=0}
C {lab_wire.sym} 110 190 0 1 {name=p58 sig_type=std_logic lab=clk1_nd}
C {vsource.sym} 210 240 0 0 {name=Vclk1e_nd value="PULSE 0 1.8 2n 0.1n 0.1n 237n 488.28n" savecurrent=false}
C {gnd.sym} 210 270 0 1 {name=l8 lab=0}
C {lab_wire.sym} 210 190 0 1 {name=p59 sig_type=std_logic lab=clk1e_nd}
C {vsource.sym} 110 360 0 1 {name=Vclk2_nd value="PULSE 0 1.8 246.14n 0.1n 0.1n 238n 488.28n" savecurrent=false}
C {gnd.sym} 110 390 0 0 {name=l9 lab=0}
C {lab_wire.sym} 110 310 0 1 {name=p84 sig_type=std_logic lab=clk2_nd}
C {vsource.sym} 210 360 0 0 {name=Vclk2e_nd value="PULSE 0 1.8 246.14n 0.1n 0.1n 237n 488.28n" savecurrent=false}
C {gnd.sym} 210 390 0 1 {name=l10 lab=0}
C {lab_wire.sym} 210 310 0 1 {name=p85 sig_type=std_logic lab=clk2e_nd}
C {vsource.sym} 210 490 0 0 {name=Vclk_ch_nd value="PULSE 0 1.8 120n 0.1n 0.1n 488.18n 976.56n" savecurrent=false}
C {gnd.sym} 210 520 0 1 {name=l6 lab=0}
C {lab_wire.sym} 210 440 0 0 {name=p53 sig_type=std_logic lab=clkCh_nd}
C {ipin.sym} -410 200 0 0 {name=p10 lab=DAC}
C {ipin.sym} -410 260 0 0 {name=p12 lab=DAC_b}
