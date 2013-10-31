require 'spec_helper.rb'

describe Environment do
    before do
        @mock_env_file = double("file")
        content = "---\nmachines:\n  db:\n    - common\n    - mysql\n  www:\n    - common\n    - ruby19\n    - nginx\n    - passenger\nnetwork:\n  domain: petshop.example.com\n  public_hosts: www"
        @mock_env_file.stub(:read).and_return(content)
        @mock_env_file.stub(:path).and_return('temp/staging.yml')
    end
    
    let(:environment) { Environment.new(@mock_env_file) }
    
    describe '.create_inventory' do
        let(:inventory_file) { InventoryFile.new('petshop.example.com', 'staging') }
        
        it 'should add each machine to the inventory file' do
            inventory_file.should_receive(:add_host).with('db')
            inventory_file.should_receive(:add_host).with('www')
            environment.create_inventory(inventory_file)
        end

        it 'should create the inventory file and return the path' do
            inventory_file.should_receive(:write_hosts_file).and_return('tmp_path')
            path = environment.create_inventory(inventory_file)
            path.should == 'tmp_path'
        end            
    end

    describe '.create_playbook' do
        let(:playbook_file) { PlaybookFile.new('petshop.example.com', 'staging', '/something/include.yml') }

        it 'should add the roles for each machine to the playbook' do
            playbook_file.should_receive(:add_roles).with('db', ['common', 'mysql'])
            playbook_file.should_receive(:add_roles).with('www', ['common', 'ruby19', 'nginx', 'passenger'])
            environment.create_playbook(playbook_file)
        end
    end

    describe '.domain' do
        it 'should return the domain' do
            environment.domain.should == 'petshop.example.com'
        end
    end

    describe '.name' do
        it 'should return the name of the environment based on the file name' do
            environment.name.should == 'staging'
        end
    end
end