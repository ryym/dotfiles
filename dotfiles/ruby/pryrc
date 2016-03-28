# Configure Pry.
proc {

  # Alias
  {
    c: 'continue',
    n: 'next',
    s: 'step'
  }
  .each do |als, command|
    Pry.commands.alias_command als, command
  end

  # Prompt
  proc {|&prompter|
    Pry.config.prompt = [
      prompter.call('>'),
      prompter.call('*')
    ]
  }.call do |mark|
    proc {|target_self, nest_level, pry|
      versions = "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
      row_num  = pry.input_array.size
      place    = Pry.view_clip(target_self)
      nested   = nest_level.zero? ? '' : ":#{nest_level}"
      "#{versions} [#{row_num}] pry(#{place})#{nested}#{mark}"
    }
  end

  # Editor
  Pry.editor = 'vim'

}.call
