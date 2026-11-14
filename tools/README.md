# Tools

Helper scripts used while building the 151-language relay. The relay itself doesn't need them.

| File | What it does |
|---|---|
| `langs_png.py` | Draws `langs.png` with Python and pycairo, for machines without the Ruby cairo gem |
| `capture.rb` | Saves the exact input each step should get, so steps can be tested one at a time |
| `verify.sh` | Runs the new steps and checks each output against what the generator expects |
| `loop.rb` | Runs every step in order from the Makefile recipes |
| `standins.rb` | Marks which steps can't run on a machine (used before the full Docker run) |
| `proto.rb` | Quick prototypes of single-language templates |
| `new-languages-block*.rb` | The code added to `src/code-gen.rb`, kept on its own for reading |

Some scripts expect the paths of the machine they were written on. Read the top of each file before running it.
