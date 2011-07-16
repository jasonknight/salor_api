require File.join(File.dirname(__FILE__), "../lib/salor_api.rb")
describe SalorApi do
  it 'should start with an empty hash of callbacks' do
    SalorApi.callbacks.should be_a_kind_of(Hash)
  end
  it 'should start with am empty hash of basic actions' do
    SalorApi.actions.should be_a_kind_of(Hash)
  end
  it 'should allow you to add a callback block to callbacks' do
    SalorApi.add(:test,'my name') do
      puts "This is a block"
    end
  end
  it 'should allow you to remove all callbacks' do
    SalorApi.remove_all
    SalorApi.callbacks.should be_empty
  end
  it 'should call all blocks defined when passed an action' do
    SalorApi.add(:test,'my name') do
      puts "This is a block"
    end
    $stdout.should_receive(:write).at_least(1).times
    SalorApi.run(:test,nil)
    SalorApi.remove_all
  end
  it 'should allow variable arguments to action calls' do
    SalorApi.remove_all
    SalorApi.add(:test,'another name') do |args|
      puts "Arg received: " + args.first
    end
    $stdout.should_receive(:write).at_least(1).times
    SalorApi.run(:test,['Hello World'])
  end
  it 'should allow you to check if it has a named callback' do
    SalorApi.has_callback(:test,'another name').should be_true
  end
  it 'should allow you to remove a callback by name' do
  	SalorApi.add(:test,'ToRemove') do
  	  puts "I shouldn't be here!"
  	end
  	SalorApi.remove(:test,'ToRemove').should be_true
  	SalorApi.has_callback(:test,'ToRemove').should be_false
  end
  it 'should call multiple callbacks' do
    SalorApi.add(:test2,'CB1') do
      puts "This is CB1"
    end
    SalorApi.add(:test2,'CB2') do
      puts "This is CB2"
    end
    $stdout.should_receive(:write).at_least(2).times
    SalorApi.run(:test2,[])
  end
end
