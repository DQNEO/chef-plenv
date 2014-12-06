log "Hello, Chef!"

%w{gcc make git nano}.each do |pkg|
  package pkg do
    action :install
  end
end
