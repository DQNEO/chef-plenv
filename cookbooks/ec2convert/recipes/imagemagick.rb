USER_NAME="vagrant"
GROUP_NAME="vagrant"
HOME_DIR="/home/vagrant"
IM_VERSION="6.9.0-0"
PERL_VERSION="5.18.1"

# sudo yum install libjpeg-turbo libjpeg-turbo-devel
%w{libjpeg-turbo libjpeg-turbo-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

# mkdir ~/src ~/local
directory "#{HOME_DIR}/src" do
  mode "0750"
  user  USER_NAME
  group  GROUP_NAME
  recursive true
end

directory "#{HOME_DIR}/local" do
  mode "0750"
  user  USER_NAME
  group  GROUP_NAME
  recursive true
end

# download imagemagick and extract it
execute "extract-ImageMagick" do
  user USER_NAME

  cwd "#{HOME_DIR}/src"
  command <<-EOH
    tar xvfz /vagrant/ImageMagick-#{IM_VERSION}.tar.gz
  EOH

  not_if { File.exist?("#{HOME_DIR}/src/ImageMagick-#{IM_VERSION}") }
  action :run
end

execute "jikken" do
  user "vagrant"
  command <<-EOH
    echo ==========
    which perl
    echo ==========
  EOH
  action :run
end

# install imagemagick
execute "install-ImageMagick" do
  user USER_NAME
  cwd "#{HOME_DIR}/src/ImageMagick-#{IM_VERSION}"

  command <<-EOH

    ./configure --prefix=#{HOME_DIR}/local --with-perl=#{HOME_DIR}/.plenv/shims/perl  --enable-shared --disable-openmp --disable-opencl --without-x

    make
    make install
  EOH

  #not_if { File.exist?("#{HOME_DIR}/local/bin/convert") }

  action :nothing
end
