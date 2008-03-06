# HasManyTenses
module RailsJitsu
  module HasManyTenses #:nodoc:

    def self.included(base)
      base.cattr_accessor :recency
      base.cattr_accessor :compare_to
      base.extend ClassMethods
    end

    module ClassMethods
      
      def has_many_tenses(options = {})
        self.recency = 15.minutes.ago
        self.compare_to = :created_at
        if options.is_a?(Hash)
          self.recency = options[:recency] if options[:recency].class == Time
          self.compare_to = options[:compare_to] if options[:compare_to]
        end
        include RailsJitsu::HasManyTenses::InstanceMethods
      end
    end
    
    # This module contains class methods
    module SingletonMethods
      def future
        @future ||= find(:all, :conditions => ["#{self.compare_to} >= ?", Time.now])
      end

      def recent
        @recent ||= find(:all, :conditions => ["#{self.compare_to} BETWEEN ? and ?", self.recency, Time.now])
      end

      def past
        @past ||= find(:all, :conditions => ["#{self.compare_to} < ?", Time.now])
      end
    end
    
    # This module contains instance methods
    module InstanceMethods
      def future?
        read_attribute(self.compare_to.to_sym) > Time.now
      end

      def recent?
        read_attribute(self.compare_to.to_sym).between?(self.recency, Time.now)
      end

      def past?
        read_attribute(self.compare_to.to_sym) < Time.now
      end
    end
  end
end
