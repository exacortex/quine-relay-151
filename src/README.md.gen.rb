require_relative "code-gen"
require "erb"

other_packages = %w(cmake libpng-dev libgd-dev libfl-dev groff bison curl)

apts = RunSteps.map {|s| s.apt }

# Languages with no Ubuntu package: how the Dockerfile installs them
extra_installs = {
  "Koto" => "cargo install koto_cli",
  "Coconut" => "pip install coconut",
  "Anko" => "go install github.com/mattn/anko",
  "Tengo" => "go install github.com/d5/tengo/v2/cmd/tengo",
  "Rhai" => "cargo install rhai --features bin-features --bin rhai-run",
}
new_langs = RunSteps[1, 23].map {|s| s.name }

rows = [["\\#", "language", "ubuntu package (or how to get it)", "added in"]]
rows += RunSteps.map.with_index do |s, idx|
  apt = s.apt.is_a?(Array) ? s.apt.join(", ") : s.apt
  apt ||= extra_installs[s.name] ? "`#{ extra_installs[s.name] }`" : "*bundled in vendor/*"
  [(idx + 1).to_s, s.name, apt, new_langs.include?(s.name) ? "**this fork**" : "mame"]
end

ws = rows.transpose.map {|row| row.map {|s| s.size }.max + 1 }
rows[1, 0] = [ws.map {|w| "-" * w }]
rows = rows.map do |col|
  (col.zip(ws).map {|s, w| s.ljust(w) } * "|").rstrip
end

apt_get = "sudo apt-get install #{ [*apts.flatten.compact.uniq].sort * " " }"
apt_get.gsub!(/.{,70}( |\z)/) do
  $&[-1] == " " ? $& + "\\\n      " : $&
end

cmds = [*RunSteps, RunStep["Ruby", "QR2.rb"]].each_cons(2).map do |s1, s2|
  cmd = s1.cmd_raw
  src = s2.src
  cmd = cmd.gsub("OUTFILE", src)

  cmd = cmd.gsub(/^!/, "")
  cmd = cmd.gsub(/.{60,}?&&/, "\\0\n     ")

  cmd
end

File.write("../README.md", ERB.new(DATA.read, trim_mode: "%").result(binding))


__END__
# Quine Relay 151

**A 151-language quine relay, verified end to end on Ubuntu 26.04.**
It extends [Yusuke Endoh's Quine Relay](https://github.com/mame/quine-relay) (128 languages) with 23 more.
We could not find a longer working quine relay anywhere in public (November 2026).

## What this is

[QR.rb](QR.rb) is a <%= RunSteps[0].name %> program that generates
a <%= RunSteps[1].name %> program that generates
a <%= RunSteps[2].name %> program that generates
...(through <%= RunSteps.size %> languages in total)...
a <%= RunSteps[-1].name %> program that generates
the original <%= RunSteps[0].name %> code again.

![Language Uroboros][langs]

[langs]: langs.png

The languages in red are the 23 added in this fork. Everything in black is mame's original relay.

## Proof that it works

On November 13, 2026, the full relay ran in Docker on Ubuntu 26.04:

- **All <%= RunSteps.size %> steps ran on their real interpreters and compilers.** No step was skipped or faked.
- Step <%= RunSteps.size %> (<%= RunSteps[-1].name %>) printed `QR2.rb`, and it is byte-for-byte identical to `QR.rb`.
- `make check` passed. SHA-256 of both files:
  `<%= File.read("../SHA256SUMS")[/\h{64}/] rescue "see SHA256SUMS" %>`
- The lap took about 12 minutes once the image was built.

The full logs are in [`proof/`](proof/). You can check it yourself with the two Docker commands below.

## What's new in this fork

<%= RunSteps[1, 23].map {|s| s.name }.join(", ") %>.

They sit right after Ruby, at the start of the relay. [RELAY-151.md](RELAY-151.md) explains how each one was chosen and placed, and why order matters so much. (One wrong spot can blow a single step's output up to 16 MB.)

## Records

We claim records under two counting rules, and we publish the rules so anyone can compete under them.

- **Tier 1, distinct languages:** each language counts once, no matter how many versions or implementations run. This relay counts **143** under Tier 1 (mame's 128 counts 123).
- **Tier 2, relay steps:** steps counted the way mame counts them, with at most 3 implementations of one language. This relay counts **<%= RunSteps.size %>**.

See [RECORDS.md](RECORDS.md) for the full rules, how to verify a claim, and the leaderboard. [LANGUAGES.md](LANGUAGES.md) tags every step with its Tier 1 status.

## Usage

### Docker (easiest)

    $ docker build -t qr .
    $ docker run --rm qr

This installs every language, builds the bundled interpreters, runs all <%= RunSteps.size %> steps, and checks that the last file matches `QR.rb`.

### Ubuntu 26.04

#### 1. Install all the interpreters/compilers.

    $ <%= apt_get %>

Five languages have no Ubuntu package. Install them like this:

    $ sudo apt-get install python3-pip golang-go cargo
    $ pip install --break-system-packages coconut
    $ go install github.com/d5/tengo/v2/cmd/tengo@latest
    $ go install github.com/mattn/anko@latest
    $ cargo install rhai --features bin-features --bin rhai-run
    $ cargo install koto_cli

Then build the bundled interpreters.

    $ sudo apt-get install <%= other_packages.join(" ") %>
    $ make -C vendor

#### 2. Run each program on each interpreter/compiler.

    $ ulimit -s unlimited
% cmds.each do |cmd|
    $ <%= cmd %>
% end

You will see that `QR.rb` is the same as `QR2.rb`.

    $ diff QR.rb QR2.rb

Or just type `make`.

    $ make

Note: some files take a lot of memory to compile.

## Languages and packages

% rows.each do |row|
<%= row %>
% end

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

- **151 languages, Ubuntu 26.04 (Nov 2026).** Added: <%= RunSteps[1, 23].map {|s| s.name }.join(", ") %>.

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
