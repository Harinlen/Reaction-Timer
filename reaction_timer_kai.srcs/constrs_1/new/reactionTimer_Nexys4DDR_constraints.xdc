# 100MHz system clock
set_property -dict {PACKAGE_PIN E3  IOSTANDARD LVCMOS33} [get_ports in_100MHzClock]
create_clock -period 10.00 [get_ports in_100MHzClock]

# Switches
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports in_enable]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports in_reset]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports in_ledDisable]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports in_audioDisable]

# Audio output
set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports out_audioPwm];
set_property -dict { PACKAGE_PIN D12 IOSTANDARD LVCMOS33 } [get_ports out_audioSd];

# Start and test button
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports in_startButton]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports in_testButton]

# LED outputs
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports out_leds[ 0]]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports out_leds[ 1]]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports out_leds[ 2]]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports out_leds[ 3]]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports out_leds[ 4]]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports out_leds[ 5]]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports out_leds[ 6]]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports out_leds[ 7]]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports out_leds[ 8]]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports out_leds[ 9]]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports out_leds[10]]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports out_leds[11]]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports out_leds[12]]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports out_leds[13]]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports out_leds[14]]
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports out_leds[15]]

# 7-segements display
# Dot
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports out_ssdDigitOutput[7]]
# Digit segements
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports out_ssdDigitOutput[6]]
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports out_ssdDigitOutput[5]]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports out_ssdDigitOutput[4]]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports out_ssdDigitOutput[3]]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports out_ssdDigitOutput[2]]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports out_ssdDigitOutput[1]]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports out_ssdDigitOutput[0]]
# Digit selector
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports out_ssdSelector[7]]
set_property -dict {PACKAGE_PIN K2  IOSTANDARD LVCMOS33} [get_ports out_ssdSelector[6]]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports out_ssdSelector[5]]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports out_ssdSelector[4]]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports out_ssdSelector[3]]
set_property -dict {PACKAGE_PIN T9  IOSTANDARD LVCMOS33} [get_ports out_ssdSelector[2]]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports out_ssdSelector[1]]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports out_ssdSelector[0]]