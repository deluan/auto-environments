require 'spec_helper.rb'

describe PlaybookFileWriter do
    let(:playbook_file_writer) { PlaybookFileWriter.new('petshop.example.com', 'staging', '/path/to/ansible-proj/create.yml') }
    
    it 'should create the playbook file' do
        plays = [{'include' => '/path/to/ansible-proj/create.yml'},
                {
                    'name' => 'Configuring www.staging.petshop.example.com',
                    'hosts' => 'www',
                    'roles' => ['ruby19', 'passenger', 'nginx']
                }, {
                    'name' => 'Configuring db.staging.petshop.example.com',
                    'hosts' => 'db',
                    'roles' => ['mysql']
                }]
        playbook_file_writer.add_roles('www', ['ruby19'])
        playbook_file_writer.add_roles('www', ['passenger', 'nginx'])
        playbook_file_writer.add_roles('db', ['mysql'])

        Tempfile.any_instance.should_receive(:write).with(plays.to_yaml)
        playbook_file_writer.write_playbook_file
    end

    it 'should close the file after writing' do
        Tempfile.any_instance.should_receive(:close)
        playbook_file_writer.write_playbook_file
    end

    it 'should return the path of the temporary file that it created' do
        Tempfile.any_instance.stub(:path).and_return('tmp_path')
        playbook_file_writer.write_playbook_file.should == 'tmp_path'
    end
end