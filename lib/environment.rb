require 'yaml'

class Environment
    attr_reader :name
    attr_reader :domain
    
    def initialize(env_file)
        @environment = YAML.load(env_file.read)
        @name = File.basename(env_file.path, '.yml')
        @domain = @environment['network']['domain']
    end

    def create_inventory(inventory_file)
        @environment['machines'].each do |machine|
            inventory_file.add_host(machine[0])
        end
        inventory_file.write_inventory_file
    end

    def create_localhost_inventory(inventory_file)
        inventory_file.write_localhost_inventory_file
    end

    def create_playbook(playbook_file)
        @environment['machines'].each do |machine|
            playbook_file.add_roles(*machine)
        end
        playbook_file.write_playbook_file  
    end
end