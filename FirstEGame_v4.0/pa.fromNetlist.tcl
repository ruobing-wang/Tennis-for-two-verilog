
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name FirstEGame_v4.0 -dir "D:/Files built by Me/ISE/FirstEGame_v4.0/planAhead_run_1" -part xc6slx16csg324-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/Files built by Me/ISE/FirstEGame_v4.0/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Files built by Me/ISE/FirstEGame_v4.0} {ipcore_dir} }
add_files [list {ipcore_dir/pic_ball.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/pic_bar_a.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/pic_bar_b.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "Nexys3_Master.ucf" [current_fileset -constrset]
add_files [list {Nexys3_Master.ucf}] -fileset [get_property constrset [current_run]]
link_design
