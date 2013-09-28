class Resource

  class << self

    alias_method :__new__, :new

    def new(*args, &block)
      method_missing(:new, *args, &block)
    end

    def respond_to? method
      super(method) or new.respond_to?(method)
    end

    def method_missing(method, *args, &block)
      __new__.public_send(method, *args, &block)
    end

  end

end
