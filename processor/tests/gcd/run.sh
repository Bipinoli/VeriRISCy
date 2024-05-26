#!/bin/bash
iverilog -o main ../../processor.v test_gcd.v

./main
