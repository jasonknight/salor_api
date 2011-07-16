class Testy
  def api_method1(args)
    return args.first
  end
  def method(x,y)
    return [x,y]
  end
  include SalorApi::Interceptor
end
