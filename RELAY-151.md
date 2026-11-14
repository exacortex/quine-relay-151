# Quine Relay — 151 languages

A fork of Yusuke Endoh's (mame) [Quine Relay](https://github.com/mame/quine-relay), extended from 128 to **151 languages**.
`QR.rb` is a Ruby program that prints a BASIC program, which prints a ChucK program, which prints a dash script … and after 151 languages you get back the exact original `QR.rb`.

## What's new

23 languages were added in three places:

```
Ruby -> BASIC -> ChucK -> dash -> groff -> Hy -> Jsonnet -> newLISP -> NQP -> PicoLisp
     -> Racket -> SQL (SQLite) -> xonsh -> mksh -> yash -> Elvish -> VHDL -> Genie
     -> XQuery -> Koto -> Coconut -> Anko -> Tengo -> Rhai -> Rust -> Scala -> ... -> REXX -> Ruby
```

| # | Language | Run with | Package |
|---|----------|----------|---------|
| 2 | BASIC (bwBASIC) | `bwbasic QR.bas > /dev/null; cat QR.out` | bwbasic |
| 3 | ChucK | `chuck --silent QR.ck` | chuck |
| 4 | dash | `dash QR.dash` | dash |
| 5 | groff (troff) | `groff -z QR.roff 2> out` (prints with `.tm1` to stderr) | groff |
| 6 | Hy | `hy QR.hy` | hy |
| 7 | Jsonnet | `jsonnet -S QR.jsonnet` | jsonnet |
| 8 | newLISP | `newlisp -n QR.nl` | newlisp |
| 9 | NQP | `nqp QR.nqp` | nqp |
| 10 | PicoLisp | `pil QR.l` | picolisp |
| 11 | Racket | `racket QR.rkt` | racket |
| 12 | SQL (SQLite) | `sqlite3 < QR.sql` | sqlite3 |
| 13 | xonsh | `xonsh --no-rc QR.xsh` | xonsh |
| 14 | mksh | `mksh QR.mksh` | mksh |
| 15 | yash | `yash QR.yash` | yash |
| 16 | Elvish | `elvish QR.elv` | elvish |
| 17 | VHDL | `ghdl -a QR.vhdl && ghdl -e qr && ghdl -r qr` | ghdl |
| 18 | Genie | `valac QR.genie.gs && ./QR.genie` | valac |
| 19 | XQuery | `basex QR.xq` | basex |
| 20 | Koto | `koto QR.koto` | `cargo install koto_cli` |
| 21 | Coconut | `coconut -q -r QR.coco` | `pip install coconut` |
| 22 | Anko | `anko QR.ank` | `go install github.com/mattn/anko` |
| 23 | Tengo | `tengo QR.tengo` | `go install github.com/d5/tengo/v2/cmd/tengo` |
| 24 | Rhai | `rhai-run QR.rhai` | `cargo install rhai --features bin-features --bin rhai-run` |

Steps 4–13 came in the 138 version. Racket and newLISP came from mame's unfinished `code-gen-pool.rb`; newLISP's template uses a `[text]...[/text]` block, since its `"..."` strings stop at 2048 characters.

### How the new ones were chosen and placed

- **No backslash doubling in the middle.** Most of the payload is mame's packed data, with few backslashes. But every layer that escapes `\` doubles all the backslashes of the layers outside it. dash already prints 3 MB. So the 11 languages between xonsh and Rust all use raw strings, verbatim strings or quote doubling, and leave backslashes alone.
- **Raw strings go where their closing mark can't show up.** Each program holds every later program inside it. So a language that can't escape its closing mark (Rhai's back-tick, Koto's `'#`, Coconut's `'''`, Genie's `"""`, XQuery's `]``) sits closer to Rust than any language that writes that mark. Each one has a `check()` that fails the build if that ever changes. Tengo and Anko splice each back-tick in as `"`"`.
- **ChucK and BASIC sit at the front.** ChucK strings need backslash escapes; right after Ruby, that only grows ChucK's own file. BASIC writes about 22,000 short `PRINT` lines; at the front, nothing has to escape them again. (In the middle they had pushed dash to 16 MB.)
- Small fixes: bwBASIC prints a banner on stdout, so the program writes `QR.out` and the step `cat`s it. Its lines are packed to at most 242 characters (its limit is 255). ChucK's `chout` only flushes at a newline, so the program flushes at the end. Genie's file is `QR.genie.gs`, because `QR.gs` is GolfScript's.

The changes are in `src/code-gen.rb` (two blocks: one just before `class Ruby_`, one between `class Rust` and `class Xonsh`) and `src/Dockerfile.gen.rb` (install lines for the five tools with no Ubuntu package). `QR.rb`, `Makefile`, `Dockerfile` and the CI workflow were regenerated from them. The 138 version also changed `src/code-gen-pool.rb`.

## How it was tested

1. The generator's built-in check (`run_check`) passed for all 151 steps.
2. The new segments (Ruby → … → Rust → Scala source, 24 steps) each printed exactly what the generator expects for that step.
3. **The full loop ran on Ubuntu 24.04:** 129 of 151 steps ran on real interpreters. Each step's output matched what the generator expects (a few differ only by a trailing newline, and F# by one trailing space, as in mame's version). **Step 151 (REXX) printed a `QR2.rb` identical to `QR.rb`** (SHA-256 `67dd3929…9433e32`).
4. 22 steps couldn't run on that machine and got the generator's expected output as a stand-in:
   - no package on Ubuntu 24.04: Swift, Fennel, Squirrel3
   - mame's bundled tools in `vendor/` were not built: Shakespeare, Velato, Befunge, Chef, Lazy K, LOLCODE, Piet. Each runs inside a group, so its group-mates were stood in too (Scilab, sed, S-Lang, Vala, BeanShell, BLC8, Brainfuck, C#, ksh, LiveScript, PHP)
   - no COIN-BC solver package: MiniZinc

   None of those steps were touched; they only see a different payload, and their per-language checks passed.

To run every step, use mame's Docker setup (Ubuntu 26.04):

```
docker build -t qr .
docker run --rm qr
```

## Notes

- `README.md`, `LANGUAGES.md`, `langs.png` and `thumbnail.png` are regenerated for 151 languages. `tools/langs_png.py` draws `langs.png` without the Ruby cairo gem.
- `SHA256SUMS` lists only `QR.rb`. Regenerate it after a full Docker run with `cd src && ruby SHA256SUMS.gen.rb`.
- Run times on a 2-core box: Coconut takes about 30 s (it compiles 1.2 MB to Python), ChucK about 12 s.
- Original work and copyright: Yusuke Endoh (@mametter) and contributors, MIT license.
