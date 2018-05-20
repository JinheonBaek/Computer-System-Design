connect -url tcp:127.0.0.1:3121
source C:/cose321/Assignment-7/class_experiments.sdk/soc_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248A39B69"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248A39B69" && level==0} -index 1
fpga -file C:/cose321/Assignment-7/class_experiments.sdk/soc_wrapper_hw_platform_0/soc_wrapper.bit
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248A39B69"} -index 0
loadhw C:/cose321/Assignment-7/class_experiments.sdk/soc_wrapper_hw_platform_0/system.hdf
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248A39B69"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248A39B69"} -index 0
dow C:/cose321/Assignment-7/class_experiments.sdk/csd_lab/Debug/csd_lab.elf
bpadd -addr &main
