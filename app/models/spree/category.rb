class Spree::Category < Spree::Base
  validates :name, presence: true
  max_paginates_per 10
end
