#!/bin/bash

module purge
module load matlab/R2013a

matlab -nodisplay -nosplash <  tideComparison_O1.m
