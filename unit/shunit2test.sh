#!/bin/bash


BOLD='\033[1m'
BRIGHT_WHITE='\033[1;37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

local test_name="$1"
local expected="$2"
local output="$3"

debug_assert_equals() {
  if [ "$output" != "$expected" ]; then
    echo "${RED}TEST FAILED: $test_name${RESET}"
    echo "DEBUG: Expected:"
    echo "$expected"
    echo "DEBUG: Got:"
    echo "$output"
    assertEquals "Test '$test_name' failed." "$expected" "$output"
  else
    echo "${GREEN}TEST PASSED: $test_name${RESET}"
    echo "DEBUG: Expected:"
    echo "$expected"
    echo "DEBUG: Got:"
    echo "$output"
    assertEquals "Test '$test_name' passed." "$expected" "$output"
  fi
}


test_print1 () {
  output=$(bin/universe  -s -r '60-62')
  expected=" <   =   >   "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print002 () {
  output=$(bin/universe -s -n -r "60-62")
  expected=" <  
 =  
 >  "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print003 () {
  output=$(bin/universe -s -x -d -n -r "60-62")
  expected=" 60 0x60 <  
 61 0x61 =  
 62 0x62 >  "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print004 () {
  output=$(bin/universe -s -x -d -n -r "0x202e,0x202d,0x22,0x41-0x42")
  expected=" 8238 0x8238 ‮  
 8237 0x8237 ‭  
 34 0x34 \"  
 65 0x65 A  
 66 0x66 B  "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print005 () {
  output=$(bin/universe -s -n --main_delimiter_none -r "49,51,51,55")
  expected=" 1 
 3 
 3 
 7 "
  debug_assert_equals "test_print005" "$expected" "$output"

}

test_print006 () {
  output=$(bin/universe -s -n --main_delimiter_comma --block_delimiter_semicolon -ia tux)
  expected=";t,;
;u,;
;x,;"
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print007 () {
  output=$(bin/universe  -s -x -d   --main_delimiter_comma --block_delimiter_semicolon -ia "tux A bin A")
  expected=";116,0x116,t,;;117,0x117,u,;;120,0x120,x,;;32,0x32, ,;;65,0x65,A,;;32,0x32, ,;;98,0x98,b,;;105,0x105,i,;;110,0x110,n,;;32,0x32, ,;;65,0x65,A,; "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print008 () {
  output=$(bin/universe  -s   --main_delimiter_none --block_delimiter_semicolon -ia "Hello Binary")
  expected=";H;;e;;l;;l;;o;; ;;B;;i;;n;;a;;r;;y; "
  debug_assert_equals "test_print005" "$expected" "$output"
}


test_print009 () {
  output=$(bin/universe  -s   --main_delimiter_space --block_delimiter_space -ia "cat /dev/null | grep dev")
  expected=" c   a   t       /   d   e   v   /   n   u   l   l       |       g   r   e   p       d   e   v   "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print010 () {
  output=$(bin/universe  -d   --main_delimiter_comma --block_delimiter_space -ia "♫   ")
  expected=" 9835,  32,  32,  32,  "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print011 () {
  output=$(bin/universe  -d   --main_delimiter_space --block_delimiter_space -ia "\"")
  expected=" 34   "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print012 () {
  output=$(bin/universe -s --main_delimiter_none --block_delimiter_none -r "0x222A,0xFF2E,0x0399,0x0421,0x039F,0xFF24,0xFF25")
  expected="∪ＮΙСΟＤＥ "
  debug_assert_equals "test_print005" "$expected" "$output"
}

test_print013 () {
  output=$(bin/universe -s -x -d -n --main_delimiter_comma --block_delimiter_semicolon -r "0x200B,0x06D4,0x0DF4,0x2024,0x00B7,0xFF0E,0x02D9,0x02D7,0x0307,0x0323,0x00A0,0x002D,0xFF0F,0x002F,0x2010-0x2070,0x202A-0x202K")
  expected=";8203,0x8203,​,;
;1748,0x1748,۔,;
;3572,0x3572,෴,;
;8228,0x8228,․,;
;183,0x183,·,;
;65294,0x65294,．,;
;729,0x729,˙,;
;727,0x727,˗,;
;775,0x775,̇,;
;803,0x803,̣,;
;160,0x160, ,;
;45,0x45,-,;
;65295,0x65295,／,;
;47,0x47,/,;
;8208,0x8208,‐,;
;8209,0x8209,‑,;
;8210,0x8210,‒,;
;8211,0x8211,–,;
;8212,0x8212,—,;
;8213,0x8213,―,;
;8214,0x8214,‖,;
;8215,0x8215,‗,;
;8216,0x8216,‘,;
;8217,0x8217,’,;
;8218,0x8218,‚,;
;8219,0x8219,‛,;
;8220,0x8220,“,;
;8221,0x8221,”,;
;8222,0x8222,„,;
;8223,0x8223,‟,;
;8224,0x8224,†,;
;8225,0x8225,‡,;
;8226,0x8226,•,;
;8227,0x8227,‣,;
;8228,0x8228,․,;
;8229,0x8229,‥,;
;8230,0x8230,…,;
;8231,0x8231,‧,;
;8232,0x8232, ,;
;8233,0x8233, ,;
;8234,0x8234,‪,;
;8235,0x8235,‫,;
;8236,0x8236,‬,;
;8237,0x8237,‭,;
;8238,0x8238,‮,;
;8239,0x8239, ,;
;8240,0x8240,‰,;
;8241,0x8241,‱,;
;8242,0x8242,′,;
;8243,0x8243,″,;
;8244,0x8244,‴,;
;8245,0x8245,‵,;
;8246,0x8246,‶,;
;8247,0x8247,‷,;
;8248,0x8248,‸,;
;8249,0x8249,‹,;
;8250,0x8250,›,;
;8251,0x8251,※,;
;8252,0x8252,‼,;
;8253,0x8253,‽,;
;8254,0x8254,‾,;
;8255,0x8255,‿,;
;8256,0x8256,⁀,;
;8257,0x8257,⁁,;
;8258,0x8258,⁂,;
;8259,0x8259,⁃,;
;8260,0x8260,⁄,;
;8261,0x8261,⁅,;
;8262,0x8262,⁆,;
;8263,0x8263,⁇,;
;8264,0x8264,⁈,;
;8265,0x8265,⁉,;
;8266,0x8266,⁊,;
;8267,0x8267,⁋,;
;8268,0x8268,⁌,;
;8269,0x8269,⁍,;
;8270,0x8270,⁎,;
;8271,0x8271,⁏,;
;8272,0x8272,⁐,;
;8273,0x8273,⁑,;
;8274,0x8274,⁒,;
;8275,0x8275,⁓,;
;8276,0x8276,⁔,;
;8277,0x8277,⁕,;
;8278,0x8278,⁖,;
;8279,0x8279,⁗,;
;8280,0x8280,⁘,;
;8281,0x8281,⁙,;
;8282,0x8282,⁚,;
;8283,0x8283,⁛,;
;8284,0x8284,⁜,;
;8285,0x8285,⁝,;
;8286,0x8286,⁞,;
;8287,0x8287, ,;
;8288,0x8288,⁠,;
;8289,0x8289,⁡,;
;8290,0x8290,⁢,;
;8291,0x8291,⁣,;
;8292,0x8292,⁤,;
;8293,0x8293,⁥,;
;8294,0x8294,⁦,;
;8295,0x8295,⁧,;
;8296,0x8296,⁨,;
;8297,0x8297,⁩,;
;8298,0x8298,⁪,;
;8299,0x8299,⁫,;
;8300,0x8300,⁬,;
;8301,0x8301,⁭,;
;8302,0x8302,⁮,;
;8303,0x8303,⁯,;
;8304,0x8304,⁰,;"

  debug_assert_equals "test_print005" "$expected" "$output"
}