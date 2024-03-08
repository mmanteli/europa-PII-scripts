# europa-PII-scripts
Scripts used to redact PII on LUMI.

## Requirements

- https://github.com/mmanteli/multilingual-PII-tool.git@main
- python-stdnum==1.19
- regex==2023.12.25

## Some instructions

- {lang} = languages we use and languages present in multilingual-PII-tool. There are a couple of mismatches, e.g. "is" vs. "ic" for Icelandic, see ```redact.py```
- {source} = directories under languages, "culturax", "hplt", "redpajama-v2"

### Redaction

**NOTE**: ```redact.py``` has hardcoded json-field, check that it maches your data.

- from ```europa/source-data/{lang}/{source}/``` to ```europa/pii-masked/{lang}/{source}/```
- chooses all files that contain the word "part" or "shard" (others are discarded, see ```launch.sh```/```launch2.sh```)
- run ```launch.sh``` on LUMI

```
./launch {lang} {source}     # this launches multiple batch scripts (run.sh)
```

- throws an error if there are over 200 files (do not fit into LUMI small partition)
- in this case, use ```launch2.sh```:

```
./launch2.sh {lang} {source} {filenumbers}
```
e.g. to run ```it_part_00000.jsonl``` - ```it_part_00099.jsonl``` from CulturaX:

```
./launch2.sh it culturax 000      # selects files europa/source-data/it/culturax/it*_000*, similarly launches them as multiple batch scripts (run.sh)
```

### Stats & Approximate FN

- bc there is no real test set, evaluation done by approximation
- get stats on the number of tokens replaced and in how mony documents these redactions were done, run ```stats.sh```:

```
stats.sh {lang} {source}   # runs stats.py
```
- selects 8 random files to save time (tested to be consistent)
- numbers explained in printout, last line tab-separated list => to easily copy to excel

From these numbers I tried to find languages that were outliers and updated the rules if the outlier was caused by inadequate rules.
There are data-quality based outliers too, e.g. Lithuanian contains huge amounts of IP addresses compared to others.

Other way of finding errors in phone numbers was using approximated false negatives (this was run on interactive mode only, no batch script):

```
./approximate_FN.sh {source} {lang} {country code as string, e.g. "+358"}
```
This gives the number of redacted phone numbers vs. number of strings starting with the country code. 
Not perfect but works really well for country codes consisting of 3 number, okay for 2.
=> updated multilingual-PII-tool based on findings.
