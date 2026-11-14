#!/bin/bash
# Runs the new segments and checks each output against the generator's expectation:
#   Ruby -> BASIC -> ChucK -> dash -> ... -> xonsh -> mksh -> ... -> Rhai -> Rust -> (Scala source)
# usage: verify.sh <workdir> <repo>   (expectations from _capture.rb in /tmp/expect)
D=$1; R=${2:-$HOME/qr/quine-relay}; rm -rf $D; mkdir -p $D; cd $D; cp $R/QR.rb .
export PATH=/usr/bin:/bin:$PATH:$HOME/go/bin:$HOME/.cargo/bin
fail=0
chk(){ ruby -e 'a=File.binread(ARGV[0]);b=File.binread(ARGV[1]); r=a==b ? "exact" : a.chomp==b.chomp ? "exact (+trailing newline)" : "MISMATCH"; puts "  %-14s %9d bytes  %s" % [File.basename(ARGV[0]), b.size, r]; exit(r=="MISMATCH" ? 1 : 0)' /tmp/expect/$1 $2 || fail=1; }
t(){ s=$(date +%s.%N); eval "$2" </dev/null 2>>err.log; printf "%6.1fs" $(echo "$(date +%s.%N)-$s"|bc); chk $1 $3; }
ruby QR.rb > QR.bas
t BwBASIC     "bwbasic QR.bas >/dev/null; cat QR.out > QR.ck"  QR.ck
t ChucK       "chuck --silent QR.ck > QR.dash"  QR.dash
t Dash        "dash QR.dash > QR.roff"  QR.roff
t Groff       "groff -z QR.roff 2> QR.hy"  QR.hy
t Hy          "python3.12 /usr/bin/hy QR.hy > QR.jsonnet"  QR.jsonnet
t Jsonnet     "jsonnet -S QR.jsonnet > QR.nl"  QR.nl
t NewLISPLang "newlisp -n QR.nl > QR.nqp"  QR.nqp
t NQP         "nqp QR.nqp > QR.l"  QR.l
t PicoLisp    "pil QR.l > QR.rkt"  QR.rkt
t RacketLang  "racket QR.rkt > QR.sql"  QR.sql
t SQL         "sqlite3 < QR.sql > QR.xsh"  QR.xsh
t Xonsh       "python3.12 /usr/bin/xonsh --no-rc QR.xsh > QR.mksh"  QR.mksh
t Mksh        "mksh QR.mksh > QR.yash"  QR.yash
t Yash        "yash QR.yash > QR.elv"  QR.elv
t Elvish      "elvish QR.elv > QR.vhdl"  QR.vhdl
t VHDL        "ghdl -a QR.vhdl && ghdl -e qr && ghdl -r qr > QR.genie.gs"  QR.genie.gs
t Genie       "valac QR.genie.gs && ./QR.genie > QR.xq"  QR.xq
t XQuery      "basex QR.xq > QR.koto"  QR.koto
t Koto        "koto QR.koto > QR.coco"  QR.coco
t Coconut     "coconut -q -r QR.coco > QR.ank"  QR.ank
t Anko        "anko QR.ank > QR.tengo"  QR.tengo
t Tengo       "tengo QR.tengo > QR.rhai"  QR.rhai
t Rhai        "rhai-run QR.rhai > QR.rs"  QR.rs
t Rust        "rustc -O QR.rs && ./QR > QR.scala"  QR.scala
[ $fail = 0 ] && echo ALL OK || echo FAILURES
