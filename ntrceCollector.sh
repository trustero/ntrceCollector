#!/bin/bash

main() {
    while [ $# -gt 0 ]
    do
	case "$1" in
	    --test)
		test_run
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

test_prereq() {
    req="$1"
    echo -n "  Checking for ${req}..."
    if ! command -v "${req}" &> /dev/null ; then
	echo "not found."
	return 1
    fi
    echo "found."
    return 0
}

test_sanity_check() {
    testout="$1"
    echo "Checking summary ${testout}..."

    echo -n "  File size of output: "
    if [[ $(find ${testout} -type f -size +1024000c 2>/dev/null) ]]; then
	echo "FAILED"
	exit 1
    else
	echo "PASSED"
    fi

    echo -n "  Number of unique names: "
    linecount=$(wc -l < "${testout}")
    if [[ ${linecount} -gt 100 ]]; then
	echo "FAILED"
	exit 1
    else
	echo "PASSED"
    fi
}

test_run() {
    echo "Verifying pre-requisites..."
    good=0
    for req in tcpdump awk sort
    do
	test_prereq "${req}"
	good=`expr ${good} + $?`
    done
    if [[ ${good} -ne 0 ]]; then
	echo "==> Please install missing tools."
	exit 1
    fi

    echo "Running a 3 minute capture test..."
    testout="/tmp/ntrce_dns_test.txt"
    rm -f "${testout}"
    capture_dns 180 > "${testout}"
    echo "Capture complete."

    test_sanity_check "${testout}"
}

run_capture() {
    for i in {1..24}
    do
      timestamp=`date "+%Y%m%d-%H%M%S"`
      output="/tmp/ntrce_dns_access-${timestamp}.txt"
      echo "Hour ${i} will be summarized in ${output}"
      capture_dns 3600 > "${output}"
    done
}

main "$@"
