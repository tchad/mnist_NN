cd [get_property DIRECTORY [current_project]]

puts stdout "################### RELU FIX2"
set_property top top_relu_fix2 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix2.txt -name top_relu_fix2
close_design

puts stdout "################### RELU FIX3"
set_property top top_relu_fix3 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix3.txt -name top_relu_fix3
close_design

puts stdout "################### RELU FIX4"
set_property top top_relu_fix4 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix4.txt -name top_relu_fix4
close_design

puts stdout "################### RELU FIX5"
set_property top top_relu_fix5 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix5.txt -name top_relu_fix5
close_design

puts stdout "################### RELU FIX6"
set_property top top_relu_fix6 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix6.txt -name top_relu_fix6
close_design

puts stdout "################### RELU FIX7"
set_property top top_relu_fix7 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix7.txt -name top_relu_fix7
close_design

puts stdout "################### RELU FIX8"
set_property top top_relu_fix8 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix8.txt -name top_relu_fix8
close_design

puts stdout "################### RELU FIX9"
set_property top top_relu_fix9 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix9.txt -name top_relu_fix9
close_design

puts stdout "################### RELU FIX10"
set_property top top_relu_fix10 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix10.txt -name top_relu_fix10
close_design

puts stdout "################### RELU FIX11"
set_property top top_relu_fix11 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix11.txt -name top_relu_fix11
close_design

puts stdout "################### RELU FIX12"
set_property top top_relu_fix12 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix12.txt -name top_relu_fix12
close_design

puts stdout "################### RELU FIX13"
set_property top top_relu_fix13 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix13.txt -name top_relu_fix13
close_design

puts stdout "################### RELU FIX14"
set_property top top_relu_fix14 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix14.txt -name top_relu_fix14
close_design

puts stdout "################### RELU FIX15"
set_property top top_relu_fix15 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix15.txt -name top_relu_fix15
close_design

puts stdout "################### RELU FIX16"
set_property top top_relu_fix16 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fix16.txt -name top_relu_fix16
close_design

puts stdout "################### RELU FP16"
set_property top top_relu_fp16 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_fp16.txt -name top_relu_fp16
close_design

puts stdout "################### RELU ULAW"
set_property top top_relu_ulaw [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_relu_ulaw.txt -name top_relu_ulaw
close_design

#SIGMOID

puts stdout "################### SIGMOID FIX2"
set_property top top_sigmoid_fix2 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix2.txt -name top_sigmoid_fix2
close_design

puts stdout "################### SIGMOID FIX3"
set_property top top_sigmoid_fix3 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix3.txt -name top_sigmoid_fix3
close_design

puts stdout "################### SIGMOID FIX4"
set_property top top_sigmoid_fix4 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix4.txt -name top_sigmoid_fix4
close_design

puts stdout "################### SIGMOID FIX5"
set_property top top_sigmoid_fix5 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix5.txt -name top_sigmoid_fix5
close_design

puts stdout "################### SIGMOID FIX6"
set_property top top_sigmoid_fix6 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix6.txt -name top_sigmoid_fix6
close_design

puts stdout "################### SIGMOID FIX7"
set_property top top_sigmoid_fix7 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix7.txt -name top_sigmoid_fix7
close_design

puts stdout "################### SIGMOID FIX8"
set_property top top_sigmoid_fix8 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix8.txt -name top_sigmoid_fix8
close_design

puts stdout "################### SIGMOID FIX9"
set_property top top_sigmoid_fix9 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix9.txt -name top_sigmoid_fix9
close_design

puts stdout "################### SIGMOID FIX10"
set_property top top_sigmoid_fix10 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix10.txt -name top_sigmoid_fix10
close_design

puts stdout "################### SIGMOID FIX11"
set_property top top_sigmoid_fix11 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix11.txt -name top_sigmoid_fix11
close_design

puts stdout "################### SIGMOID FIX12"
set_property top top_sigmoid_fix12 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix12.txt -name top_sigmoid_fix12
close_design

puts stdout "################### SIGMOID FIX13"
set_property top top_sigmoid_fix13 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix13.txt -name top_sigmoid_fix13
close_design

puts stdout "################### SIGMOID FIX14"
set_property top top_sigmoid_fix14 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix14.txt -name top_sigmoid_fix14
close_design

puts stdout "################### SIGMOID FIX15"
set_property top top_sigmoid_fix15 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix15.txt -name top_sigmoid_fix15
close_design

puts stdout "################### SIGMOID FIX16"
set_property top top_sigmoid_fix16 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fix16.txt -name top_sigmoid_fix16
close_design

puts stdout "################### SIGMOID FP16"
set_property top top_sigmoid_fp16 [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_fp16.txt -name top_sigmoid_fp16
close_design

puts stdout "################### SIGMOID ULAW"
set_property top top_sigmoid_ulaw [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1 
open_run impl_1
report_utilization -file ../prj4/synthesis/top_sigmoid_ulaw.txt -name top_sigmoid_ulaw
close_design


