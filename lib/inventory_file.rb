require 'tempfile'

class InventoryFile
    def initialize(domain, environment)
        @hosts = []
        @domain = domain
        @environment = environment
    end

    def add_host(host)
        @hosts << host
    end

    def write_inventory_file
        file = Tempfile.new('hosts')
        @hosts.each do |host|
            file.write("#{host}.#{@environment}.#{@domain}\n")
        end
        file.close
        file.path
    end

    def write_localhost_inventory_file
        file = Tempfile.new('hosts')
        file.write('localhost ansible_connection=local')
        file.close
        file.path
    end
end