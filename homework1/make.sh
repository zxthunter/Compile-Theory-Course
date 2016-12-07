#! /bin/bash
# makefile
flex ./scanner.l
gcc ./lex.yy.c -o ./scanner
