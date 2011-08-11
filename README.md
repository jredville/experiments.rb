# What is this?

This is my home for random experiments in Ruby. Most of this will be untested, and not follow proper conventions, but it may be interesting to you. Note that there is no rhyme or reason to whether a given file has specs, or just an example

# What's in here?

## Quicksort.rb
basic implementation of quicksort with `arr.pop` for the pivot that prints out the subarray at each call

`ruby quicksort.rb` for a simple example

## copy_array.rb
implementation of copying a rectangle within an "image" from point a to point b using a 1-dimensional array to store the rectangle

`ruby copy_array.rb` for a simple example

## circular_queue.rb
implementation of a Circular Queue

`rspec circular_queue.rb` for specs

## nesting.rb
exploring Module.nesting to figure out if I could get the full `Module.nesting` array from outside of the module (i.e. get `[Foo::Bar, Foo]` given just `Foo::Bar`)

`rspec nesting.rb` for specs

## beget.rb
experimenting with a module that causes class creation when it is included. I was thinking of using this in a Rails plugin, but decided it was a little too much magic

`ruby beget.rb` for a simple example
