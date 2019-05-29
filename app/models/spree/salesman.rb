class Spree::Salesman < Spree::Base
  validates :name, presence: true
  validates :google_client_id, presence: true
  validates :google_client_secret, presence: true
  validates :google_calander_id, presence: true
  has_many :users
  max_paginates_per 10
end
