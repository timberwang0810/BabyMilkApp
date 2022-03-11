class Bottle < ApplicationRecord
  belongs_to :patient
  belongs_to :checkin_nurse_id
  belongs_to :checkout_nurse_id
end
