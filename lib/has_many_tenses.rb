# HasManyTenses
module RailsJitsu
  module HasManyTenses #:nodoc:

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      
      def has_many_tenses(opts = {})
        write_inheritable_attribute :recency, opts[:recency] || 15.minutes.ago
        write_inheritable_attribute :compare_to, opts[:compare_to] || :created_at
        class_inheritable_reader    :recency
        class_inheritable_reader    :compare_to
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
