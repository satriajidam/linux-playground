nodes = [
  {
    hostname: 'playground-01',
    ip: '192.168.10.100',
    ram: 1024,
    box: 'bento/ubuntu-16.04'
  }
]

Vagrant.configure('2') do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |host|
      host.vm.box = node[:box]
      host.vm.box_check_update = true
      host.vm.hostname = node[:hostname]
      host.vm.network :private_network, ip: node[:ip], netmask: '255.255.255.0'
      host.vm.synced_folder './', '/vagrant'
      host.vm.provision 'shell', path: './host-setup.sh'

      memory ||= 512

      host.vm.provider :virtualbox do |vb|
        vb.name = node[:hostname]
        vb.customize [
          'modifyvm', :id,
          '--memory', memory.to_s
        ]
      end
    end

    config.hostmanager.enabled = true
    config.hostmanager.manage_guest = true
  end
end
