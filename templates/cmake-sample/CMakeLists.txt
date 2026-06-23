cmake_minimum_required(VERSION 3.16)

project(cmake_sample VERSION 1.0.0 LANGUAGES CXX)

add_executable(cmake_sample src/main.cpp)

target_compile_features(cmake_sample PRIVATE cxx_std_17)
target_compile_options(cmake_sample PRIVATE -Wall -Wextra -Wpedantic)

