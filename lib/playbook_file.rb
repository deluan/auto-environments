require 'tempfile'
require 'yaml'

class PlaybookFile
    def initialize(domain, environment, include_path)
        @plays = []
        @domain = domain
        @environment = environment
        @include_path = include_path
        @machines = {}
    end

    def add_roles(machine, roles)
        @machines[machine] = [] unless @machines[machine]
        @machines[machine] += roles
    end

    def write_playbook_file
        file = Tempfile.new('playbook.yml')
        plays = [{'include' => @include_path}]

        @machines.each do |machine, roles|
            hostname = "#{machine}.#{@environment}.#{@domain}"
            plays << {
                'name' => "Provisioning #{hostname}",
                'hosts' => machine,
                'roles' => roles
            }
        end
        file.write(plays.to_yaml)
        file.close
        file.path
    end
end