# Proof: full 151-step run, November 13, 2026

These are the logs from the run that backs the record in [RECORDS.md](../RECORDS.md).

- **Where:** Docker Desktop on our PC, using this repo's `Dockerfile` (Ubuntu 26.04).
- **Commands:** `docker build -t qr151 .` then `docker run --rm qr151`
- **Result:** all 151 steps ran on their real interpreters and compilers, with no stand-ins. Step 151 (REXX) printed `QR2.rb`, `diff` reported it identical to `QR.rb`, and `make check` passed.
- **SHA-256 of `QR.rb` and `QR2.rb`:** `67dd3929f2842512c5dcbe6958ab20d9c71eac5f386289f787f0d8ceb9433e32`
- **Time:** about 12 minutes for the run, after the image was built.

| File | What it is |
|---|---|
| `build.log` | Output of `docker build`: every package installed on Ubuntu 26.04 |
| `run.log` | Output of `docker run`: all 151 steps in order, ending with the `diff` and SHA-256 check |
| `RESULT.txt` | The pass line and finish time |

To repeat it, clone this repo and run the same two commands. The last lines of the run should read `Files QR.rb and QR2.rb are identical`.
