require File.dirname(__FILE__) + '/follower_lib'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Followable
      
      def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          include FollowerLib
        end
      end
      
      module ClassMethods
        def acts_as_followable
          has_many :follows, :as => :followable, :dependent => :destroy
          include ActiveRecord::Acts::Followable::InstanceMethods
        end
      end

      
      module InstanceMethods
        
        # Returns the number of followers a record has.
        def followers_count
          self.follows.find(:all, :conditions => {:blocked => false}).size
        end
        
        def blocked_followers_count
          self.follows.find(:all, :conditions => {:blocked => true}).size
        end
        
        # Returns the following records.
        def followers
          Follow.find(:all, :include => [:follower], :conditions => ["blocked = ? AND followable_id = ? AND followable_type = ?", 
              false, self.id, parent_class_name(self)]).collect {|f| f.follower }
        end
        
        def follow_for(follower)
          Follow.find(:first, :conditions => ["followable_id = ? AND followable_type = ? AND follower_id = ? AND follower_type = ?", self.id, parent_class_name(self), follower.id, parent_class_name(follower)])
        end
        
        # Returns true if the current instance is followed by the passed record.
        def followed_by?(follower)
          f = follow_for(follower)
          f ? !f.blocked : false
        end
        
        def block(follower)
          follow_for(follower) ? block_existing_follow(follower) : block_future_follow(follower)
        end
        
        def block_future_follow(follower)
          follows.create(:followable => self, :follower => follower, :blocked => true)
        end
        
        def block_existing_follow(follower)
          follow_for(follower).block!
        end
        
      end
      
    end
  end
end
