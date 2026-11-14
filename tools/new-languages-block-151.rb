# ---- Added past 138: eleven languages between xonsh and Rust ----
# Run order: xonsh -> mksh -> yash -> Elvish -> VHDL -> Genie -> XQuery
#                  -> Koto -> Coconut -> Anko -> Tengo -> Rhai -> Rust
# All thirteen use raw/verbatim strings or quote-doubling, so none of them doubles
# backslashes (each doubling layer would double the size of every earlier step).
# Every source nests all later ones, so a raw-string step is placed only before
# steps that never emit its closing delimiter; each check() guards that.

class Rhai < CodeGen
  File = "QR.rhai"
  Cmd = "rhai-run QR.rhai > OUTFILE"
  Apt = [nil] # cargo install rhai --features bin-features --bin rhai-run
  # back-tick strings take no escapes; print appends a newline (harmless for Rust)
  Code = %q(%(print(`#{PREV}`);))

  def check(prev)
    raise if prev.include?("`") || prev.include?("${")
  end
end

class Tengo < CodeGen
  File = "QR.tengo"
  Cmd = "tengo QR.tengo > OUTFILE"
  Apt = [nil] # go install github.com/d5/tengo/v2/cmd/tengo
  # raw back-tick string; each back-tick is spliced in as "`"
  Code = %q(%(fmt:=import("fmt");fmt.print(`#{(PREV).gsub("`",%(`+"`"+`))}`)))
end

class Anko < CodeGen
  File = "QR.ank"
  Cmd = "anko QR.ank > OUTFILE"
  Apt = [nil] # go install github.com/mattn/anko
  Code = %q(%(fmt=import("fmt");fmt.Print(`#{(PREV).gsub("`",%(`+"`"+`))}`)))
end

class Coconut < CodeGen
  File = "QR.coco"
  Cmd = "coconut -q -r QR.coco > OUTFILE"
  Apt = [nil] # pip install coconut
  Code = %q(%(print(r'''#{PREV}''',end="")))

  def check(prev)
    raise if prev.include?("'''") || prev.end_with?("'") || prev.end_with?("\\")
  end
end

class Koto < CodeGen
  File = "QR.koto"
  Cmd = "koto QR.koto > OUTFILE"
  Apt = [nil] # cargo install koto_cli
  Code = %q(%(io.stdout().write r#'#{PREV}'#))

  def check(prev)
    raise if prev.include?("'#")
  end
end

class XQuery < CodeGen
  File = "QR.xq"
  Cmd = "basex QR.xq > OUTFILE"
  Apt = "basex"
  # XQuery 3.1 string constructor: raw except for "]``" and "`{"
  Code = %q(%(``[#{PREV}]``))

  def check(prev)
    raise if prev.include?("]``") || prev.include?("`{")
  end
end

class Genie < CodeGen
  File = "QR.genie.gs" # valac needs .gs for Genie; QR.gs is GolfScript's
  Cmd = "valac QR.genie.gs && ./QR.genie > OUTFILE"
  Apt = "valac"
  # verbatim """...""" string
  Code = %q(%(init\n\tstdout.printf("%s","""#{PREV}""")\n))

  def check(prev)
    raise if prev.include?('"""') || prev.end_with?('"')
  end
end

class VHDL < CodeGen
  File = "QR.vhdl"
  Cmd = "ghdl -a QR.vhdl && ghdl -e qr && ghdl -r qr > OUTFILE"
  Apt = "ghdl"
  # "" for a quote; control characters are spliced in with character'val
  Code = %q(%(use std.textio.all;entity QR is end;architecture A of QR is begin process begin write(output,"#{(PREV).gsub(?",%("")).gsub(/[\x00-\x1f\x7f]/){%("&character'val(#{$&.ord})&")}}");wait;end process;end;))
end

class Elvish < CodeGen
  File = "QR.elv"
  Cmd = "elvish QR.elv > OUTFILE"
  Apt = "elvish"
  Code = %q(%(print '#{(PREV).gsub(?',%(''))}'))
end

class Yash < CodeGen
  Name = "yash"
  File = "QR.yash"
  Cmd = "yash QR.yash > OUTFILE"
  Apt = "yash"
  Code = %q(%(printf %s '#{(PREV).gsub(?',%('"'"'))}'))

  def check(prev)
    raise if prev.include?("\0")
  end
end

class Mksh < CodeGen
  Name = "mksh"
  File = "QR.mksh"
  Cmd = "mksh QR.mksh > OUTFILE"
  Apt = "mksh"
  Code = %q(%(print -nr -- '#{(PREV).gsub(?',%('"'"'))}'))

  def check(prev)
    raise if prev.include?("\0")
  end
end

# ---- Added past 138: Ruby -> BASIC -> ChucK -> dash ----
# ChucK strings need backslash escapes. A doubling layer here grows only its own
# file; anywhere later it would double every earlier step too.
class ChucK < CodeGen
  File = "QR.ck"
  Cmd = "chuck --silent QR.ck > OUTFILE"
  Apt = "chuck"
  # chout flushes only at a newline, so flush at the end
  Code = %q(%(chout <= "#{e[PREV]}";chout.flush();))
end

class BwBASIC < CodeGen
  Name = "BASIC (bwBASIC)"
  File = "QR.bas"
  Cmd = "bwbasic QR.bas > /dev/null; cat QR.out > OUTFILE"
  Apt = "bwbasic"
  # runs right after Ruby, so its source is never escaped again
  # the banner goes to stdout, so the program writes QR.out; lines are packed to
  # at most 242 chars (bwBASIC's limit is 255)
  Code = %q(%(Q$=CHR$(34)\nOPEN "O",#1,"QR.out"\n#{(PREV).chars.inject([""]){|a,c|x=c==?" ? %(";Q$;") : c==N ? %(";CHR$(10);") : c;a[-1].size+x.size>230&&a<<"";a[-1]<<x;a}.map{|l|%(PRINT #1,"#{l}";\n)}*""}CLOSE #1\nSYSTEM\n))

  def check(prev)
    raise if prev =~ /[\x00-\x09\x0b-\x1f]/ # only newline is spliced in
  end
end

