class Route < ApplicationRecord
  validates :route_id, presence: true
  validates :name, presence: true
  validates :route_updated_at, presence: true
end
