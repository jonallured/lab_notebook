require 'gibberish'

class EntryDecrypter
  attr_reader :filename, :text

  def initialize(encryption_details, rsa_keys)
    @encryption_details = encryption_details
    @rsa_keys = rsa_keys
  end

  def decrypt
    decrypt_filename
    decrypt_text
  end

  private

  def cipher
    @cipher ||= Gibberish::AES.new private_key
  end

  def private_key
    rsa_key = @rsa_keys.find { |rsa_key| rsa_key.public_key.to_s == encryption_public_key }
    raise :hell unless rsa_key
    rsa_key.to_s
  end

  def encryption_public_key
    @encryption_details['public_key']
  end

  def decrypt_filename
    options = @encryption_details['filename'].merge decryption_defaults
    @filename = cipher.decrypt options.to_json
  end

  def decrypt_text
    options = @encryption_details['text'].merge decryption_defaults
    @text = cipher.decrypt options.to_json
  end

  def decryption_defaults
    {
      v: 1,
      adata: '',
      ks: 256,
      ts: 96,
      mode: 'gcm',
      cipher: 'aes',
      iter: 100000
    }
  end
end
