@echo off
for /l %%a in (3,2,%2) do (ruby uzumaki%1.rb < testdata\%%a.in | diff -asq testdata\%%a.out -)
