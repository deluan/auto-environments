require 'spec_helper.rb'

describe Environment do
    before do
        @mock_env_file = double("file")
        content = "---\nmachines:\n  db:\n    - common\n    - mysql\n  www:\n    - common\n    - ruby19\n    - nginx\n    - passenger\nnetwork:\n  domain: petshop.example.com\n  public_hosts: www"
        @mock_env_file.stub(:read).and_return(content)
    end
    
    describe '.create_inventory' do
        let(:inventory_file) {InventoryFile.new 'petshop.example.com', 'staging'}

        let(:environment) {Environment.new @mock_env_file}
        
        it 'should add each machine to the inventory file' do
            inventory_file.should_receive(:add_host).with('db')
            inventory_file.should_receive(:add_host).with('www')
            environment.create_inventory inventory_file
        end

        it 'should create the inventory file and return the path' do
            inventory_file.should_receive(:write_hosts_file).and_return 'tmp_path'
            path = environment.create_inventory inventory_file
            path.should == 'tmp_path'
        end            
    end
end