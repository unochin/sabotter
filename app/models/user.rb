class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :authentications, dependent: :destroy
  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :name, presence: true
  validates :enc_access_token, presence: true
  validates :enc_access_token_secret, presence: true
  validates :enc_access_token, uniqueness: { scope: :enc_access_token_secret }


  def aes_encrypt(access_token, access_token_secret)

    password = Rails.application.credentials.encrypt_password

    # saltを生成
    new_salt = OpenSSL::Random.random_bytes(8)
    new_secret_salt = OpenSSL::Random.random_bytes(8)

    # 暗号器を生成
    enc = OpenSSL::Cipher::AES.new(256, :CBC)
    secret_enc = OpenSSL::Cipher::AES.new(256, :CBC)
    enc.encrypt
    secret_enc.encrypt

    # パスワードとsaltをもとに鍵とivを生成し、設定
    key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, new_salt, 2000, enc.key_len + enc.iv_len, "sha256")
    secret_key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, new_secret_salt, 2000, secret_enc.key_len + secret_enc.iv_len, "sha256")
    enc.key = key_iv[0, enc.key_len]
    secret_enc.key = secret_key_iv[0, secret_enc.key_len]
    enc.iv = key_iv[enc.key_len, enc.iv_len]
    secret_enc.iv = secret_key_iv[secret_enc.key_len, secret_enc.iv_len]

    # 文字列を暗号化
    encrypted_access_token = enc.update(access_token) + enc.final
    encrypted_access_token_secret = secret_enc.update(access_token_secret) + secret_enc.final

    # Base64でエンコード
    self.enc_access_token = Base64.encode64(encrypted_access_token).chomp
    self.enc_access_token_secret = Base64.encode64(encrypted_access_token_secret).chomp
    self.salt = Base64.encode64(new_salt).chomp
    self.secret_salt = Base64.encode64(new_secret_salt).chomp
  end

  def aes_decrypt

    password = Rails.application.credentials.encrypt_password

    # Base64でデコード
    encrypted_access_token = Base64.decode64(enc_access_token)
    encrypted_access_token_secret = Base64.decode64(enc_access_token_secret)
    new_salt = Base64.decode64(salt)
    new_secret_salt = Base64.decode64(secret_salt)

    # 復号器を生成
    dec = OpenSSL::Cipher::AES.new(256, :CBC)
    secret_dec = OpenSSL::Cipher::AES.new(256, :CBC)
    dec.decrypt
    secret_dec.decrypt

    # パスワードとsaltをもとに鍵とivを生成し、設定
    key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, new_salt, 2000, dec.key_len + dec.iv_len, "sha256")
    secret_key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, new_secret_salt, 2000, secret_dec.key_len + secret_dec.iv_len, "sha256")
    dec.key = key_iv[0, dec.key_len]
    secret_dec.key = secret_key_iv[0, secret_dec.key_len]
    dec.iv = key_iv[dec.key_len, dec.iv_len]
    secret_dec.iv = secret_key_iv[secret_dec.key_len, secret_dec.iv_len]

    # 暗号を復号
    access_token = dec.update(encrypted_access_token) + dec.final
    access_token_secret = secret_dec.update(encrypted_access_token_secret) + secret_dec.final

    [access_token, access_token_secret]
  end

end
