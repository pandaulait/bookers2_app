class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { minimum: 2 ,maximum: 20}, uniqueness: true
  validates :introduction ,length: {maximum: 50}
  validates :name, presence: true, length: { minimum: 2 ,maximum: 20}
  has_many :books, dependent: :destroy
  attachment :profile_image
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  # has_many :likes, dependent: :destroy
  has_many :favorited_books, through: :favorites, source: :user
  # 以下フォロー機能

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 被フォロー関係を通じて参照→followed_idをフォローしている人
  # @user.followersで、@userがfollowed_idである時のfollower_idを全て取得
  has_many :relationships ,class_name: "Relationship" ,foreign_key:  "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  # @user.followingsで、@userがfollower_idである時のfollowed_idを全て取得
  # DM機能
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
  def self.followed_by?(user)
    # 今自分(引数のuser)がフォローしようとしているユーザー(レシーバー)がフォローされているユーザー(つまりpassive)の中から、引数に渡されたユーザー(自分)がいるかどうかを調べる
    followers.include?(user)
  end

  def self.looks(searches,words)
    if searches == "perfect_match"
      @user = User.where("name LIKE ?","#{words}")
    elsif searches == "forward_match"
      @user = User.where("name LIKE ?","#{words}%")
    elsif searches == "backward_match"
      @user = User.where("name LIKE ?","%#{words}")
    else
      @user = User.where("name LIKE ?", "%#{words}%")
    end
  end

end
