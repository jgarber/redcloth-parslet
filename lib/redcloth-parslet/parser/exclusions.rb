class Parslet::Atoms::Base
  def exclude(name)
    ExclusiveParslet.new(self, name)
  end
  
  def if_excluded(name)
    ExclusiveCompare.new(self, name)
  end

  def nif_excluded(name)
    ExclusiveCompare.new(self, name, true, true)
  end

  def unless_excluded(name)
    ExclusiveCompare.new(self, name, false)
  end

  def nunless_excluded(name)
    ExclusiveCompare.new(self, name, false, true)
  end
end

class ExclusiveParslet < Parslet::Atoms::Base
  attr_reader :parslet, :name
  def initialize(parslet, name)
    super()
    @parslet, @name = parslet, name
  end

  def try(source, context) # :nodoc:
    context.exclusion_stack << name

    result = parslet.try(source, context)

    context.exclusion_stack.pop

    result
  end

  def to_s_inner(prec) # :nodoc:
    parslet.to_s(prec)
  end
end

# Hack the context cache to be entity-stack aware
class Parslet::Atoms::Context
  attr_accessor :exclusion_stack

  def initialize(reporter=Parslet::ErrorReporter::Tree.new)
    @cache = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = {} } }
    @reporter = reporter
    @exclusion_stack = []
  end

private
  def lookup(obj, pos)
    @cache[exclusion_stack][pos][obj]
  end
  def set(obj, pos, val)
    @cache[exclusion_stack][pos][obj] = val
  end
end

class ExclusiveCompare < Parslet::Atoms::Base
  attr_reader :parslet, :name, :positive, :flip
  def initialize(parslet, name, positive=true, flip=false)
    super()
    @parslet, @name, @positive, @flip = parslet, name, positive, flip
    @error_msgs = {
      :excluded  => "#{name} is #{"reverse-" if flip}excluded in this context", 
    }
  end

  def try(source, context) # :nodoc:
    if positive ^ exclusion_stack(context).include?(name)
      # skip evaluation of the parslet because it is
      # excluded in this context
      judgment = flip ^ positive
      return judgment ? succ(nil) : context.err(self, source, @error_msgs[:excluded])
    else
      parslet.try(source, context)
    end
  end
  
  def exclusion_stack(context)
    context.instance_variable_get('@exclusion_stack') || []
  end
    
  def to_s_inner(prec) # :nodoc:
    parslet.to_s(prec)
  end
  
end
