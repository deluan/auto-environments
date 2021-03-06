require 'spec_helper.rb'

describe InventoryFileWriter do
    let(:inventory_file_writer) { InventoryFileWriter.new('petshop.example.com', 'staging') }

    describe '.write_inventory_file' do
        before do
            inventory_file_writer.add_host('www')
            inventory_file_writer.add_host('db')
        end
        
        it 'should create an ansible inventory file based on domain, environment, and host names' do
            Tempfile.any_instance.should_receive(:write).with("www.staging.petshop.example.com\n")
            Tempfile.any_instance.should_receive(:write).with("db.staging.petshop.example.com\n")
            inventory_file_writer.write_inventory_file
        end

        it 'should close the file after writing' do
            Tempfile.any_instance.should_receive(:close)
            inventory_file_writer.write_inventory_file
        end

        it 'should return the path of the temporary file that it created' do
            Tempfile.any_instance.stub(:path).and_return('tmp_path')
            inventory_file_writer.write_inventory_file.should == 'tmp_path'
        end
    end

    describe '.write_localhost_inventory_file' do
        it 'should create an ansible inventory file containing an entry for localhost only' do
            Tempfile.any_instance.should_receive(:write).with("localhost ansible_connection=local")
            inventory_file_writer.write_localhost_inventory_file
        end

        it 'should return the path of the temporary file that it created' do
            Tempfile.any_instance.stub(:path).and_return('tmp_path')
            inventory_file_writer.write_localhost_inventory_file.should == 'tmp_path'
        end
    end
end