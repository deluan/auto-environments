require 'spec_helper.rb'

describe InventoryFile do
    it 'should create an ansible hosts file based on domain, environment, and host names' do
        inventory_file = InventoryFile.new('petshop.example.com', 'staging')
        inventory_file.add_hosts(['www'])
        inventory_file.add_hosts(['db', 'monitoring'])

        File.any_instance.should_receive(:write).with("www.staging.petshop.example.com\n")
        File.any_instance.should_receive(:write).with("db.staging.petshop.example.com\n")
        File.any_instance.should_receive(:write).with("monitoring.staging.petshop.example.com\n")
        inventory_file.write_hosts_file().should be_a String
    end
end