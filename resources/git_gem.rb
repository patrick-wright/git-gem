resource_name :git_gem

default_action :install

# Full git path or github org/project
property :repo_url, String, name_property: true

# Git tag, branch or revision
property :git_ref, String, default: "master"

# Override gem name
property :gem_name, String

action :install do
  unless new_resource.repo_url.start_with?("http")
    new_resource.repo_url("https://github.com/#{repo_url}.git")
  end

  uri = URI.parse(new_resource.repo_url)
  repo_basename = ::File.basename(uri.path)
  repo_name = repo_basename.match(/(?<name>.*)\.git/)[:name]
  new_resource.gem_name(repo_name) unless new_resource.gem_name

  Chef::Log.debug("Building #{new_resource.gem_name} gem from source")

  gem_clone_path = ::File.join(Chef::Config[:file_cache_path], repo_name)
  gem_file_path  = ::File.join(gem_clone_path, "#{new_resource.gem_name}-*.gem")

  checkout_gem = Chef::Resource::Git.new(gem_clone_path, run_context)
  checkout_gem.repository(new_resource.repo_url)
  checkout_gem.revision(new_resource.git_ref)
  checkout_gem.run_action(:sync)

  build_gem = Chef::Resource::Execute.new("build-#{new_resource.gem_name}-gem", run_context)
  build_gem.cwd(gem_clone_path)
  build_gem.command(
    <<-EOH
rm #{gem_file_path}
#{::File.join(RbConfig::CONFIG['bindir'], 'gem')} build #{new_resource.gem_name}.gemspec
    EOH
  )
  build_gem.run_action(:run) if checkout_gem.updated?

  install_gem = Chef::Resource::ChefGem.new(new_resource.gem_name, run_context)
  install_gem.source(Dir.glob(gem_file_path).first)
  install_gem.run_action(:install) if build_gem.updated?
end
