## Comparing

To compare two local files run:

    ./diff a.data b.data

To compare two commited versions using the benchrunner data use:

    ./diff commit-id,type commit-id,type

where `commit-id` is the 40 character sha hash of a commit and `type` is llvm, gnur, or fastr.

To be able to fetch the benchmark results from gitlab, you need to create a file called `token.secret` which contains a gitlab api token (without newline).

## Recording

install rebench from https://github.com/charig/ReBench

copy default config

    cp rebench.conf.dist rebench.conf

setup paths to your rir and benchmark directory (LOCATION_RIR, LOCATION_AWF, LOCATION_SHT)

    vim rebench.conf

checkout master, compile a release build. then come back to this dir and:

    ./run.sh baseline.data

checkout your branch to test and compile

    ./run.sh feature.data
