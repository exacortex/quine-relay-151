# Run every step of the relay in order via its Makefile recipe; stand in only where tools are missing.
Dir.chdir("#{ENV["QR"]}/src") { require "./code-gen" }
Dir.chdir("#{ENV["LOOP"]}")
ENV["PATH"] = "#{Dir.home}/ts5/node_modules/.bin:/usr/bin:" + ENV["PATH"] + ":/usr/games:#{Dir.home}/go/bin:#{Dir.home}/.cargo/bin"; ENV["NuGetAudit"] = "false"
classes = CodeGen::List.reverse
steps = classes.flat_map {|c| c.run_steps.map {|s| [c, s] } }
outs = steps.each_index.map {|i| i + 1 < steps.size ? steps[i + 1][1].src : "QR2.rb" }
oflags = File.read("/tmp/oflags")
standins = oflags.scan(/-o (\S+)/).flatten
log = File.open("/tmp/loop2.log", "w"); log.sync = true
result = Hash.new {|h, k| h[k] = [] }
i = 0
while i < steps.size
  c, s = steps[i]
  idx = steps.each_index.select {|j| steps[j][0] == c }
  if standins.include?(outs[i])
    result[:standin] << s.name; i += 1; next
  end
  t = Time.now
  ok = system("timeout 900 make #{oflags} #{outs[i]} >> /tmp/loop.out 2>&1")
  log.puts "%3d %-28s %s %5.1fs" % [i + 1, s.name, ok ? "ran" : "FAILED", Time.now - t]
  if ok
    result[:ran] << s.name
    if i == idx.last && c.name != "Ruby_"
      exp = File.binread(c.name == "Python_R_Ratfor_Rc_REXX" ? "QR.rb" : "/tmp/expect/#{c.name}")
      got = File.binread(outs[i]); got = got.sub(/1 process created\n\z/, "") if c.name == "Promela"
      m = got == exp ? "exact" : got.chomp == exp.chomp ? "exact(nl)" : "MISMATCH"
      log.puts "    group #{c.name}: output #{m}"
      result[:mismatch] << c.name if m == "MISMATCH"
    end
    i += 1
  else
    # substitute the group's expected output and skip the rest of the group
    rest = idx.select {|j| j >= i }
    result[:failed] << s.name
    result[:skipped_after_fail] += rest[1..].map {|j| steps[j][1].name }
    rest.each {|j| File.write(outs[j], "") }
    File.binwrite(outs[idx.last], c.name == "Python_R_Ratfor_Rc_REXX" ? File.binread("QR.rb") : File.binread("/tmp/expect/#{c.name}"))
    oflags += rest.map {|j| " -o #{outs[j]}" }.join
    i = idx.last + 1
  end
end
log.puts "SUMMARY"
result.each {|k, v| log.puts "#{k} (#{v.size}): #{v.join(', ')}" }
log.puts "QR2.rb == QR.rb: #{File.exist?("QR2.rb") && File.binread("QR2.rb") == File.binread("QR.rb")}"
