Interstice Agent
================

This tool uses common Linux utilities to capture DNS queries from a
running sytem and create a count of the number of queries per hostname.

It runs in one hour blocks of time, generating summary data about the
DNS queries made.

## Quick Install

### Step 1: Sanity Check

First, let's do a "manual" run for two minutes. This will verify that
all the commands are in the path and that there are not too many unique
DNS queries on the host:

```
sudo timeout 120 tcpdump -lni any -s0 udp dst port 53 \
| awk '/A\?/ { seen[$(NF-1)]++ } END { for(i in seen) print seen[i],i }' \
| sort -rn > /tmp/ntrce_dns_access-`date "+%Y%m%d-%H%M%S"`.txt
```

Check `/tmp` for a time-stamped output file.  If this file is over 1MB
in size, then there are a great many unique DNS queries happening.
This risks the agent processes using excessive memory because they run
in blocks of one hour.

The most common issue encountered is that `tcpdump` is not installed on Red Hat
derived distributions. See below for notes on installing `tcpdump`.

### Step 2: Install the Agent

Copy the file `ntrceAgent.sh` from this repository to the `/tmp` directory
of the target machine, or paste the source code over manually.

Make sure that the shell script is executable:
```
chmod +x /tmp/ntrceAgent.sh
```


### Step 3: Run the Agent

After installing the agent on your system, you just need to run it with
`root` privileges.

Assuming it's installed in `/tmp/ntrceAgent.sh`, then to run it in the background
you type:
```
nohup sudo /tmp/ntrceAgent.sh > /dev/null 2>&1 &
```


## Tested Distributions

### Amazon EC2 Images

Image | Commands needed
------------ | ---------------
Amazon Linux 2 AMI | works
Amazon Linux AMI 2018.03.0 | `sudo yum install tcpdump`
Red Hat Enterprise Linux 8 | `sudo yum install tcpdump`
SUSE Linux Enterprise Server 15 SP2 | works
Ubuntu Server 18.04 LTS | works

