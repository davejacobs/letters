Letters
-------

**Letters** is a little alphabetical library that makes debugging fun.  

### Debugging with the alphabet ###

Most engineers have a limited toolkit for debugging. For some, it's actually just the `print` statement. For others, it's `print` + the debugger. Those tools are good, but they are the lowest level of how we can debug in Ruby. With Letters, I want to start to think about `print` and `debugger` as building blocks and not as structures in themselves.

Letters aims sophisticated debugging as easy as typing out the alphabet.

### Installation ###

If you're using RubyGems, install Letters with:

    gem install letters

By default, requiring `"letters"` monkey-patches Object. It goes without saying that if you're using Letters in an app that has environments, you probably only want to use it in development.

### Debugging with letters ###

With Letters installed, you have a suite of methods available wherever you want them in your code -- at the end of any expression, in the middle of any pipeline. Most of these methods will output some form of information, though there are more sophisticated ones that pass around control of the application.

Let's start with the `z` method as an example. It is the building block for all other letter methods. Add it to the end of any object to inspect it and return the same object:

    { foo: "bar" }.z 
    # => { foo: "bar" }
    # prints { foo: "bar" }

That's simple enough, but not really useful. Things get interesting when you're in a pipeline:

    words.grep(/interesting/).
      map(&:downcase).
      slice(0..2).
      reject {|w| w.length < 3 }.
      group_by(&:length).
      values_at(5, 10)
      join(", ")
    
If I want to know the state of your code after lines 3 and 5, all I have to do is add `.z` to each one:

    words.grep(/interesting/).
      map(&:downcase).
      slice(0..2).z.
      reject {|w| w.length < 3 }.
      group_by(&:length).z.
      values_at(5, 10)
      join(", ")

Because the `z` method (and every other Letters method) returns the original object, introducing it is only ever for side effects -- they won't change the output of your code.

This is significantly easier than breaking apart the pipeline using variable assignment or a hefty `tap` block.

### The current API ###

Here are my past and future plans for Letters. So far, I have implemented all debug functions below except those marked with an asterisk (\*): 

*(Note that if you don't want to patch `Hash` and `Array` with such small method names, you can explicitly require "letters/core_ext" instead. Letters::CoreExt will be available for you to `include` in any object or class you'd like. Requiring "letters" on its own will add the alphabet methods to `Hash` and `Array`.)*

- *A* - 
- *B* - Beep (for coarse-grained time-analysis)
- *C* - Print callstack
- *D* - Enter the debugger
- *D1/D2 pairs* - diff two data structures or objects
- *E* - Empty check -- raise error if receiver is empty
- *F* - Write to file (format can be default or specified)
- *G* - 
- *H* - 
- *I* - Gain control from nearest transmitter (with value)\*
- *J* - Jump into object's context (execute methods inside object's context)
- *K* - 
- *L* - Logger (Rails or otherwise) -- only works if `logger` is instantiated
- *M* - Mark with message to be printed when object is garbage-collected\*
- *N* - Nil check -- raise error if receiver is nil
- *O* - List all instantiated objects\*
- *P* - Print to STDOUT (format can be default or specified)
- *Q* - 
- *R* - RI documentation for class
- *S* - Bump [safety level]()
- *T* - [Taint object]()
- *U* - Untaint object
- *V* - 
- *W* - 
- *X* - Transmit control to nearest intercepter, passing object\*
- *Y* - 
- *Z* - 

### Formats ###

The following formats are going to be supported:

- YAML
- JSON
- XML
- Ruby Pretty Print
- Ruby [Awesome print]()\* 
