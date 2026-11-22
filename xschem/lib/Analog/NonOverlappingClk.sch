v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -110 -40 -60 -40 {lab=#net1}
N -100 0 -60 0 {lab=clk_b}
N -100 0 -100 20 {lab=clk_b}
N 60 -20 90 -20 {lab=#net2}
N 170 -20 180 -20 {lab=#net3}
N 260 -20 270 -20 {lab=#net4}
N 450 -20 510 -20 {lab=clk}
N -100 70 -100 90 {lab=clk}
N -100 90 -60 90 {lab=clk}
N 60 110 90 110 {lab=#net5}
N 170 110 180 110 {lab=#net6}
N 260 110 270 110 {lab=#net7}
N -110 130 -60 130 {lab=clk_nd}
N -250 130 -110 130 {lab=clk_nd}
N -250 -20 -250 130 {lab=clk_nd}
N -250 -20 -230 -20 {lab=clk_nd}
N -250 -20 -230 -20 {lab=clk_nd}
N -280 -20 -250 -20 {lab=clk_nd}
N -250 -60 -230 -60 {lab=Seed}
N -250 -100 -250 -60 {lab=Seed}
N 350 -20 360 -20 {lab=#net8}
N 440 -20 450 -20 {lab=clk}
N 260 110 270 110 {lab=#net7}
N 350 110 360 110 {lab=#net9}
N 440 110 450 110 {lab=clk_b}
N 450 110 510 110 {lab=clk_b}
N -100 20 480 90 {lab=clk_b}
N 480 90 480 110 {lab=clk_b}
N -100 70 480 0 {lab=clk}
N 480 -20 480 -0 {lab=clk}
C {sky130_stdcells/nor2_1.sym} 0 -20 0 0 {name=x1 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nand2_1.sym} -170 -40 0 0 {name=x37 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nor2_1.sym} 0 110 0 0 {name=x33 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_4.sym} 400 -20 0 0 {name=x38 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 130 110 0 0 {name=x40 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {iopin.sym} -250 -100 1 1 {name=p1 lab=Seed}
C {iopin.sym} -190 -130 2 1 {name=p2 lab=VSS}
C {iopin.sym} -280 -20 0 1 {name=p4 lab=clk_nd}
C {iopin.sym} 510 -20 2 1 {name=p3 lab=clk}
C {iopin.sym} 510 110 2 1 {name=p5 lab=clk_b}
C {iopin.sym} -190 -180 2 1 {name=p6 lab=VDD}
C {sky130_stdcells/inv_4.sym} 400 110 0 0 {name=x2 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 130 -20 0 0 {name=x3 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 220 -20 0 0 {name=x4 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 310 -20 0 0 {name=x5 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 310 110 0 0 {name=x6 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 220 110 0 0 {name=x7 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
