cmake_minimum_required(VERSION 3.7)
project(frc_hackathon_2017_problem1)

set(SOURCE_FILES)

add_custom_target(problem1 make all
        SOURCES src/addmaybe.s src/algorithm.s src/decode.s src/encode.s src/info.s src/main.s src/metadata.s src/pushlead.s src/readall.s src/result.s)
