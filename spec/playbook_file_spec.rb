require 'spec_helper.rb'

describe PlaybookFile do
    it 'should create the playbook file' do
        playbook_file = PlaybookFile.new('petshop.example.com', 'staging')
        play = {
            name: 'Provisioning www.staging.petshop.example.com',
            hosts: 'www.staging.petshop.example.com',
            roles: ['ruby19', 'passenger', 'nginx']
        }
        playbook_file.add_roles('www', ['ruby19'])
        playbook_file.add_roles('www', ['passenger', 'nginx'])

        File.any_instance.should_receive(:write).with(play.to_yaml)
        playbook_file.write_playbook_file.should be_a String
    end
end