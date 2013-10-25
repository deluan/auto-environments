require 'yaml'

class Environment
    def initialize(env_file)
        @environment = YAML.load env_file.read
    end

    def create_inventory(inventory_file)
        @environment["machines"].each do |machine|
            inventory_file.add_host(machine[0])
        end
        inventory_file.write_hosts_file
    end

    def create_playbook(playbook_file)
        @environment["machines"].each do |machine|
            playbook_file.add_roles(*machine)
        end
        playbook_file.write_playbook_file        
    end
end