@echo off
for /l %%i in (1,1,10000) do (
for /f "usebackq" %%a in (`ruby %~n0.rb %%i`) do echo %%i, %%a
)
