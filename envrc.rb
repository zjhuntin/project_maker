def check_for_envrc
  dir_contents = `ls -a .`.split
  if dir_contents.include? '.envrc'
    true
  else
    false
  end
end

def create_envrc
    `touch .envrc`
end

def add_to_envrc(language, version)
  language_additions = {:python => ["layout python ~/.pyenv/versions/#{version}/bin/python"],
                        :ruby => ["rvm use #{version}", "layout ruby", "PATH_add .direnv/bundler-bin"]}
  language_additions[language.to_sym].each do |line|
    `echo "#{line}" >> .envrc`
  end
end

command = ARGV.shift.downcase

case command
when 'new'
  if check_for_envrc == true
    puts "There is already an envrc file in this directory."
    puts "Please try delete the old file, or add to the exisiting file."
  end
  create_envrc
when 'add'
  if ARGV.length != 2
    puts "This is not the correct format for adding a new language. It is envrc <language> <version>."
  else
    language = ARGV.shift.downcase
    version = ARGV.shift.downcase
    add_to_envrc(language, version)
  end
when 'delete'
  `rm .envrc`
  `rm -r .direnv`
end

`direnv allow`
