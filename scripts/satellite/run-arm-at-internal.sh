#!/bin/bash

bazel test --nocache_test_results --test_arg=--gtest_repeat=10 //... --cxxopt='-std=c++17' &
TEST_PID=$!

echo "Started bazel test with PID: $TEST_PID"

# Define a cleanup function to terminate ./src/main when the script exits
cleanup() {
    echo "Script is terminating, stopping test process..."
    kill "$TEST_PID" 2>/dev/null
    exit 0
}

# Infinite monitoring loop
while true
do
    # Check if test is still running
    if ! kill -0 "$TEST_PID" 2>/dev/null; then
        actual_path=$(readlink -f bazel-testlogs)
        cd $actual_path
        tar -czvf ./testlogs.tar ./anonymous_tokens
        mv ./testlogs.tar /root/anonymous-tokens/testlogs
        echo "test process has exited. Monitoring script will terminate."
        exit 0
    fi

    # Get current timestamp in YYYY-MM-DD HH:MM:SS format
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Execute top command and filter for "src/main"
    output=$(top -b -n 1 -w 512 | head -n 20)

    # Check if output is not empty
    if [ -n "$output" ]; then
        echo "$timestamp  $output"
    else
        echo "$timestamp  test not found."
    fi

    # Sleep for the specified time
    sleep 0.1
done

