# # encoding: utf-8

# Inspec test for recipe infinitytest::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/
#

describe package 'apache2' do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end

describe package 'nodejs' do
  it { should be_installed }
end

describe package 'node' do
  it { should be_installed }
end

descibe package 'httpd' do
  it {should_not be installed }
end






#apachectl -t -D DUMP_MODULES
