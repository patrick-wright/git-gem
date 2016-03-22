describe command("/opt/chef/embedded/bin/chef-acceptance generate foo") do
  its(:exit_status) { should eq 0 }
end

describe command("sudo /opt/chef/embedded/bin/chef-acceptance test foo") do
  its(:exit_status) { should eq 0 }
end
