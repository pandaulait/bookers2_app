class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { minimum: 2 ,maximum: 20}, uniqueness: true
  validates :introduction ,length: {maximum: 50}
  has_many :books, dependent: :destroy
  attachment :profile_image
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  # 以下フォロー機能


  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 被フォロー関係を通じて参照→followed_idをフォローしている人
  # @user.followersで、@userがfollowed_idである時のfollower_idを全て取得
  has_many :relationships ,class_name: "Relationship" ,foreign_key:  "follower_id", dependent: :destroy

  has_many :followings, through: :relationships, source: :followed
  # @user.followingsで、@userがfollower_idである時のfollowed_idを全て取得
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
  def self.looks(searches,words)
    if searches == "perfect_match"
      @user = User.where("name LIKE ?","#{words}")
    else
      @user = User.where("name LIKE ?", "%#{words}%")
    end
  end

end
