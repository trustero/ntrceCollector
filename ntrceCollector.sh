#!/bin/bash

main() {
    while [ $# -gt 0 ]
    do
	case "$1" in
	    --test)
		test_capture
		exit 0
		;;
	    --background)
		echo "Backgrounding..."
		outlog="/tmp/ntrce_dns_output.txt"
		nohup $0 </dev/null &> ${outlog} & disown
		exit 0
		;;
	esac
	shift
    done
    run_capture
    exit 0
}

capture_dns() {
  timelimit="$1"
  timeout ${timelimit} \
      tcpdump -lni any -s0 udp dst port 53 \
      | awk '/A\?/ { seen[$(NF-1)]++ } END { for(i in seen) print seen[i],i }' \
      | sort -rn
}

test_capture() {
    echo "Running a 3 minute capture test..."

    testout="/tmp/ntrce_dns_test.txt"
    rm -f ${testout}
    capture_dns 180 > ${testout}

    echo "Capture complete."
    echo "Checking summary..."

    if [[ $(find ${testout} -type f -size +1024000c 2>/dev/null) ]]; then
	echo "FAILED: output file is too large"
	exit 1
    fi

    linecount=$(wc -l < "${testout}")
    if [[ ${linecount} -gt 100 ]]; then
	echo "FAILED: too much DNS traffic on host: ${linecount} names"
	exit 1
    fi

    echo "PASSED"
    echo "Summary of captured data in ${testout}"
}

run_capture() {
    for i in {1..24}
    do
      timestamp=`date "+%Y%m%d-%H%M%S"`
      output="/tmp/ntrce_dns_access-${timestamp}.txt"
      echo "Hour ${i} will be summarized in ${output}"
      capture_dns 3600 > ${output}
    done
}

main "$@"
