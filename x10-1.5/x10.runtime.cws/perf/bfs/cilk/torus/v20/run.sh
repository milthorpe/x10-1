#!/usr/bin/ksh

#
# (c) IBM Corportation 2007
#
# $Id: run.sh,v 1.1 2008-02-22 12:03:43 srkodali Exp $
# Interactive script for running BFS Cilk.
#

TOP=../../../..
prog_name=bfs.cilk.torus
. ${TOP}/config/run.header

_CMD_=${TOP}/BFSBlock.pwr5

seq=1
while [[ $seq -le $MAX_RUNS ]]
do
	printf "#\n# Run: %d\n#\n" $seq 2>&1| tee -a $OUT_FILE
	for size in 500 1000 2000 3000
	do
		printf "\n## Size: %d\n" $size 2>&1| tee -a $OUT_FILE
		for nproc in 1 2 4 6 8 10 12 14 16
		do
			printf "\n### nproc: %d\n" $nproc 2>&1| tee -a $OUT_FILE
			CMD="${_CMD_} --nproc $nproc 1 $size 64"
			printf "${CMD}\n" 2>&1| tee -a $OUT_FILE
			${CMD} 2>&1| tee -a $OUT_FILE
		done
	done
	let 'seq = seq + 1'
done
. ${TOP}/config/run.footer