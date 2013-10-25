require 'tempfile'
require 'yaml'

class PlaybookFile
    def initialize(domain, environment)
        @plays = []
        @domain = domain
        @environment = environment
        @machines = {}
    end

    def add_roles(machine, roles)
        @machines[machine] = [] unless @machines[machine]
        @machines[machine] += roles
    end

    def write_playbook_file
        file = Tempfile.new 'playbook.yml'
        @machines.each do |machine, roles|
            hostname = "#{machine}.#{@environment}.#{@domain}"
            play = {
                name: "Provisioning #{hostname}",
                hosts: hostname,
                roles: roles
            }
            file.write play.to_yaml
        end
        file.path
    end
end