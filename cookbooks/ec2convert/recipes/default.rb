USER_NAME="vagrant"
GROUP_NAME="vagrant"
HOME_DIR="/home/vagrant"
PERL_VERSION="5.18.1"

git "#{HOME_DIR}/.plenv" do
  user  USER_NAME
  group  GROUP_NAME
  repository "git://github.com/tokuhirom/plenv.git"
  reference "master"
end


directory "#{HOME_DIR}/.plenv/plugins/perl-build" do
  mode "0755"
  user  USER_NAME
  group  GROUP_NAME
  recursive true
end

git "#{HOME_DIR}/.plenv/plugins/perl-build" do
  user  USER_NAME
  group  GROUP_NAME
  repository "git://github.com/tokuhirom/Perl-Build.git"
  reference "master"
end

execute "setup-bashrc" do
  user USER_NAME
  command <<-EOH
        echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> #{HOME_DIR}/.bashrc
        echo 'eval "$(plenv init -)"' >> #{HOME_DIR}/.bashrc
  EOH
  not_if "grep plenv #{HOME_DIR}/.bashrc"
  action :run
end

bash "plenv setup and setup perl" do
  user  USER_NAME
  group  GROUP_NAME

  environment 'HOME' => "#{HOME_DIR}"
  code <<-EOC
        #{HOME_DIR}/.plenv/bin/plenv rehash
        #{HOME_DIR}/.plenv/plugins/perl-build/bin/plenv-install #{PERL_VERSION}
        #{HOME_DIR}/.plenv/bin/plenv global #{PERL_VERSION}
        #{HOME_DIR}/.plenv/bin/plenv rehash
        #{HOME_DIR}/.plenv/bin/plenv install-cpanm
        #{HOME_DIR}/.plenv/bin/plenv rehash
   EOC
  not_if { File.exist?("#{HOME_DIR}/.plenv/shims/perl5.18.1 ") }
  action :run
end

bash "install cpan modules" do
  user  USER_NAME
  group  GROUP_NAME

  environment 'HOME' => "#{HOME_DIR}"
  code <<-EOC
        #{HOME_DIR}/.plenv/bin/plenv global #{PERL_VERSION}
        #{HOME_DIR}/.plenv/bin/plenv rehash
        #{HOME_DIR}/.plenv/shims/cpanm Acme::Nyaa
   EOC
  action :run
end
