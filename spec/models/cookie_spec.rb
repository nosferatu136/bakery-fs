require 'rails_helper'

describe Cookie do
  subject { Cookie.new }

  describe "associations" do
    it { is_expected.to belong_to(:storage) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:storage) }
  end

  context 'when cookie has no fillings' do
    let(:new_cookie) { FactoryGirl.create(:cookie, fillings: '') }

    it 'sanitizes fillings' do
      expect(new_cookie.fillings).to be_nil
    end
  end
end
