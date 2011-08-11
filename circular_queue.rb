require 'rubygems'
require 'rspec'

class Node
  def <<(val)
    @value = val
  end

  def has_value?
    !@value.nil?
  end

  def value
    @value
  end

  def clear
    @value = nil
  end
end

class CircularQueue
  attr_reader :capacity
  def initialize(cap = 5)
    @capacity = cap
    @ret = 0
    @add = 0
    @store = Array.new(@capacity) { Node.new }
  end

  def size
    if @add <= @ret && @store[@ret].has_value?
      (@add + @capacity) - @ret
    else
      @add - @ret
    end
  end
  
  def increment(val)
    return (val + 1) % @capacity
  end

  def enqueue(el)
    if size < capacity
      @store[@add] << el
      @add = increment(@add)
    else
      raise "too many items"
    end
  end

  def dequeue
    res = @store[@ret].value
    @store[@ret].clear
    @ret = increment(@ret)
    res
  end

  def to_s
    "(#@capacity)#{@store.inspect}"
  end
end
describe Node do
  let(:empty) { subject }
  let(:not_empty) { v = Node.new; v << 1; v }

  describe "#value " do
    it "should be nil for empty" do
       empty.value.should be_nil 
    end
    it "should not be nil for non-empty" do
      not_empty.value.should == 1 
    end
    it "changes for empty" do
      expect { empty << 1 }.to change { empty.value }.from(nil).to(1) 
    end
    it "changes for non-empty" do
      expect { not_empty << 2 }.to change { not_empty.value }.from(1).to(2) 
    end
  end

  describe "#has_value?" do
    it "is false for empty" do
      empty.should_not have_value 
    end
    it "is true for non-empty" do
      not_empty.should have_value
    end
    it "changes for empty << 1" do
      expect { empty << 1 }.to change { empty.has_value? }.from(false).to(true)
    end
    it "doesn't change for empty << nil" do
      expect { empty << nil }.to_not change { empty.has_value? }
    end
    it "doesn't change for non-empty << 2" do
      expect { not_empty << 2 }.to_not change { not_empty.has_value? }
    end
    it "changes for non-empyt << nil" do
      expect { not_empty << nil }.to change { not_empty.has_value? }.from(true).to(false)
    end
  end

  describe "#clear" do
    it "doesn't change for empty" do
      expect { empty.clear }.to_not change { empty.value }
    end
    it "changes non-empty" do
      expect { not_empty.clear }.to change { not_empty.value }.from(1).to(nil)
    end
    it "sets empty.value to nil" do
      empty.clear
      empty.value.should be_nil
    end
    it "sets non-empty.value to nil" do
      not_empty.clear
      not_empty.value.should be_nil
    end
  end
end
describe CircularQueue do
  let(:empty) { subject }
  let(:not_empty) do 
    v = CircularQueue.new
    v.enqueue 1
    v.enqueue 2
    v.enqueue 3
    v
  end
  let(:not_empty_mod) do
    v = CircularQueue.new
    v.enqueue 1
    v.enqueue 2
    v.enqueue 3
    v.dequeue
    v
  end
  let(:not_empty_mod2) do
    v = CircularQueue.new
    v.enqueue 1
    v.enqueue 2
    v.enqueue 3
    v.enqueue 4
    v.enqueue 5
    #add at 0, ret at 0
    v.dequeue
    v.dequeue
    v.dequeue
    #add at 0, ret at 3
    v.enqueue 6
    #add at 1, ret at 3
    v
  end
  let(:full) do
    v = CircularQueue.new
    v.enqueue 1
    v.enqueue 2
    v.enqueue 3
    v.enqueue 4
    v.enqueue 5
    v
  end
  let(:full2) do
    v = CircularQueue.new
    v.enqueue 1
    v.enqueue 2
    v.enqueue 3
    v.enqueue 4
    v.enqueue 5
    v.dequeue
    v.enqueue 6
    v
  end

  context "when first created" do
    its(:capacity) { should == 5 }
    its(:size) { should == 0 }
  end

  describe "#size" do
    it "should be 0 for empty" do
      empty.size.should == 0
    end
    it "should be 3 for 3 items" do
      not_empty.size.should == 3
    end
    it "should be 2 for 3 items with dequeue" do
      not_empty_mod.size.should == 2
    end
    it "should be 3 for wrapped" do
      not_empty_mod2.size.should == 3
    end
    it "should be capacity for a full queue" do
      full.size.should == 5
    end
    it "should be capacity for a full queue" do
      full2.size.should == 5
    end
  end

  describe "#increment" do
    it "increments" do
      empty.increment(1).should == 2
    end
    it "increments via modulo" do
      empty.increment(4).should == 0
      empty.increment(5).should == 1
    end
  end

  describe "#enqueue" do
    it "adds item to empty" do
      empty.enqueue(1)
      empty.size.should == 1
    end
    it "adds item to not_empty" do
      not_empty.enqueue(1)
      not_empty.size.should == 4
    end
    it "adds item to not empty with dequeue" do
      not_empty_mod.enqueue 1
      not_empty_mod.size.should == 3
    end
    it "adds item to wrapped" do
      not_empty_mod2.enqueue 1
      not_empty_mod2.size.should == 4
    end
    it 'cannot enqueue empty more than its capacity' do
      expect { 6.times {|e| empty.enqueue(e)}}.to raise_error
    end
    it 'cannot enqueue full more than its capacity' do
      expect { full.enqueue 1 }.to raise_error
    end
  end

  it 'dequeues in fifo order' do
    not_empty.dequeue.should == 1
  end

  it 'tracks the correct size' do
    obj = not_empty
    expect {obj.dequeue}.should change { obj.size }.from(3).to(2)
  end

end
