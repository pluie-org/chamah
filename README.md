# Chamah

Chamah is a symmetric-key algorythm.
Project is all fresh

### Todo

* Sheduled Key
* Entropy managment
* Crypt Header containing real random seed used by Chamah to cypher data & s-box generation
* Map split definition based on skey
* Map mix definition based on mkey
* Base64 encoding
* Compression
* Masking
* random Noise data addition over split and mix operation


### S-Box generation example

```
    ----------------------------------------------------------------------------------
    || 00 | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 0a | 0b | 0c | 0d | 0e | 0f |
    ----------------------------------------------------------------------------------
 00 || d1 | 04 | 02 | 8f | 7a | f4 | 5f | 19 | 89 | c2 | fb | 52 | 6f | 94 | f0 | b1 |
 01 || 71 | 03 | e0 | cd | 26 | 7b | c3 | 8b | 13 | 5a | fd | 98 | dc | c1 | 33 | 78 |
 02 || 30 | 4c | 09 | 08 | 9e | e6 | 86 | 5b | 41 | d8 | 00 | 9f | 63 | c5 | b4 | 28 |
 03 || b2 | 4a | fc | 0f | ef | f5 | 47 | 64 | ce | e5 | 0c | 73 | a8 | 7c | f9 | 9a |
 04 || b7 | 46 | 05 | 06 | 87 | cc | 5c | 1a | ae | 2b | 3c | 34 | 65 | d7 | 29 | 1f |
 05 || bd | 5e | f8 | 2a | 43 | d9 | 6a | ac | 79 | d6 | 3a | d2 | af | db | 22 | 72 |
 06 || a9 | 6e | 21 | 1e | 54 | 61 | be | aa | a2 | ad | 25 | f7 | bb | 84 | e8 | f6 |
 07 || 81 | 0e | ff | ee | 44 | ea | 5d | 3d | 97 | 1d | 0a | ed | 3b | d5 | 6b | c6 |
 08 || 2e | b9 | 4f | e1 | 10 | 45 | 1c | 8a | 68 | 57 | a0 | 12 | c4 | 18 | 76 | 95 |
 09 || 8e | a1 | 11 | 7d | f2 | 58 | 96 | c7 | 80 | e2 | 93 | 90 | 3f | b8 | a3 | 66 |
 0a || cf | 91 | 32 | ba | 37 | 62 | 67 | 99 | d3 | 17 | 88 | 51 | 59 | ca | a5 | 83 |
 0b || 4d | f1 | 0d | a7 | bc | 16 | 4b | 7f | 75 | 4e | 8d | 70 | ec | 69 | 50 | 60 |
 0c || 48 | 31 | 07 | 9d | ab | fe | da | 2c | 38 | d4 | b6 | eb | 82 | de | 9c | 6c |
 0d || 42 | b0 | 85 | e9 | 35 | 2f | 53 | a6 | c9 | 39 | c8 | 3e | 24 | e3 | 14 | fa |
 0e || 56 | b3 | 49 | 01 | bf | 8c | a4 | 2d | df | 20 | 27 | 36 | c0 | 15 | e7 | 9b |
 0f || 7e | b5 | 40 | d0 | 1b | cb | 0b | 55 | 6d | 92 | 74 | f3 | dd | 23 | e4 | 77 |
```

s-box are generated with input generator and several transformation

#### LEFT ROTATION

```
1 1 0 1 1 0 0 1 => 1 1 1 0 1 1 0 0 => ...
```

####  INVERSE LEFT ROTATION

```
1 1 0 1 1 0 0 1 
1 0 0 1 1 0 1 1 => 0 0 1 1 0 1 1 1 => ...
```

#### REVERSE LEFT ROTATION

```
1 1 0 1 1 0 0 1
0 0 1 0 0 1 1 0 => 0 0 0 1 0 0 1 1 => ...
```

#### REVERSE INVERSE LEFT ROTATION

```
1 1 0 1 1 0 0 1
0 0 1 0 0 1 1 0
0 1 1 0 0 1 0 0 => 1 1 0 0 1 0 0 0 => ...
```

