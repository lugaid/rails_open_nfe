module XMLDSIG
  class Signer
    attr_reader :certificate
    
    # Expects a <tt>OpenSSL::PKCS12</tt> certificate
    def initialize (certificate)
      unless certificate.kind_of? OpenSSL::PKCS12
        raise_initialization_error_by_invalid_certificate! certificate
      end
      
      @certificate = certificate
    end
    
    # Returns a XML <tt>String<//tt> signed and canonicalized to <tt>Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0<//tt> 
    # for given XML
    def sign! (xml)
      xml_object = Nokogiri::XML(xml.to_s, &:noblanks)

      build_signature_node_and_add_as_child xml_object

      xml_object.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)   
    end
    
    private
      def raise_initialization_error_by_invalid_certificate!(certificate)
        raise InitializationError,
              "Expects to receive a kind of OpenSSL::PKCS12 certificate \n
               but the certificate object received was (#{certificate.class})."
      end
    
      def build_signature_node_and_add_as_child(xml_object)
        signature_node = xml_object.xpath("//ds:Signature", "ds" => "http://www.w3.org/2000/09/xmldsig#").first
        
        unless signature_node
          signature_node = Nokogiri::XML::Node.new('Signature', xml_object)
          signature_node.default_namespace = 'http://www.w3.org/2000/09/xmldsig#'
          xml_object.root().add_child signature_node
        end
        
        signed_info_node = build_signed_info_node xml_object

        signature_node.add_child signed_info_node
        
        signature_value_node = build_signature_value xml_object, signed_info_node

        signature_node.add_child(signature_value_node)
      end
      
      def build_signed_info_node (xml_object)
        xml_element_to_sign = xml_object.root().xpath('//ds:infNFe', 
          'ds' => 'http://www.portalfiscal.inf.br/nfe').first
          
        xml_canon = xml_element_to_sign.canonicalize(Nokogiri::XML::XML_C14N_1_0)
        xml_digest = Base64.encode64(OpenSSL::Digest::SHA1.digest(xml_canon)).strip
        
        signed_info_node = Nokogiri::XML::Node.new('SignedInfo', xml_object)
        
        child_node = Nokogiri::XML::Node.new('CanonicalizationMethod', xml_object)
        child_node['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
        signed_info_node.add_child child_node

        child_node = Nokogiri::XML::Node.new('SignatureMethod', xml_object)
        child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
        signed_info_node.add_child child_node

        reference = Nokogiri::XML::Node.new('Reference', xml_object)
        reference['URI'] = "\##{xml_element_to_sign.attr('Id')}"

        transforms = Nokogiri::XML::Node.new('Transforms', xml_object)
  
        transform = Nokogiri::XML::Node.new('Transform', xml_object)
        transform['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
        transforms.add_child transform
  
        transform = Nokogiri::XML::Node.new('Transform', xml_object)
        transform['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
        transforms.add_child transform
  
        reference.add_child transforms

        digest_method = Nokogiri::XML::Node.new('DigestMethod', xml_object)
        digest_method['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#sha1'
        reference.add_child digest_method

        digest_value = Nokogiri::XML::Node.new('DigestValue', xml_object)
        digest_value.content = xml_digest
        reference.add_child digest_value

        signed_info_node.add_child reference
        
        signed_info_node
      end
      
      def build_signature_value (xml_object, signed_info_node)
        sign_info_canon = signed_info_node.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)

        signature_hash = @certificate.key.sign(OpenSSL::Digest::SHA1.new, sign_info_canon)
        signature_value = Base64.encode64( signature_hash ).gsub("\n", '')

        signature_value_node = Nokogiri::XML::Node.new('SignatureValue', xml_object)
        signature_value_node.content = signature_value
        
        signature_value_node
      end
      
      def build_key_info ()
        key_info = Nokogiri::XML::Node.new('KeyInfo', xml_object)

        x509_data = Nokogiri::XML::Node.new('X509Data', xml_object)
        x509_certificate = Nokogiri::XML::Node.new('X509Certificate', xml_object)
        x509_certificate.content = certificado.certificate.to_s.gsub(/\-\-\-\-\-[A-Z]+ CERTIFICATE\-\-\-\-\-/, "").gsub(/\n/,"")
  
        x509_data.add_child x509_certificate
        key_info.add_child x509_data
      end
  end
end