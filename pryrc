puts " ** In ~/.pryrc"

Pry.config.collision_warning = true

Pry.config.exception_handler = proc do |_output, _exception, pry_instance|
  pry_instance.run_command "wtf -c"
end

if defined?(PryByebug) || defined?(PryDebugger)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'bt', 'backtrace' if defined?(PryByebug)

  # Repeat last command with <Enter>
  Pry::Commands.command(/^$/, 'repeat last command') do
    pry_instance.run_command Pry.history.to_a.last
  end
end
