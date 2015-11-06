setlocal

ruby lifegame.rb testdata\%1.in.txt | diff -qs --strip-trailing-cr - testdata\%1.out.txt
