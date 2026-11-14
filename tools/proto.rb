s = File.binread(ARGV[0])
e = ->x{ x.gsub(/[\\"]/){"\\"+$&}.gsub("\n","\\n") }
T = {
 "sql"   => ["QR.sql",   "sqlite3 < QR.sql",  "SELECT '#{s.gsub("'","''")}';"],
 "pil"   => ["QR.l",     "pil QR.l",           %((prin "#{s.gsub(/[\\"^]/){"\\"+$&}}")(bye))],
 "jsonnet"=>["QR.jsonnet","jsonnet -S QR.jsonnet", %("#{e[s]}")],
 "hy"    => ["QR.hy",    "hy QR.hy",           %((print "#{e[s]}" :end ""))],
 "groff" => ["QR.roff",  "groff -z QR.roff 2>&1 >/dev/null", s.lines.map{|l| %(.tm1 "#{l.chomp.gsub("\\","\\\\\\\\")}\n)}.join],
 "dash"  => ["QR.dash",  "dash QR.dash",       %(printf %s '#{s.gsub("'",%('"'"'))}')],
}
T.each do |k,(f,cmd,src)|
  File.binwrite(f,src)
  t=Time.now; out=`#{cmd} </dev/null`
  ok = out==s ? "EXACT" : out.chomp==s.chomp ? "ok(nl)" : "FAIL(#{out.size} vs #{s.size})"
  puts "#{k}: #{ok} #{(Time.now-t).round(1)}s"
end
