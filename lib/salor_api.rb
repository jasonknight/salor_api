module SalorApi
  VERSION = "0.0.1"
  # Callbacks are blocks you pass in that get executed
  def self.callbacks
    @@_callbacks ||= {}
  end
  def self.actions
    @@_actions ||= {}
  end
  # SalorApi.add(:testy_method1,'MyName') do |args|
  #    args[0] = args.first + 1
  #    args
  #  end
  def self.add(action,name,&block)
    @@_callbacks[action] ||= []
    @@_callbacks[action] << [name,block]
  end
  def self.run(action,args)
    self.callbacks[action].each {|cb| args = cb[1].call(args) } if self.callbacks[action]
    return args
  end
  def self.has_callback(action,name)
    @@_callbacks[action].each {|cb| return true if cb[0] == name }
    return false
  end
  def self.remove(action,name)
    if self.has_callback(action,name) then
      nc = []
      @@_callbacks[action].each {|cb| nc << cb if not cb[0] == name }
      @@_callbacks[action] = nc
      return true
    else
      return false
    end
  end
  def self.remove_all
    @@_callbacks = {}
  end
  # This is the interceptor class
  module Interceptor
    def self.included(base)
      self.included_in << base
      self._get_methods_of_interest(base)
    end
    def self.included_in
      @@_included_in_classes ||=[]
    end
    def self.methods_of_interest
      @@_methods_of_interest ||= []
    end
    def self._get_methods_of_interest(base)
      @@_methods_of_interest ||= []
      base.instance_methods(false).each do |m|
        if m.to_s.match(/^api_/) then
          @@_methods_of_interest << [base,m]
          new_method_name = m.to_s.gsub('api_','').to_sym
          self._define_proxy_method(base,new_method_name,m)
        end
      end
    end
    def self.api_methods
      @@_api_methods ||= []
    end
    def self._define_proxy_method(base,name,orig_name)
      @@_api_methods ||= []
      @@_api_methods << [base,name]
      base.send(:define_method,name) do |*args|
        n = __method__
        action = "#{self.class.to_s.downcase}_#{n}".to_sym
        if SalorApi.callbacks[action] then
          args = SalorApi.run(action,args)
        end
        return send(orig_name,args)
      end
    end
  end
end
