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
            inventory_file.should_receive(:write_inventory_file).and_return('tmp_path')
            path = environment.create_inventory(inventory_file)
            path.should == 'tmp_path'
        end
    end

    describe '.create_localhost_inventory' do
        let(:inventory_file) { InventoryFile.new('petshop.example.com', 'staging') }
        
        it 'should create a localhost only inventory file' do
            inventory_file.should_receive(:write_localhost_inventory_file)
            environment.create_localhost_inventory(inventory_file)
        end

        it 'should create the inventory file and return the path' do
            inventory_file.should_receive(:write_localhost_inventory_file).and_return('tmp_path')
            path = environment.create_localhost_inventory(inventory_file)
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

    describe '.machine_names' do
        it 'should return a list of all the machines in the environment' do
            environment.machine_names.should == ['db', 'www']
        end
    end

    describe '.roles_for' do
        it 'should return a list of all the roles configured for the given machine' do
            environment.roles_for('www').should == ['common', 'ruby19', 'nginx', 'passenger']
            environment.roles_for('db').should == ['common', 'mysql']
        end

        it 'should return nil if the machine name is not valid' do
            environment.roles_for('invalid').should be_nil
        end
    end
end