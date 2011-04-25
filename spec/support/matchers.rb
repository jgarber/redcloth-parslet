module RedClothParslet
  module Spec
    module Matchers
      
      # Comes from parslet/rig/rspec. Modifications:
      #   * Always trace on parse failure
      #   * Compact result to condense expected output examples
      RSpec::Matchers.define(:parse) do |input, opts|
        match do |parser|
          begin
            @result = parser.parse(input)
            if @block
              @block.call(@result)
            else
              compact_result! if @as_compacted
              (@as == @result || @as.nil?)
            end
          rescue Parslet::ParseFailed
            @trace = parser.error_tree.ascii_tree if true #opts && opts[:trace]
            false
          end
        end
        
        failure_message_for_should do |is|
          if @block
            "expected output of parsing #{input.inspect}" <<
            " with #{is.inspect} to meet block conditions, but it didn't"
          else
            "expected " << 
              (@as ? 
                "output of parsing #{input.inspect}"<<
                " with #{is.inspect} to equal #{@as.inspect}, but was #{@result.inspect}" : 
                "#{is.inspect} to be able to parse #{input.inspect}") << 
              (@trace ? 
                "\n"+@trace : 
                '')
          end
        end

        failure_message_for_should_not do |is|
          if @block
            "expected output of parsing #{input.inspect} with #{is.inspect} not to meet block conditions, but it did"
          else
            "expected " << 
              (@as ? 
                "output of parsing #{input.inspect}"<<
                " with #{is.inspect} not to equal #{@as.inspect}" :

                "#{is.inspect} to not parse #{input.inspect}, but it did")
          end
        end

        # # NOTE: This has a nodoc tag since the rdoc parser puts this into 
        # # Object, a thing I would never allow. 
        # def as(expected_output = nil, &block) # :nodoc: 
        #   @as = expected_output
        #   @block = block
        #   self
        # end
        def as(expected_output = nil, &block) # :nodoc: 
          @as_compacted = expected_output
          @block = block
          self
        end
        def compact_result!
          @as = @as_compacted
          transform = Parslet::Transform.new do
            rule(:s => simple(:s)) { s }
            rule(sequence(:s)) { s }
          end
          @result = join_adjacent_strings(transform.apply(@result))
        end
        def join_adjacent_strings(obj)
          case obj
          when Array
            obj.inject([]) do |a,b|
              if a.last.is_a?(Parslet::Slice) && b.is_a?(Parslet::Slice)
                last = a.pop
                a << last + b
              else
                a << join_adjacent_strings(b)
              end
            end
          when Hash
            obj.merge(obj){|k,v| join_adjacent_strings(v) }
          else
            obj
          end
        end
      end
      
      
    end
  end
end