```
   0 1 2 3 4 5 6 7   8 9 A B C D E F
0 [1 1 0 1 1 0 0 1] [0 0 0 1 0 0 1 1]
1 [1 1 1 0 1 1 0 0] [1 0 0 0 1 0 0 1]
2 [0 1 1 1 0 1 1 0] [1 1 0 0 0 1 0 0]
3 [0 0 1 1 1 0 1 1] [0 1 1 0 0 0 1 0]
4 [1 0 0 1 1 1 0 1] [0 0 1 1 0 0 0 1]
5 [1 1 0 0 1 1 1 0] [1 0 0 1 1 0 0 0]
6 [0 1 1 0 0 1 1 1] [0 1 0 0 1 1 0 0]
7 [1 0 1 1 0 0 1 1] [0 0 1 0 0 1 1 0]
    LEFT ROTATION    REVERSE LEFT ROT

   INVERSE LEFT ROT  REV INV LEFT ROT
8 [1 0 0 1 1 0 1 1] [1 1 0 0 1 0 0 0]
9 [0 0 1 1 0 1 1 1] [1 0 0 1 0 0 0 1]
A [0 1 1 0 1 1 1 0] [0 0 1 0 0 0 1 1]
B [1 1 0 1 1 1 0 0] [0 1 0 0 0 1 1 0]
C [1 0 1 1 1 0 0 1] [1 0 0 0 1 1 0 0]
D [0 1 1 1 0 0 1 1] [0 0 0 1 1 0 0 1]
E [1 1 1 0 0 1 1 0] [0 0 1 1 0 0 1 0]
F [1 1 0 0 1 1 0 1] [0 1 1 0 0 1 0 0]
```


### legend

--- : horizontal char or sequence duplicate  
|   : vertical char duplicate

#### input (36+1) string

```
blaz to blaz000000000000aozaozaozaoz

```

#### input chunk string view

```
000000 [12:12]  blaz to blaz|
                ----    ----
000001 [12:12]  000000000000
                ------------
000002 [12:12]  aozaozaozaoz|
000003 [01:12]  ------------
```

#### input chunk hexa representation

```
000000 [12:12]	62 6c 61 7a 20 74 6f 20 62 6c 61 7a | 
                -- -- -- --             -- -- -- --
000001 [12:12]	30 30 30 30 30 30 30 30 30 30 30 30 
                -- -- -- -- -- -- -- -- -- -- -- --
000002 [12:12]	61 6f 7a 61 6f 7a 61 6f 7a 61 6f 7a |
                -----------------------------------
000003 [01:12]	0a 
```

#### output chunk hexa representation

```
000000 [12:12]	30 51 13 ec 76 cc 32 ff 03 95 8f f7 
000001 [12:12]	ad 38 9a 58 ed 03 36 01 e1 2f 02 ee 
000002 [12:12]	71 31 f5 0b 38 82 e6 bb 2e 74 cc 84 
000003 [01:12]	c0 
```

#### output (37) string

```
0Q�v�2���8�X�6�/�q1�
                         8���.t̄
```

### round definition

input data is read by chunk  
on each chunk we iterate over input chunk data  
a standard round use s-box related to a key index with input as chunk data index  
extended round repeat operation with other s-box related to other key index with input as previous output  
next round can be standard or extended with input as previous output  

#### standard round

== input char ======

```
[r]ound : id - [i]nput chunk data : index - chunk [l]ength : index - [k]ey : index - [b]yte : output
```

#### extended round

```
{standard round} - [k]ey : index - [b]yte : output
```

### round example

```
== 62 ===============
r : 00 - i : 00 - l : 00 - k : 00 - b : 9c - k : 00 - b : 24
r : 01 - i : 00 - l : 00 - k : 01 - b : dc
r : 02 - i : 00 - l : 00 - k : 02 - b : f4
r : 03 - i : 00 - l : 00 - k : 03 - b : d3
r : 04 - i : 00 - l : 00 - k : 04 - b : 3d
r : 05 - i : 00 - l : 00 - k : 05 - b : 07
r : 06 - i : 00 - l : 00 - k : 06 - b : 9a
r : 07 - i : 00 - l : 00 - k : 07 - b : a8 - k : 07 - b : a4
r : 08 - i : 00 - l : 00 - k : 08 - b : e6
r : 09 - i : 00 - l : 00 - k : 09 - b : 5e - k : 09 - b : 8a
r : 10 - i : 00 - l : 00 - k : 10 - b : c6 - k : 06 - b : 0a
r : 11 - i : 00 - l : 00 - k : 11 - b : 30

all round transformation ([] are entended round) :
62 > [9c > 24] > dc > f4 > d3 > 3d > 07 > 9a > [a8 > a4] > e6 > [5e > 8a] > [c6 > 0a] > 30

```
### round sequences over chunk data iteration example

