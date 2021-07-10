class Book < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :category, presence: true
  validates :evaluation, presence: true
  validates :body, presence: true,length: { maximum: 200 }
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  is_impressionable counter_cache: true
  # has_many :likes, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :book


  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
  scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) } # 2日前
  scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) } # 3日前
  scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) } # 4日前
  scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) } # 5日前
  scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) } # 6日前

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  # def self.search(keyword)
  #   where(["title like?OR body like?", "%#{keyword}%", "%#{keyword}%"])
  # end
  def self.looks(searches, words)
    if searches == "perfect_match"
      @book = Book.where("title LIKE? OR body LIKE? OR category LIKE?", "#{words}", "#{words}", "#{words}")
    elsif searches == "forward_match"
      @book = Book.where("title LIKE? OR body LIKE? OR category LIKE?", "#{words}%", "#{words}%", "#{words}%")
    elsif searches == "backward_match"
      @book = Book.where("title LIKE? OR body LIKE? OR category LIKE?", "%#{words}", "%#{words}", "%#{words}")
    else
      @book = Book.where("title LIKE? OR body LIKE? OR category LIKE?", "%#{words}%", "%#{words}%", "%#{words}%")
    end
  end
end
