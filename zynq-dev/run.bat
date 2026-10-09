@echo off
set VITIS_BIN=C:\Xilinx\Vitis\2022.2\bin

:: 1. 启动硬件调式服务
tasklist | findstr hw_server.exe >nul
if %errorlevel% neq 0 (
    start "" /b "%VITIS_BIN%\hw_server.bat"
    timeout /t 2 >nul
)


:: 2. 调用下载脚本
"%VITIS_BIN%\xsdb.bat" ./run_jtag.tcl
pause