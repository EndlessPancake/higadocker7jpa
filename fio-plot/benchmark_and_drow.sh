#!/bin/bash
prefix="randrw_4k"

mkdir -p result &&
fio group_report.fio --output result/${prefix}.log && \
fio-plot -i pd-standard/ pd-balance/ pd-premium/  -T "Comparing IOPs performance of GKE StorageClass" -g -t iops -r randread --xlabel-parent 0 
