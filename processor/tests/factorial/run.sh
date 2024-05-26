#!/bin/bash
iverilog -o main ../../processor.v test_factorial.v

./main
