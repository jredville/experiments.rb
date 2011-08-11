require 'rubygems'
require 'rspec'

class Info
  attr_accessor :nesting, :self
end

module M1
  $m1 = Info.new
  $m1.nesting = Module.nesting
  $m1.self = self
end

module M2
  module S1
    $m2s1 = Info.new
    $m2s1.nesting = Module.nesting
    $m2s1.self = self
    def self.foo
      $m2s1foo = Info.new
      $m2s1foo.nesting = Module.nesting
      $m2s1foo.self = self
    end
  end
end
M2::S1.foo

RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
end

shared_examples 'modules' do
  its(:nesting) { should == expected_nesting }
  its(:self) { should == described_class }
  it "module_eval \"self\"" do
    described_class.module_eval("self").should == described_class
  end
  it "module_eval { self }" do
    described_class.module_eval { self }.should == described_class
  end
  it "module_exec { self }" do
    described_class.module_exec { self }.should == described_class
  end
  it "module_eval \"Module.nesting\"" do
    described_class.module_eval("Module.nesting").should == [described_class]
  end
  it "module_eval { Module.nesting }" do
    described_class.module_eval { Module.nesting }.should == []
  end
  it "module_exec { Module.nesting }" do
    described_class.module_exec { Module.nesting }.should == []
  end
  it "eval \"Module.nesting\", binding" do
    bind = described_class.module_eval "binding"
    n = eval "Module.nesting", bind
    n.should == [described_class]
  end
end
describe M1 do
  it_has_behavior 'modules' do
    subject { $m1 }
    let(:expected_nesting) { [M1] }
  end
end

describe M2::S1 do
  it_has_behavior 'modules' do
    subject { $m2s1 }
    let(:expected_nesting) { [M2::S1, M2] }
  end
end

