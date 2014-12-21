require 'spec_helper'


describe StackedConfig::Orchestrator do

  subject {
    os = StackedConfig::SourceHelper.os_flavour
    gem_path = File.expand_path '../..', __FILE__

    altered_sys_conf_root =  {}
    StackedConfig::SourceHelper::SYSTEM_CONFIG_ROOT.each_pair do |k,v|
      altered_sys_conf_root[k] = File.join gem_path, 'test', os.to_s, v
    end
    allow(StackedConfig::SourceHelper).to receive(:system_config_root) { altered_sys_conf_root[os] }
    allow(StackedConfig::SourceHelper).to receive(:user_config_root) { File.join gem_path, 'test', 'user' }

    StackedConfig::Orchestrator.new
  }

  it 'should have multiple layers' do
    expect(subject.layers.length > 0).to be_truthy
    # puts '#' * 80
    # puts subject.layers.to_yaml
    # puts '#' * 80
    # puts subject[].to_yaml
    # puts '#' * 80
    # puts subject.command_line_layer.help
  end

  context 'when setup by default, priorities should be defined in the Unix standard way' do

    it 'should have the system layer evaluated first' do
      expect(subject.system_layer).to be subject.to_a.first
    end

    it 'should have the global layer evaluated in second' do
      expect(subject.global_layer).to be subject.to_a[1]
    end

    it 'should have the user layer evaluated in third' do
      expect(subject.user_layer).to be subject.to_a[2]
    end

    it 'should have the writable layer evaluated last' do
      expect(subject.write_layer).to be subject.to_a.last
    end


  end




end