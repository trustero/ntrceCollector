Interstice Collector
====================

This tool uses common Linux utilities to capture DNS queries from a
running sytem and create a count of the number of queries per hostname.

It runs in one hour blocks of time, generating summary data about the
DNS queries made.

## Quick Install

### Step 1: Install the Collector

Copy the file `ntrceCollector.sh` from this repository to the `/tmp` directory
of the target machine, or paste the source code over manually.

Make sure that the shell script is executable:
```
chmod +x /tmp/ntrceCollector.sh
```


### Step 2: Sanity Check

First, let's do a short run for three minutes. This will verify that
all the commands are in the path and that there are not too many unique
DNS queries on the host:

```
sudo /tmp/ntrceCollector.sh --test
```

Check `/tmp` for a time-stamped output file.  If this file is over 1MB
in size, then there are a great many unique DNS queries happening.
This risks the collector processes using excessive memory because they run
in blocks of one hour.

The most common issue encountered is that `tcpdump` is not installed on Red Hat
derived distributions. See below for notes on installing `tcpdump`.


### Step 3: Run the Collector

After installing the collector on your system, you just need to run it with
`root` privileges.

Assuming it's installed in `/tmp/ntrceCollector.sh`, then to run it in the background
you type:
```
sudo /tmp/ntrceCollector.sh --background
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

