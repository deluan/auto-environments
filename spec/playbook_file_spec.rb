require 'spec_helper.rb'

describe PlaybookFile do
    before do
        @playbook_file = PlaybookFile.new 'petshop.example.com', 'staging'
    end
    
    it 'should create the playbook file' do
        play = {
            name: 'Provisioning www.staging.petshop.example.com',
            hosts: 'www.staging.petshop.example.com',
            roles: ['ruby19', 'passenger', 'nginx']
        }
        @playbook_file.add_roles('www', ['ruby19'])
        @playbook_file.add_roles('www', ['passenger', 'nginx'])

        Tempfile.any_instance.should_receive(:write).with(play.to_yaml)
        @playbook_file.write_playbook_file
    end

    it 'should close the file after writing' do
        Tempfile.any_instance.should_receive(:close)
        @playbook_file.write_playbook_file
    end

    it 'should return the path of the temporary file that it created' do
        Tempfile.any_instance.stub(:path).and_return('tmp_path')
        @playbook_file.write_playbook_file.should == 'tmp_path'
    end
end