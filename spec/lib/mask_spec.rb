require_relative '../models/user'

RSpec.describe Kuronuri::Mask do
  let(:user) { User.new('hoge', 'hoge@example.com') }

  describe '.mask' do
    it { expect(user.screen_name).to eq 'hoge' }
    it { expect(user.email).to eq '' }

    context 'with direct access to hashed method' do
      let(:method_name) { Digest::SHA1.hexdigest('email').to_sym }
      it { expect(User.private_method_defined?(method_name)).to be_truthy }
    end
  end

  describe '#peep_into_attribute' do
    it { expect(user.peep_into_email).to eq 'hoge@example.com' }
  end

  describe '#peep' do
    it do
      user.peep do |user|
        expect(user.email).to eq 'hoge@example.com'
      end
    end

    context 'when access to another instance in peep' do
      let(:user2) { User.new('fuga', 'fuga@example.com') }
      it do
        user.peep do |user|
          expect(user2.email).to be_empty
        end
      end
    end
  end
end
