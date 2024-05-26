#!/bin/bash
iverilog -o main ../../processor.v test_simple_addition.v

./main
