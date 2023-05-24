class User < ApplicationRecord
  has_many :stories_to_write, class_name: 'Story', foreign_key: 'writer_id'
  has_many :stories_to_review, class_name: 'Story', foreign_key: 'reviewer_id'
  has_many :comments
  belongs_to :organization

  VALID_TYPES = ['chief_editor', 'writer']

  validates :user_type, inclusion: { in: VALID_TYPES }

  def chief_editor?
    user_type == 'chief_editor'
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
