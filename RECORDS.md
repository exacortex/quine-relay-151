# Quine Relay Records

These are the rules we use to count a quine relay, and the leaderboard for anyone who wants to beat it.
A record needs a public repo and a full run that anyone can repeat. A number alone doesn't count.

## Leaderboard

| Relay | Tier 1 (distinct languages) | Tier 2 (relay steps) | Verified | Date |
|---|---|---|---|---|
| [exacortex/quine-relay-151](https://github.com/exacortex/quine-relay-151) (this repo) | **143** | **151** | Docker, Ubuntu 26.04, zero stand-ins ([proof](proof/)) | 2026-11-13 |
| [mame/quine-relay](https://github.com/mame/quine-relay) | 123 | 128 | mame's CI, Ubuntu 26.04 | 2026 |

To add a relay, open a pull request that edits this table and links to your proof (see "How to claim a record" below).

## Tier 1: distinct languages

Each language counts once. A language counts only if it has its own name and its own grammar or spec.

- Implementations of the same language count once. (Guile, Chez and Chicken are all Scheme.)
- Versions of a language count once. (FORTRAN77 and Fortran90 are both Fortran.) Raku is the one exception: it was renamed from Perl 6 in 2019 and is its own language now.
- Encodings and word swaps of another language don't count. (Ook! is Brainfuck. JSFuck is JavaScript. WebAssembly binary and text are one language.)
- File formats that aren't programs don't count. (Gzip.)
- A language with its own name that compiles to another one *does* count. (TypeScript, CoffeeScript, Genie, Hy, Coconut, Racket.)

[LANGUAGES.md](LANGUAGES.md) shows how each of our 151 steps is counted, with the reason for every merge.

## Tier 2: relay steps

Steps are counted the way mame counts them, plus a limited number of extra implementations. Every step must:

1. Run on its **own interpreter or compiler**: a different program, not the same one with a different flag.
2. Have **its own source text**. Two steps can't run the same program.
3. Be **verified for real** (see below).
4. Stay within the **family cap**: at most 3 steps per language, counting the first one.

Not allowed: version-only copies (Python 3.12 and 3.13), the same binary twice, and steps that only pass the text along (cat, base64, a plain echo).

Bonus stat for Tier 2 claims: how many steps also meet mame's own rule (an Ubuntu package, or a small esolang bundled in `vendor/`). For this repo it is **146 of 151**. Koto, Coconut, Anko, Tengo and Rhai are installed from cargo, pip and Go instead.

## How to claim a record

A claim needs all of these:

1. **A public repo** with the seed program, a Dockerfile that installs every language, and a list of steps tagged T1 or T2 only (like [LANGUAGES.md](LANGUAGES.md)).
2. **A full run in Docker** with zero stand-ins. Every step runs on its real interpreter or compiler, in order, in one image.
3. **A closed loop.** The last step's output must be byte-for-byte identical to the seed. Publish the SHA-256 of both files.
4. **The logs** of the build and the run, committed to the repo.
5. **Credit** to Yusuke Endoh's Quine Relay if you build on it, with its MIT license kept as-is.

Anyone should be able to repeat the run with `docker build` and `docker run`. If they can't, the claim doesn't stand.

## Side records

These measure something other than length. Each one is open to anyone under the same proof rules.

| Record | mame's 128 | This repo (151) |
|---|---|---|
| Smallest seed per language | 106.8 bytes (13,664 B ÷ 128) | **98.5 bytes** (14,868 B ÷ 151) |
| Smallest seed for mame's exact 128 languages | 13,664 bytes | not attempted yet |
| Fastest full lap in Docker | not measured | about 12 minutes on our PC |
| Smallest peak file (the biggest file any step prints) | not measured | about 3 MB (dash) |
| Longest alphabetical relay | 128 (A to Z after Ruby) | not attempted yet |
| Every language mame ever used, in one lap (148) | 128 of 148 | not attempted yet |

## What's next

The next target is **256**, under both tiers. Results will go up here once they pass a full Docker run.
