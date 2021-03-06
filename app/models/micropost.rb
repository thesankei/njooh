class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  
  default_scope order: 'microposts.created_at DESC'
  
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  # Returns microposts from the users being followed by the given user.
  # Uses SQL subselects to do efficient feed retrieval.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                          WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
