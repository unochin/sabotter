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
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end
    end
    context 'saltがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.salt = nil
        user.valid?
        expect(user.errors[:salt]).to include('を入力してください')
      end
    end
    context 'secret_saltがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.secret_salt = nil
        user.valid?
        expect(user.errors[:secret_salt]).to include('を入力してください')
      end
    end
    context 'enc_access_tokenがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.enc_access_token = nil
        user.valid?
        expect(user.errors[:enc_access_token]).to include('を入力してください')
      end
    end
    context 'enc_access_token_secretがnullのとき' do
      it 'バリデーションが通らないこと' do
        user.enc_access_token_secret = nil
        user.valid?
        expect(user.errors[:enc_access_token_secret]).to include('を入力してください')
      end
    end

    context 'enc_access_token, enc_access_token_secretのペアがユニークでないとき' do
      it 'バリデーションが通らないこと' do
        another_user = create(:user)
        another_user.enc_access_token = user.enc_access_token
        another_user.enc_access_token_secret = user.enc_access_token_secret
        another_user.save
        user.valid?
        expect(user.errors[:enc_access_token]).to include('はすでに存在します')
      end
    end
  end
end
