remove_file "README.rdoc"
create_file "README.md", "TODO: write an awesome README file"
create_file ".rbenv-vars"
create_file ".ruby-version", "2.1.0"

gem 'slim-rails'
gem 'thin'
gem 'neat'
gem 'rails_email_preview', '~> 0.2.19'
gem 'factory_girl_rails'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'zeus'
  gem 'guard-rspec', require: false
  gem 'rspec-nc', require: false
  gem 'pry-rails'
  gem 'faker'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem_group :test do
  gem 'shoulda-matchers'
end

run "bundle install"

generate "rspec:install"
comment_lines 'spec/spec_helper.rb', "require 'rspec/autorun'"
inject_into_file 'spec/spec_helper.rb', "\n  config.include FactoryGirl::Syntax::Methods\n", after: "config.order = \"random\"\n"

run "bundle binstubs guard"
run "guard init rspec"
gsub_file 'Guardfile', 'guard :rspec do', "guard :rspec, cmd: 'zeus rspec' do"

run "~/bin/ctags_for_ruby"

append_to_file '.rspec', "--format=doc\n--format=Nc"

append_to_file '.gitignore', '.rbenv-vars'
append_to_file '.gitignore', '.ruby-version'
append_to_file '.gitignore', '.tags'
append_to_file '.gitignore', '.gemtags'
append_to_file '.gitignore', '.tags_sorted_by_file'

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
