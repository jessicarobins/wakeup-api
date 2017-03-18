require 'csv'
require 'date'

class Trip < ApplicationRecord
  belongs_to :start, class_name: "Transaction"
  belongs_to :end, class_name: "Transaction"
end
