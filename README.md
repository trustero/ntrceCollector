Interstice Collector
====================

This tool uses common Linux utilities to capture DNS queries from a
running sytem and create a count of the number of queries per hostname.

It runs in one hour blocks of time, generating summary data about the
DNS queries made.

## Quick Install

### Step 1: Download the Collector

The easiest way to get our collector is to clone the github repository:
```
git clone https://github.com/intersticelabs/ntrceCollector.git
cd ntrceCollector
```


If you don't have `git` installed, you can download the collector script directly:
```
curl -o ntrceCollector.sh https://raw.githubusercontent.com/intersticelabs/ntrceCollector/master/ntrceCollector.sh
chmod +x ntrceCollector.sh
```

### Step 2: Sanity Check

First, let's do a test to make sure everything is working.
The test will verify that the commands we need are installed,
capture three minutes of data from the network,
and then verify that the amount of data we found isn't HUGE.

```
sudo ./ntrceCollector.sh --test
```

The most common issue encountered is that `tcpdump` is not installed on Red Hat
derived distributions. See below for notes on installing `tcpdump`.


### Step 3: Run the Collector

After installing the collector on your system, you just need to run it with
`root` privileges.

```
sudo ./ntrceCollector.sh --background
```

This will automatically background the process and run a 24 hour capture.
Summary data is written to `/tmp` in one hour blocks.

## Tested Distributions

### Amazon EC2 Images

Image | Commands needed
------------ | ---------------
Amazon Linux 2 AMI | works
Amazon Linux AMI 2018.03.0 | `sudo yum install tcpdump`
Red Hat Enterprise Linux 8 | `sudo yum install tcpdump`
SUSE Linux Enterprise Server 15 SP2 | works
Ubuntu Server 18.04 LTS | works

