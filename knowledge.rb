class Module
  def attribute(arg, default = nil, &block)
    if arg.class != Hash
      make_attribute(arg, default, &block)
    else
      arg.each { |key, value| make_attribute(key, value) }
    end
  end
  
  def make_attribute(arg, default, &block)
    #setter
    class_eval "def #{ arg }=(value); @#{ arg } = value; end"
    #query
    class_eval "def #{ arg }?; !@#{ arg }.nil?; end"
    #getter
    define_method(arg) do      
      return instance_variable_get("@#{ arg }") if send("#{ arg }?")
      block_given? ? send("#{ arg }=", instance_eval(&block)) : send("#{ arg }=", default)
    end
  end
end
