require "savon"
require "xmldsig"

class Invoice < ActiveRecord::Base
  belongs_to :sender
  
  before_save :sign_xml
  
  private
    def sign_xml
      key = Rails.root.join('private','certificates','teste_key.pem')
      cert = Rails.root.join('private','certificates','teste_cert.pem')
      xmldsig = XMLDSIG::signer_for_cert_files(cert, key, 'teste1234')
      
      self.signed_xml = xmldsig.sign! self.signed_xml
    end
end
