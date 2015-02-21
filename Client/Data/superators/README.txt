superators
    by Jay Phillips
    http://jicksta.com

== DESCRIPTION:
  
Superators are a superset of new Ruby operators you can create and use.

== FEATURES/PROBLEMS:
  
* Presently a superator operand must support having a singleton class. Because true, false, nil, Symbols, and Fixnums are all specially optimized for in MRI and cannot have singleton classes, they can't be given to a superator. There are ways this can be potentially accounted for, but nothing is in place at the moment, causing this to be classified as a bug.

* When defining a superator in a class, any operators overloaded after the superator definition will override a superator definition. For example, if you create the superator "<---" and then define the <() operator, the superator will not work. In this case, the superator's definition should be somewhere after the <() definition.

* Superators work by handling a binary Ruby operator specially and then building a chain of unary operators after it. For this reason, a superator must match the regexp /^(\*\*|\*|\/|%|\+|\-|<<|>>|&|\||\^|<=>|>=|<=|<|>|===|==|=~)(\-|~|\+)+$/.

== SYNOPSIS:

Below is a simple example monkey patch which adds the "<---" operator to all Ruby Arrays.

  class Array
    superator "<---" do |operand|
      if operand.kind_of? Array
        self + operand.map { |x| x.inspect }
      else
        operand.inspect
      end
    end
  end

== REQUIREMENTS:

* Only requirement is Ruby.

== INSTALL:

* sudo gem install superators
* require 'superators'

== LICENSE:

This software is licensed in the public domain. You may do whatever you wish with it.

You are allowed to use this library during dodo poaching as well.