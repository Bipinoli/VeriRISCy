#!/bin/bash
iverilog -o main ../../processor.v test_memory.v

./main
