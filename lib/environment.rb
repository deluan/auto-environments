require 'yaml'

class Environment
    attr_reader :name
    attr_reader :domain
    
    def initialize(env_file)
        @environment = YAML.load(env_file.read)
        @name = File.basename(env_file.path, '.yml')
        @domain = @environment['network']['domain']
    end

    def create_inventory(inventory_file_writer)
        @environment['machines'].each do |machine|
            inventory_file_writer.add_host(machine[0])
        end
        inventory_file_writer.write_inventory_file
    end

    def create_localhost_inventory(inventory_file_writer)
        inventory_file_writer.write_localhost_inventory_file
    end

    def create_playbook(playbook_file_writer)
        @environment['machines'].each do |machine|
            playbook_file_writer.add_roles(*machine)
        end
        playbook_file_writer.write_playbook_file  
    end

    def machine_names
        @environment['machines'].map { |machine| machine[0] }
    end

    def roles_for(machine_name)
        machine = @environment['machines'].find { |machine| machine[0] == machine_name }
        machine[1] if machine
    end
end