expose extended round moving position with related index key

```
== 6c ===============
r : 00 - i : 01 - l : 00 - k : 15 - b : 74 - k : 00 - b : b2
r : 01 - i : 01 - l : 00 - k : 14 - b : 84
r : 02 - i : 01 - l : 00 - k : 13 - b : fe
r : 03 - i : 01 - l : 00 - k : 12 - b : fd
r : 04 - i : 01 - l : 00 - k : 11 - b : e5
r : 05 - i : 01 - l : 00 - k : 10 - b : a1
r : 06 - i : 01 - l : 00 - k : 09 - b : 5c
r : 07 - i : 01 - l : 00 - k : 08 - b : 3e - k : 07 - b : e1
r : 08 - i : 01 - l : 00 - k : 07 - b : 82
r : 09 - i : 01 - l : 00 - k : 06 - b : c1 - k : 09 - b : fd
r : 10 - i : 01 - l : 00 - k : 05 - b : a9 - k : 06 - b : 0d
r : 11 - i : 01 - l : 00 - k : 04 - b : 51
== 61 ===============
r : 00 - i : 02 - l : 00 - k : 00 - b : 38 - k : 00 - b : 44
r : 01 - i : 02 - l : 00 - k : 01 - b : 74
r : 02 - i : 02 - l : 00 - k : 02 - b : 97 - k : 14 - b : 97
r : 03 - i : 02 - l : 00 - k : 03 - b : 33
r : 04 - i : 02 - l : 00 - k : 04 - b : 5e
r : 05 - i : 02 - l : 00 - k : 05 - b : 22
r : 06 - i : 02 - l : 00 - k : 06 - b : 64
r : 07 - i : 02 - l : 00 - k : 07 - b : 66
r : 08 - i : 02 - l : 00 - k : 08 - b : de
r : 09 - i : 02 - l : 00 - k : 09 - b : 9c - k : 09 - b : d5
r : 10 - i : 02 - l : 00 - k : 10 - b : 70
r : 11 - i : 02 - l : 00 - k : 11 - b : 2c - k : 11 - b : 13
== 7a ===============
r : 00 - i : 03 - l : 00 - k : 15 - b : aa - k : 00 - b : b7
r : 01 - i : 03 - l : 00 - k : 14 - b : df
r : 02 - i : 03 - l : 00 - k : 13 - b : 6b - k : 14 - b : e7
r : 03 - i : 03 - l : 00 - k : 12 - b : 7a
r : 04 - i : 03 - l : 00 - k : 11 - b : da
r : 05 - i : 03 - l : 00 - k : 10 - b : 02
r : 06 - i : 03 - l : 00 - k : 09 - b : 69
r : 07 - i : 03 - l : 00 - k : 08 - b : b7
r : 08 - i : 03 - l : 00 - k : 07 - b : 55
r : 09 - i : 03 - l : 00 - k : 06 - b : 4d - k : 09 - b : c2
r : 10 - i : 03 - l : 00 - k : 05 - b : 7a
r : 11 - i : 03 - l : 00 - k : 04 - b : a6 - k : 11 - b : ec
== 20 ===============
r : 00 - i : 04 - l : 00 - k : 00 - b : 7b
r : 01 - i : 04 - l : 00 - k : 01 - b : 15 - k : 01 - b : ed
r : 02 - i : 04 - l : 00 - k : 02 - b : 71 - k : 14 - b : ed
r : 03 - i : 04 - l : 00 - k : 03 - b : f6
r : 04 - i : 04 - l : 00 - k : 04 - b : 53 - k : 12 - b : e1
r : 05 - i : 04 - l : 00 - k : 05 - b : ab
r : 06 - i : 04 - l : 00 - k : 06 - b : 73
r : 07 - i : 04 - l : 00 - k : 07 - b : 3d
r : 08 - i : 04 - l : 00 - k : 08 - b : f4
r : 09 - i : 04 - l : 00 - k : 09 - b : 22
r : 10 - i : 04 - l : 00 - k : 10 - b : 3c
r : 11 - i : 04 - l : 00 - k : 11 - b : 4b - k : 11 - b : 76
== 74 ===============
r : 00 - i : 05 - l : 00 - k : 15 - b : 6c
r : 01 - i : 05 - l : 00 - k : 14 - b : be - k : 01 - b : 66
r : 02 - i : 05 - l : 00 - k : 13 - b : 50 - k : 14 - b : 13
r : 03 - i : 05 - l : 00 - k : 12 - b : b2
r : 04 - i : 05 - l : 00 - k : 11 - b : c6 - k : 12 - b : 78
r : 05 - i : 05 - l : 00 - k : 10 - b : af
r : 06 - i : 05 - l : 00 - k : 09 - b : cc
r : 07 - i : 05 - l : 00 - k : 08 - b : 3a
r : 08 - i : 05 - l : 00 - k : 07 - b : aa
r : 09 - i : 05 - l : 00 - k : 06 - b : bf
r : 10 - i : 05 - l : 00 - k : 05 - b : fb
r : 11 - i : 05 - l : 00 - k : 04 - b : c5 - k : 11 - b : cc
== 6f ===============
r : 00 - i : 06 - l : 00 - k : 00 - b : 64
r : 01 - i : 06 - l : 00 - k : 01 - b : 37 - k : 01 - b : a4
r : 02 - i : 06 - l : 00 - k : 02 - b : 00
r : 03 - i : 06 - l : 00 - k : 03 - b : a7 - k : 03 - b : 83
r : 04 - i : 06 - l : 00 - k : 04 - b : 86 - k : 12 - b : 0b
r : 05 - i : 06 - l : 00 - k : 05 - b : 61
r : 06 - i : 06 - l : 00 - k : 06 - b : c7 - k : 10 - b : ca
r : 07 - i : 06 - l : 00 - k : 07 - b : 5e
r : 08 - i : 06 - l : 00 - k : 08 - b : a9
r : 09 - i : 06 - l : 00 - k : 09 - b : b5
r : 10 - i : 06 - l : 00 - k : 10 - b : 82
r : 11 - i : 06 - l : 00 - k : 11 - b : 32
== 20 ===============
r : 00 - i : 07 - l : 00 - k : 15 - b : 0f
r : 01 - i : 07 - l : 00 - k : 14 - b : 73 - k : 01 - b : 3b
r : 02 - i : 07 - l : 00 - k : 13 - b : d2
r : 03 - i : 07 - l : 00 - k : 12 - b : 15 - k : 03 - b : 59
r : 04 - i : 07 - l : 00 - k : 11 - b : d9 - k : 12 - b : b7
r : 05 - i : 07 - l : 00 - k : 10 - b : 56
r : 06 - i : 07 - l : 00 - k : 09 - b : 95 - k : 10 - b : 06
r : 07 - i : 07 - l : 00 - k : 08 - b : 94
r : 08 - i : 07 - l : 00 - k : 07 - b : f4
r : 09 - i : 07 - l : 00 - k : 06 - b : df
r : 10 - i : 07 - l : 00 - k : 05 - b : 31
r : 11 - i : 07 - l : 00 - k : 04 - b : ff
== 62 ===============
r : 00 - i : 08 - l : 00 - k : 00 - b : 9c
r : 01 - i : 08 - l : 00 - k : 01 - b : ce
r : 02 - i : 08 - l : 00 - k : 02 - b : f6
r : 03 - i : 08 - l : 00 - k : 03 - b : 77 - k : 03 - b : 29
r : 04 - i : 08 - l : 00 - k : 04 - b : 19
r : 05 - i : 08 - l : 00 - k : 05 - b : 27 - k : 05 - b : 8d
r : 06 - i : 08 - l : 00 - k : 06 - b : 07 - k : 10 - b : 94
r : 07 - i : 08 - l : 00 - k : 07 - b : f4
r : 08 - i : 08 - l : 00 - k : 08 - b : c5 - k : 08 - b : 35
r : 09 - i : 08 - l : 00 - k : 09 - b : 7e
r : 10 - i : 08 - l : 00 - k : 10 - b : 9e
r : 11 - i : 08 - l : 00 - k : 11 - b : 03
== 6c ===============
r : 00 - i : 09 - l : 00 - k : 15 - b : 74
r : 01 - i : 09 - l : 00 - k : 14 - b : d3
r : 02 - i : 09 - l : 00 - k : 13 - b : 3c
r : 03 - i : 09 - l : 00 - k : 12 - b : 27 - k : 03 - b : 9d
r : 04 - i : 09 - l : 00 - k : 11 - b : ac
r : 05 - i : 09 - l : 00 - k : 10 - b : 3f - k : 05 - b : 3a
r : 06 - i : 09 - l : 00 - k : 09 - b : bc - k : 10 - b : 68
r : 07 - i : 09 - l : 00 - k : 08 - b : 96
r : 08 - i : 09 - l : 00 - k : 07 - b : a7 - k : 08 - b : 56
r : 09 - i : 09 - l : 00 - k : 06 - b : 0b
r : 10 - i : 09 - l : 00 - k : 05 - b : 61
r : 11 - i : 09 - l : 00 - k : 04 - b : 95
== 61 ===============
r : 00 - i : 10 - l : 00 - k : 00 - b : 38
r : 01 - i : 10 - l : 00 - k : 01 - b : c8
r : 02 - i : 10 - l : 00 - k : 02 - b : 60
r : 03 - i : 10 - l : 00 - k : 03 - b : 76
r : 04 - i : 10 - l : 00 - k : 04 - b : 18
r : 05 - i : 10 - l : 00 - k : 05 - b : 7c - k : 05 - b : 21
r : 06 - i : 10 - l : 00 - k : 06 - b : 82
r : 07 - i : 10 - l : 00 - k : 07 - b : de - k : 07 - b : 0d
r : 08 - i : 10 - l : 00 - k : 08 - b : b8 - k : 08 - b : aa
r : 09 - i : 10 - l : 00 - k : 09 - b : a1
r : 10 - i : 10 - l : 00 - k : 10 - b : e1 - k : 06 - b : 1a
r : 11 - i : 10 - l : 00 - k : 11 - b : 8f
== 7a ===============
r : 00 - i : 11 - l : 00 - k : 15 - b : aa
r : 01 - i : 11 - l : 00 - k : 14 - b : ba
r : 02 - i : 11 - l : 00 - k : 13 - b : 1e
r : 03 - i : 11 - l : 00 - k : 12 - b : 48
r : 04 - i : 11 - l : 00 - k : 11 - b : 44
r : 05 - i : 11 - l : 00 - k : 10 - b : 5f - k : 05 - b : 4b
r : 06 - i : 11 - l : 00 - k : 09 - b : 85
r : 07 - i : 11 - l : 00 - k : 08 - b : 8e - k : 07 - b : 65
r : 08 - i : 11 - l : 00 - k : 07 - b : f5 - k : 08 - b : 7c
r : 09 - i : 11 - l : 00 - k : 06 - b : d7
r : 10 - i : 11 - l : 00 - k : 05 - b : 73 - k : 06 - b : bc
r : 11 - i : 11 - l : 00 - k : 04 - b : f7
== 30 ===============
r : 00 - i : 00 - l : 01 - k : 00 - b : dd - k : 01 - b : fc
r : 01 - i : 00 - l : 01 - k : 01 - b : 32
r : 02 - i : 00 - l : 01 - k : 02 - b : d2
r : 03 - i : 00 - l : 01 - k : 03 - b : 4a
r : 04 - i : 00 - l : 01 - k : 04 - b : 8a
r : 05 - i : 00 - l : 01 - k : 05 - b : c0
r : 06 - i : 00 - l : 01 - k : 06 - b : 11
r : 07 - i : 00 - l : 01 - k : 07 - b : a9 - k : 08 - b : 0e
r : 08 - i : 00 - l : 01 - k : 08 - b : 03
r : 09 - i : 00 - l : 01 - k : 09 - b : 76 - k : 10 - b : e3
r : 10 - i : 00 - l : 01 - k : 10 - b : 48 - k : 07 - b : 1d
r : 11 - i : 00 - l : 01 - k : 11 - b : ad
```
