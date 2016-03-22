source 'https://supermarket.chef.io'

metadata

cookbook 'test', path: './test/fixtures/cookbooks/test'

group :integration do
  cookbook 'git', '~> 4.3'
  cookbook 'apt', '~> 3.0'
  cookbook 'yum', '~> 3.10'
end
