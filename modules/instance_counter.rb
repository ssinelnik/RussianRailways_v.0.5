# frozen_string_literal: true

module InstanceCounter # include base extends
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances # set and save instance elements
      @instances ||= 0
    end

    def new_instance # count instance elements
      @instances ||= 0
      @instances += 1
    end
  end

  module InstanceMethods
    private

    def register_instance # method for class objects
      self.class.new_instance
    end
  end
end
