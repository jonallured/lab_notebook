require 'gibberish'

class EntryEncrypter
  attr_reader :filename, :text

  def initialize(unencrypted_details, rsa_key)
    @unencrypted_details = unencrypted_details
    @rsa_key = rsa_key
  end

  def encrypt
    create_hashed_filename
    record_public_key
    encrypt_filename
    encrypt_text
    @text = @details.to_json
  end

  private

  def create_hashed_filename
    content = [unencrypted_filename, unencrypted_text].join
    hashed_filename = Gibberish::MD5 content
    @filename = "#{hashed_filename}.json"
  end

  def unencrypted_filename
    @unencrypted_details[:filename]
  end

  def unencrypted_text
    @unencrypted_details[:text]
  end

  def record_public_key
    @details = {
      public_key: public_key
    }
  end

  def public_key
    @rsa_key.public_key.to_s
  end

  def encrypt_filename
    json = cipher.encrypt(unencrypted_filename)
    filename_details = JSON.parse json
    @details[:filename] = {
      ct: filename_details['ct'],
      iv: filename_details['iv'],
      salt: filename_details['salt'],
    }
  end

  def encrypt_text
    input_text = unencrypted_text.empty? ? ' ' : unencrypted_text
    json = cipher.encrypt(input_text)
    text_details = JSON.parse json
    @details[:text] = {
      ct: text_details['ct'],
      iv: text_details['iv'],
      salt: text_details['salt'],
    }
  end

  def cipher
    @cipher ||= Gibberish::AES.new private_key
  end

  def private_key
    @rsa_key.to_s
  end
end
