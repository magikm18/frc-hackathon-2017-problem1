# frc-hackathon-2017-problem1
OpenScout FRC Hackathon 2017 (Problem 1)

## Instructions

Run `make` to compile (uses GCC and GNU AS)

Run `bin/problem1` with input file and output file as command-line args to run.

## Input format

- Maze levels must be separated by a single blank line (i.e. no additional whitespace)
- File must have UNIX-style line termination (i.e. LF); CRLF and CR formats are not supported

## Output

- `S`: Starting
- `X`: Reached Target
- `<`: Left
- `>`: Right
- `^`: Up
- `v`: Down
- `Z`: Next level
- `z`: Previous level

There is no path shorter than the solution given, however there may be others of the same length.
