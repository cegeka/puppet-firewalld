require 'puppet'

Puppet::Type.type(:firewalld_service).provide :firewall_cmd do
  desc "Interact with firewall-cmd"


  commands :firewall_cmd => 'firewall-cmd'

  # First arg should be the zone name
  def exec_firewall(*extra_args)
    args=[]
    args << '--permanent'
    args << '--zone'
    args << @resource[:zone]
    args << extra_args
    args.flatten!
    firewall_cmd(args)
  end

  def exists?
    exec_firewall('--list-services').split(" ").include?(@resource[:service])
  end

  def create
    self.debug("Adding new service to firewalld: #{@resource[:service]}")
    exec_firewall('--add-service', @resource[:service])
  end

  def destroy
    self.debug("Removing service from firewalld: #{@resource[:service]}")
    exec_firewall('--remove-service', @resource[:service])
  end

end
