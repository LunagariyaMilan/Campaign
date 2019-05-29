Spree::User.class_eval do
	validates :name, presence: true, if: :user_category
  validates :phone, presence: true, :numericality => true, if: :user_category
  belongs_to :category
  belongs_to :salesman
  def user_category
    self.category_id == 3
  end
end