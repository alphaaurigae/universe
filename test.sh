#!/bin/bash


test_print1 () {
  output=$(./universe -s -d -ia "Hello")
  expected="72 H 101 e 108 l 108 l 111 o  "
  assertEquals "Output should contain default values when no flags are set with input-arg option" "$expected" "$output"
}

test_print2 () {
  output=$(./universe -s -d -ia "Hello World")
  expected="72 H 101 e 108 l 108 l 111 o 32   87 W 111 o 114 r 108 l 100 d  "
  assertEquals "Output should contain default values when no flags are set with input-arg option" "$expected" "$output"
}

test_print3 () {
  output=$(./universe -s -d -ia "1233")
  expected="49 1 50 2 51 3 51 3  "
  assertEquals "Output should contain default values when no flags are set with input-arg option" "$expected" "$output"
}

test_print4 () {
  output=$(./universe -s -d -ia "1233 1557")
  expected="49 1 50 2 51 3 51 3 32   49 1 53 5 53 5 55 7  "
  assertEquals "Output should contain default values when no flags are set with input-arg option" "$expected" "$output"
}

test_print5 () {
  output=$(./universe -s -d -ia "1233 1557 foo")
  expected="49 1 50 2 51 3 51 3 32   49 1 53 5 53 5 55 7 32   102 f 111 o 111 o  "
  assertEquals "Output should contain default values when no flags are set with input-arg option" "$expected" "$output"
}

test_print6 () {
  output=$(./universe -s -x -d -r "0x41-0x5A")
  expected="65 0x41 A 66 0x42 B 67 0x43 C 68 0x44 D 69 0x45 E 70 0x46 F 71 0x47 G 72 0x48 H 73 0x49 I 74 0x4a J 75 0x4b K 76 0x4c L 77 0x4d M 78 0x4e N 79 0x4f O 80 0x50 P 81 0x51 Q 82 0x52 R 83 0x53 S 84 0x54 T 85 0x55 U 86 0x56 V 87 0x57 W 88 0x58 X 89 0x59 Y 90 0x5a Z  "
  assertEquals "Output should contain default values when no flags are set with input-arg option" "$expected" "$output"
}

test_print7 () {
  output=$(./universe -s -x -d -r "0x41,0x43")
  expected="65 0x41 A  67 0x43 C  "
  assertEquals "Output should contain default values when no flags are set with input-arg option" "$expected" "$output"
}

test_print8 () { # work in progress
  output=$(./universe -s -x -d -r "0x41 0x43")
  expected="65 0x41 A  67 0x43 C  "
  assertEquals "Output should contain default values when no flags are set with input-arg option" "$expected" "$output"
}

# work in progress
# double trailing space issue unresolved,
# if run with ./universe -s -x -d -r "0x41 0x43" it only displays the output for 0x41 not for both 0x41 0x43