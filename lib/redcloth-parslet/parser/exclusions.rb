class Parslet::Atoms::Base
  def exclude(name)
    ExclusiveParslet.new(self, name)
  end
  
  def if_excluded(name)
    ExclusiveCompare.new(self, name)
  end

  def unless_excluded(name)
    ExclusiveCompare.new(self, name, false)
  end
end

class ExclusiveParslet < Parslet::Atoms::Base
  attr_reader :parslet, :name
  def initialize(parslet, name)
    super()
    @parslet, @name = parslet, name
  end

  def try(source, context) # :nodoc:
    context.entity_stack << name

    result = parslet.try(source, context)

    context.entity_stack.pop

    result
  end

  def to_s_inner(prec) # :nodoc:
    parslet.to_s(prec)
  end
end

# Hack the context cache to be entity-stack aware
class Parslet::Atoms::Context
  attr_accessor :entity_stack

  def initialize(reporter=Parslet::ErrorReporter::Tree.new)
    @cache = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = {} } }
    @reporter = reporter
    @entity_stack = []
  end

private
  def lookup(obj, pos)
    @cache[entity_stack][pos][obj]
  end
  def set(obj, pos, val)
    @cache[entity_stack][pos][obj] = val
  end
end

class ExclusiveCompare < Parslet::Atoms::Base
  attr_reader :parslet, :name, :positive
  def initialize(parslet, name, positive=true)
    super()
    @parslet, @name, @positive = parslet, name, positive
    @error_msgs = {
      :excluded  => "#{name} is excluded in this context", 
    }
  end

  def try(source, context) # :nodoc:
    if positive ^ entity_stack(context).include?(name)
      # skip evaluation of the parslet because it is
      # excluded in this context
      return positive ? succ(nil) : context.err(self, source, @error_msgs[:excluded])
    else
      parslet.try(source, context)
    end
  end
  
  def entity_stack(context)
    context.instance_variable_get('@entity_stack') || []
  end
    
  def to_s_inner(prec) # :nodoc:
    parslet.to_s(prec)
  end
  
end
