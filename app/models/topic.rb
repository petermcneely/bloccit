class Topic < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, as: :labelable, dependent: :destroy
  has_many :labelings, as: :labelable
  has_many :labels, through: :labelings
end
