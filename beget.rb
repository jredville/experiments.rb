class BaseClass
  def foo
    puts "hi from baseclass"
  end
end

module Begetter
  def self.included(obj)
    cls_name = obj.name + "Class"
    newobj = Object.const_set cls_name, Class.new(::BaseClass)
    newobj.send(:include, obj)
  end
    def bar
      puts "calling baz"
      baz
    end

    def initialize
      puts "module initialize"
    end
end

module Begetting
  include Begetter
  def baz
    puts "hi from begetting"
  end

  def qux
    puts "hi from qux"
  end
end

obj = BegettingClass.new

obj.foo
obj.bar
obj.qux
