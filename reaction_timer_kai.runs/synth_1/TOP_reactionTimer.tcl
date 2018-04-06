# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/ass1/reaction_timer_kai.cache/wt [current_project]
set_property parent.project_path C:/ass1/reaction_timer_kai.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/ass1/reaction_timer_kai.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/globalConstants.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/PwmModem.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/actionRetarder.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/asc16Font.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/audioHintOutput.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/clockDivider.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/debouncer.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/decimalToBcd.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/divisionByTen.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/edgeDetector.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/globalTime.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/latchDebouncer.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/ledAnimation.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/microphoneNoiseGenerator.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/randLcg.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/randMt19937.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/reactTimerCpu.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/reactTimerIdleCore.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/reactTimerPrepareCore.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/reactTimerResultCore.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/reactTimerTestCore.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/ssdAnimation.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/ssdDriver.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/vgaDriver.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/vram.v
  C:/ass1/reaction_timer_kai.srcs/sources_1/new/TOP_reactionTimer.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/ass1/reaction_timer_kai.srcs/constrs_1/new/reactionTimer_Nexys4DDR_constraints.xdc
set_property used_in_implementation false [get_files C:/ass1/reaction_timer_kai.srcs/constrs_1/new/reactionTimer_Nexys4DDR_constraints.xdc]


synth_design -top TOP_reactionTimer -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef TOP_reactionTimer.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file TOP_reactionTimer_utilization_synth.rpt -pb TOP_reactionTimer_utilization_synth.pb"
