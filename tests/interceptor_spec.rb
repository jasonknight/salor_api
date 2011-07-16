require File.join(File.dirname(__FILE__), "../lib/salor_api.rb")
require File.join(File.dirname(__FILE__), "../tests/helpers.rb")
describe SalorApi::Interceptor do
  it "should have a list of classes it has been included in" do
    SalorApi::Interceptor.included_in.should be_kind_of(Array)
    SalorApi::Interceptor.included_in.should_not be_empty
    SalorApi::Interceptor.included_in.include?(Testy).should be_true
  end
  it 'should find all methods on a class defined as api_' do
    SalorApi::Interceptor.methods_of_interest.should be_kind_of(Array)
    SalorApi::Interceptor.methods_of_interest.first.include?(:api_method1).should be_true
  end
  it 'should define a proxy method without the api_' do
    SalorApi::Interceptor.api_methods.first.include?(:method1).should be_true
    t = Testy.new
    t.method1(3).should be_kind_of(Fixnum)
    t.method1(3).should == 3
  end
  it 'should alter args via SalorApi' do
    SalorApi.add(:testy_method1,'MyName') do |args|
      args[0] = args.first + 1
      args
    end
    t = Testy.new
    t.method1(3).should == 4
  end
end
