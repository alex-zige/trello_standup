# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trello_standup/version'

Gem::Specification.new do |spec|
  spec.name          = "trello_standup"
  spec.version       = TrelloStandup::VERSION
  spec.authors       = ["Alex Li"]
  spec.email         = ["alex.zige@gmail.com"]
  spec.summary       = "A gem to pull trello actions to standup messages"
  spec.description   = "A gem to pull trello actions to standup messages"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.executables   = ['trello_standup']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.post_install_message = <<-EOF
  ___________             .__  .__             _________ __                    .___
\__    __________  ____ |  | |  |   ____    /   ______/  |______    ____   __| ___ ________
  |    |  \_  __ _/ __ \|  | |  |  /  _ \   \_____  \\   __\__  \  /    \ / __ |  |  \____ \
  |    |   |  | \\  ___/|  |_|  |_(  <_> )  /        \|  |  / __ \|   |  / /_/ |  |  |  |_> >
  |____|   |__|   \___  |____|____/\____/  /_______  /|__| (____  |___|  \____ |____/|   __/
                      \/                           \/           \/     \/     \/     |__|
 !    Thanks for installing Trello Standup Gem.
  EOF

  spec.add_dependency "ruby-trello"
  spec.add_dependency "launchy",     ">= 0.3.2" #A helper for launching cross-platform applications in a fire and forget manner

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "awesome_print"

end
