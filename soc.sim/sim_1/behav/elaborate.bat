@echo off
set xv_path=F:\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto 21514bce44ac4cb1a24fd2b053bba385 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L blk_mem_gen_v8_3_1 -L unisims_ver -L unimacro_ver -L secureip --snapshot top_design_behav xil_defaultlib.top_design xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
