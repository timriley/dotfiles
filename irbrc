ARGV.concat ["--readline"]

require "irb/ext/save-history"
IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
