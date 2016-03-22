# git-gem cookbook

Provides the `git_gem` resource to install gem packages from Git source repos.

## Install a project from source
```ruby
git_gem "http://github.com/chef/chef.git"

# shorthand for github repos
git_gem "chef/chef"
```

## Install a project from a specific ref
```ruby
git_gem "chef/chef" do
  # branch, tag or revision
  git_ref "c3470696029d86dd5ca9eb4880f69c5d7261c6bd"
end
```

## Rename the gem
This will allow multiple versions of gem builds in the cache path.
```ruby
git_gem "chef/chef" do
  gem_name "chef-test1"
end
```

## Run dependencies if needed
```ruby
include_recipe "git-gem"
```
