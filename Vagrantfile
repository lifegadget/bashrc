# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "parallels/ubuntu-14.04"
  config.vm.hostname = "bash"
  config.dns.tld = "dev" 
  config.dns.patterns = [/^bash.dev$/] 
  config.vm.network "private_network", type: "dhcp"
  config.vm.provision "shell", path: "VagrantProvisioning"

  config.vm.provider "parallels" do |v|
    # use a compact/susinct name for VM
    v.name = "simpleton"
    # Boot to headless mode
    # Update parallels tools if update available
    v.update_guest_tools = true
    # Opt for lower battery consumption over higher performance (http://kb.parallels.com/en/9607)
    v.optimize_power_consumption = false
    # Set memory and CPU availability
    v.memory = 1024
    v.cpus = 1
  end
    
end
