# Quine Relay 151

**A 151-language quine relay, verified end to end on Ubuntu 26.04.**
It extends [Yusuke Endoh's Quine Relay](https://github.com/mame/quine-relay) (128 languages) with 23 more.
We could not find a longer working quine relay anywhere in public (November 2026).

## What this is

[QR.rb](QR.rb) is a Ruby program that generates
a BASIC (bwBASIC) program that generates
a ChucK program that generates
...(through 151 languages in total)...
a REXX program that generates
the original Ruby code again.

![Language Uroboros][langs]

[langs]: langs.png

The languages in red are the 23 added in this fork. Everything in black is mame's original relay.

## Proof that it works

On November 13, 2026, the full relay ran in Docker on Ubuntu 26.04:

- **All 151 steps ran on their real interpreters and compilers.** No step was skipped or faked.
- Step 151 (REXX) printed `QR2.rb`, and it is byte-for-byte identical to `QR.rb`.
- `make check` passed. SHA-256 of both files:
  `67dd3929f2842512c5dcbe6958ab20d9c71eac5f386289f787f0d8ceb9433e32`
- The lap took about 12 minutes once the image was built.

The full logs are in [`proof/`](proof/). You can check it yourself with the two Docker commands below.

## What's new in this fork

BASIC (bwBASIC), ChucK, dash, groff, Hy, Jsonnet, newLISP, NQP, PicoLisp, Racket, SQL (SQLite), xonsh, mksh, yash, Elvish, VHDL, Genie, XQuery, Koto, Coconut, Anko, Tengo, Rhai.

They sit right after Ruby, at the start of the relay. [RELAY-151.md](RELAY-151.md) explains how each one was chosen and placed, and why order matters so much. (One wrong spot can blow a single step's output up to 16 MB.)

## Records

We claim records under two counting rules, and we publish the rules so anyone can compete under them.

- **Tier 1, distinct languages:** each language counts once, no matter how many versions or implementations run. This relay counts **143** under Tier 1 (mame's 128 counts 123).
- **Tier 2, relay steps:** steps counted the way mame counts them, with at most 3 implementations of one language. This relay counts **151**.

See [RECORDS.md](RECORDS.md) for the full rules, how to verify a claim, and the leaderboard. [LANGUAGES.md](LANGUAGES.md) tags every step with its Tier 1 status.

## Usage

### Docker (easiest)

    $ docker build -t qr .
    $ docker run --rm qr

This installs every language, builds the bundled interpreters, runs all 151 steps, and checks that the last file matches `QR.rb`.

### Ubuntu 26.04

#### 1. Install all the interpreters/compilers.

    $ sudo apt-get install afnix algol68g aspectj asymptote ats2-lang basex \
      bash bc bsh bwbasic chuck clisp clojure cmake coffeescript crystal \
      dash dc dhall dotnet-sdk-10.0 elixir elvish emacs-nox erlang execline \
      f2c fennel fish flex fp-compiler g++ gambas3-gb-pcre gambas3-scripter \
      gap gawk gcc gdb gdc genius gforth gfortran ghc ghdl ghostscript gm2 \
      gnat gnucobol4 gnuplot gobjc golang gpt groff groovy guile-3.0 gzip \
      haxe hy icont iconx intercal iverilog jasmin-sable jq jsonnet kotlin \
      ksh libevent-dev libpolyml-dev livescript llvm lua5.3 m4 make minizinc \
      mksh mono-devel nasm neko newlisp nickle nim node-typescript nodejs \
      nqp ocaml octave openjdk-25-jdk pari-gp parser3-cgi perl php-cli \
      picolisp pike8.0 polyml python3 r-base racket rakudo ratfor rc \
      regina-rexx ruby ruby-mustache rustc scala scilab-cli sed slsh spin \
      sqlite3 squirrel3 surgescript swi-prolog swiftlang tcl tcsh valac vim \
      wabt xonsh xsltproc yabasic yash yorick zoem zsh

Five languages have no Ubuntu package. Install them like this:

    $ sudo apt-get install python3-pip golang-go cargo
    $ pip install --break-system-packages coconut
    $ go install github.com/d5/tengo/v2/cmd/tengo@latest
    $ go install github.com/mattn/anko@latest
    $ cargo install rhai --features bin-features --bin rhai-run
    $ cargo install koto_cli

Then build the bundled interpreters.

    $ sudo apt-get install cmake libpng-dev libgd-dev libfl-dev groff bison curl
    $ make -C vendor

#### 2. Run each program on each interpreter/compiler.

    $ ulimit -s unlimited
    $ ruby QR.rb > QR.bas
    $ bwbasic QR.bas > /dev/null; cat QR.out > QR.ck
    $ chuck --silent QR.ck > QR.dash
    $ dash QR.dash > QR.roff
    $ groff -z QR.roff 2> QR.hy
    $ hy QR.hy > QR.jsonnet
    $ jsonnet -S QR.jsonnet > QR.nl
    $ newlisp -n QR.nl > QR.nqp
    $ nqp QR.nqp > QR.l
    $ pil QR.l > QR.rkt
    $ racket QR.rkt > QR.sql
    $ sqlite3 < QR.sql > QR.xsh
    $ xonsh --no-rc QR.xsh > QR.mksh
    $ mksh QR.mksh > QR.yash
    $ yash QR.yash > QR.elv
    $ elvish QR.elv > QR.vhdl
    $ ghdl -a QR.vhdl && ghdl -e qr && ghdl -r qr > QR.genie.gs
    $ valac QR.genie.gs && ./QR.genie > QR.xq
    $ basex QR.xq > QR.koto
    $ koto QR.koto > QR.coco
    $ coconut -q -r QR.coco > QR.ank
    $ anko QR.ank > QR.tengo
    $ tengo QR.tengo > QR.rhai
    $ rhai-run QR.rhai > QR.rs
    $ rustc QR.rs && ./QR > QR.scala
    $ scalac QR.scala && scala QR > QR.scm
    $ guile QR.scm > QR.sci
    $ scilab-cli -nb -f QR.sci > QR.sed
    $ sed -E -f QR.sed QR.sed > QR.spl
    $ spl2c < QR.spl > QR.spl.c && gcc -z muldefs -o QR -I ./vendor/local/include -L ./vendor/local/lib QR.spl.c -lspl -lm &&
      ./QR > QR.sl
    $ slsh QR.sl > QR.nut
    $ squirrel QR.nut > QR.sml
    $ polyc -o QR QR.sml && ./QR > QR.sq
    $ ruby vendor/subleq.rb QR.sq > QR.ss
    $ surgescript QR.ss > QR.swift
    $ swiftc QR.swift && ./QR > QR.tcl
    $ tclsh QR.tcl > QR.tcsh
    $ tcsh QR.tcsh > QR.t
    $ ruby vendor/thue.rb QR.t > QR.ts
    $ tsc --outFile QR.ts.js QR.ts && nodejs QR.ts.js > QR.unl
    $ ruby vendor/unlambda.rb QR.unl > QR.vala
    $ valac QR.vala && ./QR > QR.mid
    $ mono vendor/local/bin/Vlt.exe /s QR.mid && mono QR.exe > QR.v
    $ iverilog -o QR QR.v && ./QR -vcd-none > QR.vim
    $ vim -EsS QR.vim > QR.vb
    $ echo '<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework><EnableDefaultCompileItems>false</EnableDefaultCompileItems></PropertyGroup><ItemGroup><Compile Include="QR.vb" /></ItemGroup></Project>' > tmp.vbproj &&
      DOTNET_NOLOGO=1 dotnet run --project tmp.vbproj > QR.wasm
    $ $(WASI_RUNTIME) QR.wasm > QR.wat
    $ wat2wasm QR.wat -o QR.wat.wasm && $(WASI_RUNTIME) QR.wat.wasm > QR.ws
    $ ruby vendor/whitespace.rb QR.ws > QR.xslt
    $ xsltproc QR.xslt > QR.yab
    $ yabasic QR.yab > QR.yorick
    $ yorick -batch QR.yorick > QR.azm
    $ zoem -i QR.azm > QR.zsh
    $ zsh QR.zsh > qr.adb
    $ gnatmake qr.adb && ./qr > QR.als
    $ LANG=C LD_LIBRARY_PATH=/usr/lib/afnix axi QR.als > QR.aheui
    $ ruby vendor/aheui.rb QR.aheui > QR.a68
    $ a68g QR.a68 > QR.ante
    $ ruby vendor/ante.rb QR.ante > QR.aj
    $ ajc QR.aj && java QR > QR.asy
    $ asy QR.asy > QR.dats
    $ patscc -o QR QR.dats && ./QR > QR.awk
    $ awk -f QR.awk > QR.bash
    $ bash QR.bash > QR.bc
    $ BC_LINE_LENGTH=4000000 bc -q QR.bc > QR.bsh
    $ bsh QR.bsh > QR.bef
    $ cfunge QR.bef > QR.Blc
    $ ruby vendor/blc.rb < QR.Blc > QR.bf
    $ ruby vendor/bf.rb QR.bf > QR.c
    $ gcc -o QR QR.c && ./QR > QR.cpp
    $ g++ -o QR QR.cpp && ./QR > QR.cs
    $ echo '<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework><EnableDefaultCompileItems>false</EnableDefaultCompileItems></PropertyGroup><ItemGroup><Compile Include="QR.cs" /></ItemGroup></Project>' > tmp.csproj &&
      DOTNET_NOLOGO=1 dotnet run --project tmp.csproj > QR.chef
    $ PERL5LIB=vendor/local/lib/perl5 compilechef QR.chef QR.chef.pl &&
      perl QR.chef.pl > QR.clj
    $ clojure QR.clj > QR.cmake
    $ cmake -P QR.cmake > QR.cob
    $ cobc -O2 -x QR.cob && ./QR > QR.coffee
    $ coffee --nodejs --stack_size=100000 QR.coffee > QR.lisp
    $ clisp QR.lisp > QR.cr
    $ crystal QR.cr > QR.d
    $ gdc -o QR QR.d && ./QR > QR.dc
    $ dc QR.dc > QR.dhall || true
    $ dhall text --file QR.dhall > QR.exs
    $ elixir QR.exs > QR.el
    $ emacs -Q --script QR.el > QR.erl
    $ escript QR.erl > QR.e
    $ execlineb QR.e > QR.fsx
    $ echo '<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework><EnableDefaultCompileItems>false</EnableDefaultCompileItems></PropertyGroup><ItemGroup><Compile Include="QR.fsx" /></ItemGroup></Project>' > tmp.fsproj &&
      DOTNET_NOLOGO=1 dotnet run --project tmp.fsproj > QR.false
    $ ruby vendor/false.rb QR.false > QR.fnl
    $ fennel QR.fnl > QR.fl
    $ flex -o QR.fl.c QR.fl && gcc -o QR QR.fl.c && ./QR > QR.fish
    $ fish QR.fish > QR.fs
    $ gforth QR.fs > QR.f
    $ gfortran -o QR QR.f && ./QR > QR.f90
    $ gfortran -o QR QR.f90 && ./QR > QR.gbs
    $ gbs3 QR.gbs > QR.g
    $ gap -q QR.g > QR.gdb
    $ gdb -q -x QR.gdb > QR.gel
    $ genius QR.gel > QR.plt
    $ gnuplot QR.plt > QR.go
    $ go run QR.go > QR.gs
    $ ruby vendor/golfscript.rb QR.gs > QR.gpt
    $ mv QR.c QR.c.bak && gpt -t QR.c QR.gpt && gcc -o QR QR.c && ./QR > QR.grass &&
      mv QR.c.bak QR.c
    $ ruby vendor/grass.rb QR.grass > QR.groovy
    $ groovy QR.groovy > QR.gz
    $ gzip -cd QR.gz > QR.hs
    $ rm -f QR.o && ghc QR.hs && ./QR > QR.hx
    $ haxe -main QR -neko QR.n && neko QR.n > QR.icn
    $ icont -s QR.icn && ./QR > QR.i
    $ ick -bfOc QR.i && gcc -std=c99 -static QR.c -I /usr/include/ick-* -o QR -lick &&
      ./QR > QR.j
    $ jasmin QR.j && java QR > QR.java
    $ javac QR.java && java QR > QR.js
    $ nodejs QR.js > QR.jq
    $ jq -r -n -f QR.jq > QR.jsfuck
    $ nodejs --stack_size=100000 QR.jsfuck > QR.kt
    $ kotlinc QR.kt -include-runtime -d QR.jar && kotlin QR.jar > QR.ksh
    $ ksh QR.ksh > QR.lazy
    $ lazyk QR.lazy > QR.ls
    $ lsc QR.ls > QR.ll
    $ llvm-as QR.ll && lli QR.bc > QR.lol
    $ lci QR.lol > QR.lua
    $ lua5.3 QR.lua > QR.m4
    $ m4 QR.m4 > QR.mk
    $ make -f QR.mk > QR.mzn
    $ minizinc --solver COIN-BC --soln-sep '' QR.mzn > QR.mod
    $ gm2 -fiso QR.mod -o QR && ./QR > QR.il
    $ ilasm QR.il && mono QR.exe > QR.mustache
    $ mustache QR.mustache QR.mustache > QR.asm
    $ nasm -felf QR.asm && ld -m elf_i386 -o QR QR.o && ./QR > QR.neko
    $ nekoc QR.neko && neko QR.n > QR.5c
    $ nickle QR.5c > QR.nim
    $ nim compile QR.nim && ./QR > QR.m
    $ gcc -o QR QR.m && ./QR > QR.ml
    $ ocaml QR.ml > QR.octave
    $ mv QR.m QR.m.bak && octave -qf QR.octave > QR.ook && mv QR.m.bak QR.m
    $ ruby vendor/ook-to-bf.rb QR.ook QR.ook.bf && ruby vendor/bf.rb QR.ook.bf > QR.gp
    $ gp -f -q QR.gp > QR.p
    $ parser3 QR.p > QR.pas
    $ fpc QR.pas && ./QR > QR.pl
    $ perl QR.pl > QR.pl6
    $ perl6 QR.pl6 > QR.php
    $ php QR.php > QR.png
    $ npiet QR.png > QR.pike
    $ pike QR.pike > QR.ps
    $ gs -dNODISPLAY -q QR.ps > QR.prolog
    $ swipl -q -t qr -f QR.prolog > QR.pr
    $ spin -T QR.pr > QR.py
    $ python3 QR.py > QR.R
    $ R --slave -f QR.R > QR.ratfor
    $ ratfor -o QR.ratfor.f QR.ratfor && gfortran -o QR QR.ratfor.f &&
      ./QR > QR.rc
    $ rc QR.rc > QR.rexx
    $ rexx ./QR.rexx > QR2.rb

You will see that `QR.rb` is the same as `QR2.rb`.

    $ diff QR.rb QR2.rb

Or just type `make`.

    $ make

Note: some files take a lot of memory to compile.

## Languages and packages

\#  |language                    |ubuntu package (or how to get it)                           |added in
----|----------------------------|------------------------------------------------------------|--------------
1   |Ruby                        |ruby                                                        |mame
2   |BASIC (bwBASIC)             |bwbasic                                                     |**this fork**
3   |ChucK                       |chuck                                                       |**this fork**
4   |dash                        |dash                                                        |**this fork**
5   |groff                       |groff                                                       |**this fork**
6   |Hy                          |hy                                                          |**this fork**
7   |Jsonnet                     |jsonnet                                                     |**this fork**
8   |newLISP                     |newlisp                                                     |**this fork**
9   |NQP                         |nqp                                                         |**this fork**
10  |PicoLisp                    |picolisp                                                    |**this fork**
11  |Racket                      |racket                                                      |**this fork**
12  |SQL (SQLite)                |sqlite3                                                     |**this fork**
13  |xonsh                       |xonsh                                                       |**this fork**
14  |mksh                        |mksh                                                        |**this fork**
15  |yash                        |yash                                                        |**this fork**
16  |Elvish                      |elvish                                                      |**this fork**
17  |VHDL                        |ghdl                                                        |**this fork**
18  |Genie                       |valac                                                       |**this fork**
19  |XQuery                      |basex                                                       |**this fork**
20  |Koto                        |`cargo install koto_cli`                                    |**this fork**
21  |Coconut                     |`pip install coconut`                                       |**this fork**
22  |Anko                        |`go install github.com/mattn/anko`                          |**this fork**
23  |Tengo                       |`go install github.com/d5/tengo/v2/cmd/tengo`               |**this fork**
24  |Rhai                        |`cargo install rhai --features bin-features --bin rhai-run` |**this fork**
25  |Rust                        |rustc                                                       |mame
26  |Scala                       |scala                                                       |mame
27  |Scheme                      |guile-3.0                                                   |mame
28  |Scilab                      |scilab-cli                                                  |mame
29  |sed                         |sed                                                         |mame
30  |Shakespeare                 |*bundled in vendor/*                                        |mame
31  |S-Lang                      |slsh                                                        |mame
32  |Squirrel                    |squirrel3                                                   |mame
33  |Standard ML                 |polyml, libpolyml-dev                                       |mame
34  |Subleq                      |*bundled in vendor/*                                        |mame
35  |SurgeScript                 |surgescript                                                 |mame
36  |Swift                       |swiftlang                                                   |mame
37  |Tcl                         |tcl                                                         |mame
38  |tcsh                        |tcsh                                                        |mame
39  |Thue                        |*bundled in vendor/*                                        |mame
40  |TypeScript                  |node-typescript                                             |mame
41  |Unlambda                    |*bundled in vendor/*                                        |mame
42  |Vala                        |valac                                                       |mame
43  |Velato                      |*bundled in vendor/*                                        |mame
44  |Verilog                     |iverilog                                                    |mame
45  |Vimscript                   |vim                                                         |mame
46  |Visual Basic                |dotnet-sdk-10.0                                             |mame
47  |WebAssembly (Binary format) |wabt                                                        |mame
48  |WebAssembly (Text format)   |wabt                                                        |mame
49  |Whitespace                  |*bundled in vendor/*                                        |mame
50  |XSLT                        |xsltproc                                                    |mame
51  |Yabasic                     |yabasic                                                     |mame
52  |Yorick                      |yorick                                                      |mame
53  |Zoem                        |zoem                                                        |mame
54  |zsh                         |zsh                                                         |mame
55  |Ada                         |gnat                                                        |mame
56  |AFNIX                       |afnix                                                       |mame
57  |Aheui                       |*bundled in vendor/*                                        |mame
58  |ALGOL 68                    |algol68g                                                    |mame
59  |Ante                        |*bundled in vendor/*                                        |mame
60  |AspectJ                     |aspectj                                                     |mame
61  |Asymptote                   |asymptote                                                   |mame
62  |ATS                         |ats2-lang                                                   |mame
63  |Awk                         |gawk                                                        |mame
64  |bash                        |bash                                                        |mame
65  |bc                          |bc                                                          |mame
66  |BeanShell                   |bsh                                                         |mame
67  |Befunge                     |*bundled in vendor/*                                        |mame
68  |BLC8                        |*bundled in vendor/*                                        |mame
69  |Brainfuck                   |*bundled in vendor/*                                        |mame
70  |C                           |gcc                                                         |mame
71  |C++                         |g++                                                         |mame
72  |C#                          |dotnet-sdk-10.0                                             |mame
73  |Chef                        |*bundled in vendor/*                                        |mame
74  |Clojure                     |clojure                                                     |mame
75  |CMake                       |cmake                                                       |mame
76  |Cobol                       |gnucobol4                                                   |mame
77  |CoffeeScript                |coffeescript                                                |mame
78  |Common Lisp                 |clisp                                                       |mame
79  |Crystal                     |crystal, libevent-dev                                       |mame
80  |D                           |gdc                                                         |mame
81  |dc                          |dc                                                          |mame
82  |Dhall                       |dhall                                                       |mame
83  |Elixir                      |elixir                                                      |mame
84  |Emacs Lisp                  |emacs-nox                                                   |mame
85  |Erlang                      |erlang                                                      |mame
86  |Execline                    |execline                                                    |mame
87  |F#                          |dotnet-sdk-10.0                                             |mame
88  |FALSE                       |*bundled in vendor/*                                        |mame
89  |Fennel                      |fennel                                                      |mame
90  |Flex                        |flex                                                        |mame
91  |Fish                        |fish                                                        |mame
92  |Forth                       |gforth                                                      |mame
93  |FORTRAN77                   |f2c                                                         |mame
94  |Fortran90                   |gfortran                                                    |mame
95  |Gambas script               |gambas3-scripter, gambas3-gb-pcre                           |mame
96  |GAP                         |gap                                                         |mame
97  |GDB                         |gdb                                                         |mame
98  |GEL (Genius)                |genius                                                      |mame
99  |Gnuplot                     |gnuplot                                                     |mame
100 |Go                          |golang                                                      |mame
101 |GolfScript                  |*bundled in vendor/*                                        |mame
102 |G-Portugol                  |gpt                                                         |mame
103 |Grass                       |*bundled in vendor/*                                        |mame
104 |Groovy                      |groovy                                                      |mame
105 |Gzip                        |gzip                                                        |mame
106 |Haskell                     |ghc                                                         |mame
107 |Haxe                        |haxe                                                        |mame
108 |Icon                        |icont, iconx                                                |mame
109 |INTERCAL                    |intercal                                                    |mame
110 |Jasmin                      |jasmin-sable                                                |mame
111 |Java                        |openjdk-25-jdk                                              |mame
112 |JavaScript                  |nodejs                                                      |mame
113 |Jq                          |jq                                                          |mame
114 |JSFuck                      |nodejs                                                      |mame
115 |Kotlin                      |kotlin                                                      |mame
116 |ksh                         |ksh                                                         |mame
117 |Lazy K                      |*bundled in vendor/*                                        |mame
118 |LiveScript                  |livescript                                                  |mame
119 |LLVM asm                    |llvm                                                        |mame
120 |LOLCODE                     |*bundled in vendor/*                                        |mame
121 |Lua                         |lua5.3                                                      |mame
122 |M4                          |m4                                                          |mame
123 |Makefile                    |make                                                        |mame
124 |MiniZinc                    |minizinc                                                    |mame
125 |Modula-2                    |gm2                                                         |mame
126 |MSIL                        |mono-devel                                                  |mame
127 |Mustache                    |ruby-mustache                                               |mame
128 |NASM                        |nasm                                                        |mame
129 |Neko                        |neko                                                        |mame
130 |Nickle                      |nickle                                                      |mame
131 |Nim                         |nim                                                         |mame
132 |Objective-C                 |gobjc                                                       |mame
133 |OCaml                       |ocaml                                                       |mame
134 |Octave                      |octave                                                      |mame
135 |Ook!                        |*bundled in vendor/*                                        |mame
136 |PARI/GP                     |pari-gp                                                     |mame
137 |Parser 3                    |parser3-cgi                                                 |mame
138 |Pascal                      |fp-compiler                                                 |mame
139 |Perl 5                      |perl                                                        |mame
140 |Perl 6                      |rakudo                                                      |mame
141 |PHP                         |php-cli                                                     |mame
142 |Piet                        |*bundled in vendor/*                                        |mame
143 |Pike                        |pike8.0                                                     |mame
144 |PostScript                  |ghostscript                                                 |mame
145 |Prolog                      |swi-prolog                                                  |mame
146 |Promela (Spin)              |spin                                                        |mame
147 |Python                      |python3                                                     |mame
148 |R                           |r-base                                                      |mame
149 |Ratfor                      |ratfor                                                      |mame
150 |rc                          |rc                                                          |mame
151 |REXX                        |regina-rexx                                                 |mame

Languages marked *bundled in vendor/* have no Ubuntu package.
This repository includes their interpreters in `vendor/`; see `vendor/README`.

## Frequently asked questions

### Q. Who made this?

A. The original 128-language relay, its generator and nearly all of the clever parts are by [Yusuke Endoh (mame)](https://github.com/mame). This fork adds 23 languages, the placement rules that keep the files small, and the record rules. It is made by [Drawn With Code](https://www.youtube.com/@DrawnWithCode).

### Q. How does a quine relay work?

A. mame explains it in his book ["The World of Obfuscated, Esoteric, Artistic Programming"](http://gihyo.jp/book/2015/978-4-7741-7643-7) (in Japanese). The short version: every program holds the next program as a string, and that string holds the next one, all the way around the loop.

### Q. Language XXX is missing!

A. Send a pull request. A new language has to run in the Docker image, and the full loop has to close with no stand-ins. See [RECORDS.md](RECORDS.md) for the rules.

### Q. The code does not fit in my screen!

A. [Here you go][thumbnail].

[thumbnail]: thumbnail.png

### Q. How was the code generated?

A.

    $ cd src
    $ rake

`src/code-gen.rb` holds every language. `rake` rebuilds `QR.rb`, `Makefile`, `Dockerfile`, the CI workflow and this README. `langs.png` and `thumbnail.png` come from `src/langs.png.gen.rb` and `src/thumbnail.png.gen.rb`.

## History

### This fork

- **151 languages, Ubuntu 26.04 (Nov 2026).** Added: BASIC (bwBASIC), ChucK, dash, groff, Hy, Jsonnet, newLISP, NQP, PicoLisp, Racket, SQL (SQLite), xonsh, mksh, yash, Elvish, VHDL, Genie, XQuery, Koto, Coconut, Anko, Tengo, Rhai.

### mame's Quine Relay

### for Ubuntu 13.04

[50 languages](https://github.com/mame/quine-relay/tree/ad3f8222c796969db8cfb1bae015a46c2387b3d6)

Added: Ruby, Scala, Scheme, bash, Smalltalk, Unlambda, Tcl, Whitespace, Verilog, Vala, Ada, ALGOL 68, Awk, Brainfuck, Boo, C, C++, C#, Cobol, Clojure, Fortran90, FORTRAN77, Forth, Common Lisp, CoffeeScript, Groovy, Go, INTERCAL, Icon, Haskell, Jasmin, Java, LLVM asm, Logo, Lua, Makefile, MSIL, Objective-C, JavaScript, OCaml, Octave, Parrot asm, Pascal, Perl, PHP, Pike, Prolog, Python, R, REXX

### for Ubuntu 13.10

[50 languages](https://github.com/mame/quine-relay/tree/ea4d39fb1ebc7ee23ec6f60ca7bfa0d465b5806a)

### for Ubuntu 14.04

[50 languages](https://github.com/mame/quine-relay/tree/d16bf072e3063dc476dc440c8f3e33d7426e98db)

### for Ubuntu 14.10

[64 languages](https://github.com/mame/quine-relay/tree/e449baba456d4885102482cbd365335be59241b2)

Added: Scilab, S-Lang, SPL, LOLCODE, Maxima, NASM, Neko, Nickle, Ook!, PARI/GP, Piet, PPT (Punched tape), PostScript, Ratfor

### for Ubuntu 15.04

[100 languages](https://github.com/mame/quine-relay/tree/7749715289ca162eb1c1eb1ff1ed1393edc41630)

Added: Subleq, Standard ML, Thue, Visual Basic, XSLT, Yorick, Zoem, A+, AFNIX, Ante, Asymptote, ATS, BLC8, Befunge, bc, Chef, CDuce, D, dc, eC, Emacs Lisp, Erlang, F#, Falcon, FALSE, Gambas script, GAP, GEL (Genius), Gnuplot, G-Portugol, Gri, Haxe, Julia, Lisaac, Lazy K, Kaya

### for Ubuntu 15.10

[100 languages](https://github.com/mame/quine-relay/tree/f45035f867c7c8f7b4e12fa63e7c8eef9aabecad)

Removed: Boo, Falcon, Kaya

Added: Elixir, Jq, Nim

### for Ubuntu 16.04

[100 languages](https://github.com/mame/quine-relay/tree/233ba8b4e1d7e4c59a46d64481048a8ea7f4400e)

### for Ubuntu 17.04

[100 languages](https://github.com/mame/quine-relay/tree/e65a798da23df0367d9eb5e4d46f00d87e6cb342)

Removed: SPL, Gri, Logo, Parrot asm

Added: Squirrel, Dafny, Grass, MiniZinc

### for Ubuntu 17.10

[100 languages](https://github.com/mame/quine-relay/tree/943b83801a1bd019ebf348adc78df2cdfde06513)

Removed: CDuce

Added: Rust

### for Ubuntu 18.04

[128 languages](https://github.com/mame/quine-relay/tree/6e173d76e972e1da7992b84768bf9f4c788949ed)

Removed: Gambas script, Perl

Added: Shakespeare, sed, tcsh, TypeScript, Velato, Vimscript, Yabasic, zsh, Aheui, AspectC++, AspectJ, BeanShell, CMake, Flex, Fish, GDB, GolfScript, Gzip, Gri, JSFuck, ksh, LiveScript, M4, Mustache, nesC, Parser 3, Perl 5, Perl 6, Promela (Spin), rc

### for Ubuntu 19.04

[128 languages](https://github.com/mame/quine-relay/tree/c8898351500682cea02219313e9203da7eca5505)

Removed: Scilab, G-Portugol, nesC

Added: Curry, Gambas script, GeneratorScriptingLanguage

### for Ubuntu 19.10

[128 languages](https://github.com/mame/quine-relay/tree/13041dbf3f80a90c9221ef94f8e8bc385800b6fd)

Removed: Gri

Added: Scilab

### for Ubuntu 20.04

[128 languages](https://github.com/mame/quine-relay/tree/62e2cc2d61d99719328094d185d899bc03a851fb)

### for Ubuntu 20.10

[128 languages](https://github.com/mame/quine-relay/tree/114f44fefd610812d2f5e3032603762752ed51b2)

Removed: AspectC++, eC

Added: SurgeScript, Dhall

### for Ubuntu 21.04

[128 languages](https://github.com/mame/quine-relay/tree/d8df33bad3693afd0bd3bf1c2b1cedd5753325dc)

Removed: Curry

Added: G-Portugol

### for Ubuntu 21.10

[128 languages](https://github.com/mame/quine-relay/tree/158b6251d36a48122ec0006feaf759d8b1973b0f)

### for Ubuntu 22.04

[128 languages](https://github.com/mame/quine-relay/tree/7b81d8704549d31814499c5300be2be9568467c8)

Removed: Julia, Nim, Pike

Added: WebAssembly (Text format), WebAssembly (Binary format), Kotlin

### for Ubuntu 22.10

[128 languages](https://github.com/mame/quine-relay/tree/362962dd2d55d7c36dd9fa3e0d4c0c52c0e6a18f)

### for Ubuntu 23.04

[128 languages](https://github.com/mame/quine-relay/tree/5dfdada5aa58f6a97ae85b84f86c7eb091225a8c)

Removed: Squirrel, GeneratorScriptingLanguage

Added: Crystal, Nim

### for Ubuntu 23.10

[128 languages](https://github.com/mame/quine-relay/tree/74c4cc7d79fccbb1c8315070b9efea03cb787755)

Removed: Smalltalk

Added: Modula-2

### for Ubuntu 24.04

[128 languages](https://github.com/mame/quine-relay/tree/20d7f437c053b8e0b301ba996d124a4b812e3571)

Removed: PPT (Punched tape)

Added: Pike

### for Ubuntu 24.10

[128 languages](https://github.com/mame/quine-relay/tree/2ed61a62c9d31121b39e740c89107085c122f478)

Removed: Dafny, Maxima

Added: Execline, Squirrel

### for Ubuntu 25.04

[128 languages](https://github.com/mame/quine-relay/tree/b9c8056cad4589fe650163a3fd0cea4b3055fce4)

### for Ubuntu 25.10

[128 languages](https://github.com/mame/quine-relay/tree/5298413382ea707061e04aa077f99872d159a7b8)

Removed: Lisaac

Added: Swift

### for Ubuntu 26.04

[128 languages](https://github.com/mame/quine-relay/tree/4f5a5700a746dc6fff136b9c4a1a13df00e946e1)

Removed: A+

Added: Fennel

## License

The MIT License applies to all resources
*except* the files in the `vendor/` directory.

The files in the `vendor/` directory are from third-parties
and are distributed under different licenses.
See `vendor/README` in detail.

---

The MIT License (MIT)

Copyright (c) 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 Yusuke Endoh (@mametter), @hirekoke
Copyright (c) 2026 Drawn With Code (@rasteia): the 23 languages added in this fork

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
