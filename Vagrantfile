Vagrant.configure(2) do |config|

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end


  config.vm.define "db" do |db|

    db.vm.box = "ubuntu/xenial64"
    db.vm.network :private_network, ip: "192.168.56.20" 
    db.vm.provision :shell, path: "db/db.sh"
    db.vm.synced_folder "db/", "/db"
 
    db.vm.provider :virtualbox do |v|
      v.name = "db"
    end

  end


  config.vm.define "web" do |web|

    web.vm.box = "ubuntu/xenial64"
    web.vm.network :private_network, ip: "192.168.56.10" 
    web.vm.provision :shell, path: "web/web.sh"
    web.vm.synced_folder "web/", "/web"

    web.vm.provider :virtualbox do |v|
      v.name = "web"
    end

  end

end
