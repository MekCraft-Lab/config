# 1. 链接本地硬件服务器
connect -url tcp:127.0.0.1:3121

# 2. 下载PL比特流
targets -set -filter {name =~ "xc7z*"}
set bit_file [file normalize "bsp/ps_wrapper.bit"]
if {[file exists $bit_file]} {
    puts "\[INFO\] Programming Bitstream File \[$bit_file\]"
    fpga $bit_file
}

# 3. 复位ARM CPU0
targets -set -filter {name =~ "ARM* #0"}
rst -processor

# 4. 初始化时钟
puts "\[INFO\] Initializing PS7"
source "bsp/ps7_init.tcl"
ps7_init
ps7_post_config

# 5. 下载.elf并运行
set found_files [list]
set matched [glob -nocomplain -directory "./" -types d "*build*"]

if {[llength matched] == 0} {
    puts "\[ERR\]: No build directionaries"
}

set matched [glob -nocomplain -directory [lindex $matched 0] -types f "*.elf"]

foreach f $matched {
    lappend found_files [file normalize $f]
}

if {[llength $found_files] == 0} {
    puts "\[ERR\]: No .elf file"
    exit 1
} elseif {[llength $found_files] != 1} {
    puts "\[ERR\]: Too many .elf files"
    exit 1
} else {
    dow [lindex $found_files 0]
}

puts "\[SUCCESS\] Board initialized and ELF loaded!"
# 如果你只是想直接让它在板子上跑，取消下面这行的注释即可：
# con
exit