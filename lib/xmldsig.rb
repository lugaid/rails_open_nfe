require "xmldsig/signer"

module XMLDSIG
  InitializationError = Class.new(RuntimeError)
  
  # Returns a <tt>XMLDSIG::Signer</tt> for given <tt>OpenSSL::PKCS12</tt>
  def self.signer(certificate)
    Signer.new certificate
  end
  
  # Returns an <tt>OpenSSL::PKCS12</tt> for given cert_file_path, key_file_path and pass
  def self.signer_for_cert_files(cert_file_path, key_file_path, pass)
    cert = OpenSSL::X509::Certificate.new(File.read(cert_file_path))
    key = OpenSSL::PKey.read(File.read(key_file_path), pass)
    
    pkcs12_cert = OpenSSL::PKCS12.create('rails', 'rails', key, cert)
    
    Signer.new pkcs12_cert
  end
end