source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in bullet_train-billing.gemspec.
gemspec

gem "sqlite3"

gem "sprockets-rails"

# We include this here because it's not a _direct_ dependency of this repo.
# Instead we expect the starter repo to have it installed, and to have declared
# an ApplicationHash model that we can then extend from.
# TODO: This is a little icky. Should we clean it up somehow?
gem "active_hash"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

gem "standardrb", "~> 1.0"
