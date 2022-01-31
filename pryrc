# == Pry-Nav - Using pry as a debugger ==
Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil
Pry.commands.alias_command '@', 'whereami' rescue nil

# == PLUGINS ===
# awesome_print gem: great syntax colorized printing
# look at ~/.aprc for more settings for awesome_print
begin
  require 'awesome_print'
  # The following line enables awesome_print for all pry output,
  # and it also enables paging
  Pry.config.print = proc { |output, value|
    formatted = value.ai
    value.ai.split("\n").each_with_index do |v, i|
      prefix = (i == 0) ? "=>" : '. '
      output.puts "#{BLACK}#{prefix}#{WHITE} #{v}"
    end
    # output.puts formatted
    # Pry::Helpers::BaseHelpers.stagger_output("#{BLACK}=>#{WHITE} #{value.ai}", output)
  }

  # If you want awesome_print without automatic pagination, use the line below
  # Pry.config.print = proc { |output, value| output.puts value.ai }
rescue LoadError => err
  puts "gem install awesome_print  # <-- highly recommended"
end
