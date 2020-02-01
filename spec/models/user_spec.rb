require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context '全ての属性値が正常なとき' do
    it 'バリデーションが通ること' do
      expect(user).to be_valid
    end
  end

  context 'ある属性値が不正なとき' do
    context 'nameがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.name = nil
        expect(user).to be_invalid
      end
    end
    context 'saltがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.salt = nil
        expect(user).to be_invalid
      end
    end
    context 'secret_saltがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.secret_salt = nil
        expect(user).to be_invalid
      end
    end
    context 'enc_access_tokenがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.enc_access_token = nil
        expect(user).to be_invalid
      end
    end
    context 'enc_access_token_secretがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.enc_access_token_secret = nil
        expect(user).to be_invalid
      end
    end

    context 'enc_access_token, enc_access_token_secretのペアがユニークでないとき' do
      fit 'バリデーションが通らないこと' do
        user = create(:user)
        another_user = create(:user)
        another_user.enc_access_token = user.enc_access_token
        another_user.enc_access_token_secret = user.enc_access_token_secret
        expect(another_user).to be_invalid
      end
    end
  end
end
