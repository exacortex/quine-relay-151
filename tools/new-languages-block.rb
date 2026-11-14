# ---- Added past 128: ten languages between Ruby and Rust ----
# Run order: Ruby -> dash -> groff -> Hy -> Jsonnet -> newLISP -> NQP -> PicoLisp
#                 -> Racket -> SQL -> xonsh -> Rust
# Racket and newLISP were moved here from code-gen-pool.rb (newLISP's template was
# changed to a [text] block, since "..." strings are capped at 2048 chars).

class Xonsh < CodeGen
  Name = "xonsh"
  File = "QR.xsh"
  Cmd = "xonsh --no-rc QR.xsh > OUTFILE"
  Apt = "xonsh"
  Code = %q(%(print("#{e[PREV]}",end="")))
end

class SQL < CodeGen
  Name = "SQL (SQLite)"
  File = "QR.sql"
  Cmd = "sqlite3 < QR.sql > OUTFILE"
  Apt = "sqlite3"
  Code = %q(%(SELECT'#{d[PREV,?']}';))
end

class RacketLang < CodeGen
  Name = "Racket"
  File = "QR.rkt"
  Cmd = "racket QR.rkt > OUTFILE"
  Apt = "racket"
  Code = %q("#lang racket/base\n(display \"#{e[PREV]}\")")
end

class PicoLisp < CodeGen
  File = "QR.l"
  Cmd = "pil QR.l > OUTFILE"
  Apt = "picolisp"
  # backslash, double quote and ^ (control-char prefix) are escaped with a backslash
  Code = %q(%((prin "#{Q[PREV,/[\\\\"^]/]}")(bye)))
end

class NQP < CodeGen
  File = "QR.nqp"
  Cmd = "nqp QR.nqp > OUTFILE"
  Apt = "nqp"
  # single-quoted strings: only backslash and ' need escaping
  Code = %q(%(print('#{Q[PREV,/[\\\\']/]}')))
end

class NewLISPLang < CodeGen
  Name = "newLISP"
  File = "QR.nl"
  Cmd = "newlisp -n QR.nl > OUTFILE"
  Apt = "newlisp"
  Code = %q(%((print [text]#{PREV}[/text])(exit)))

  def check(prev)
    raise if prev.include?("[/text]") # it closes the raw text block
  end
end

class Jsonnet < CodeGen
  File = "QR.jsonnet"
  Cmd = "jsonnet -S QR.jsonnet > OUTFILE"
  Apt = "jsonnet"
  Code = %q(E[PREV])
end

class Hy < CodeGen
  File = "QR.hy"
  Cmd = "hy QR.hy > OUTFILE"
  Apt = "hy"
  Code = %q(%((print "#{e[PREV]}" :end "")))
end

class Groff < CodeGen
  Name = "groff"
  File = "QR.roff"
  Cmd = "groff -z QR.roff 2> OUTFILE"
  Apt = "groff"
  # .tm1 prints the rest of the line to stderr in copy mode, where \\ is a backslash
  Code = %q((PREV).lines.map{|l|".tm1 \""+l.chomp.gsub(B){B*2}+N}*"")
end

class Dash < CodeGen
  Name = "dash"
  File = "QR.dash"
  Cmd = "dash QR.dash > OUTFILE"
  Apt = "dash"
  Code = %q(%(printf %s '#{(PREV).gsub(?',%('"'"'))}'))

  def check(prev)
    raise if prev.include?("\0") # shell words cannot hold NUL
  end
end

