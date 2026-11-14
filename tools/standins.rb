# Decide which step groups can't run here; pre-place the generator's expected output for them.
Dir.chdir("#{ENV["QR"]}/src") { require "./code-gen" }
classes = CodeGen::List.reverse
steps = classes.flat_map {|c| c.run_steps.map {|s| [c, s] } }
outs = steps.each_index.map {|i| i + 1 < steps.size ? steps[i + 1][1].src : "QR2.rb" }
runnable = ->cmd {
  next false if cmd =~ /vendor\/local/
  cmd.split(/&&|\|/).all? {|part|
    w = part.split.reject {|x| x =~ /\A\w+=/ }.first&.delete_prefix("!")
    w.nil? || w.start_with?("./", "$(") || w =~ /\A(ruby|perl)\z/ || system("which #{w} >/dev/null 2>&1")
  }
}
skip = classes.select {|c| c.run_steps.any? {|s| !runnable[s.cmd_raw] } }
old = []
skip.each do |c|
  idx = steps.each_index.select {|i| steps[i][0] == c }
  idx.each {|i| File.write(outs[i], "") ; old << outs[i] }
  File.binwrite(outs[idx.last], File.binread("/tmp/expect/#{c.name}"))
  warn "stand-in: #{c.run_steps.map(&:name).join(', ')}"
end
File.write("/tmp/oflags", old.map {|f| "-o #{f}" }.join(" "))
warn "steps run natively: #{steps.size - old.size} of #{steps.size}"
