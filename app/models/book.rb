class Book < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :category, presence: true
  validates :evaluation, presence: true
  validates :body, presence: true,length: { maximum: 200 }
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy


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
