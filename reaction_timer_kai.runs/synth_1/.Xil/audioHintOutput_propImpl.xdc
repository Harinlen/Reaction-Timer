set_property SRC_FILE_INFO {cfile:C:/Reaction_Timer/reaction_timer_kai.srcs/constrs_1/new/reactionTimer_Nexys4DDR_constraints.xdc rfile:../../../reaction_timer_kai.srcs/constrs_1/new/reactionTimer_Nexys4DDR_constraints.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN E3  IOSTANDARD LVCMOS33} [get_ports in_100MHzClock]
set_property src_info {type:XDC file:1 line:3 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 10.00 [get_ports in_100MHzClock]
set_property src_info {type:XDC file:1 line:6 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports in_enable]
set_property src_info {type:XDC file:1 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports in_reset]
set_property src_info {type:XDC file:1 line:10 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports out_audioPwm];
set_property src_info {type:XDC file:1 line:11 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN D12 IOSTANDARD LVCMOS33 } [get_ports out_audioSd];
