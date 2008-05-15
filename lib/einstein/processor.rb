module Einstein
  class Processor
    def process(node)
      node ||= []
      if respond_to?(method = "process_#{node.first}")
        send(method, node)
      else
        raise "No process method for sexp: #{node.inspect}"
      end
    end
  end
end
