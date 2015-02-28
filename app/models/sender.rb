class Sender < ActiveRecord::Base
  validates_presence_of :name, :cnpj, :certificate
  validates_length_of :cnpj, maximum: 14
  validates_cnpj :cnpj
end
