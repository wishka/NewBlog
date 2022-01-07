require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject {
    described_class.new(name: 'Example Customer', email: 'customer@example.com',
                        password: "foobar", password_confirmation: "foobar")
  }
  describe 'Validation' do

    context "should be valid" do
      it {expect(subject).to be_valid}
    end

  it "name should not be too long" do
    subject.name = "a" * 51
    assert subject.invalid?
  end

  it "email should not be too long" do
    subject.email = "a" * 244 + "@example.com"
    assert subject.invalid?
  end

  #  context "name should be present" do
  #    before { described_class.create!(name: '     ', email: 'customer@example.com') }
  #    it {expect(subject).to be_invalid}
  #  end

  #  it "email should be present" do
  #    before { described_class.create!(name: 'Example Customer', email: '     ') }
  #    it {expect(subject).to be_invalid}
  #  end

    it "email validation should accept valid addresses" do
      valid_addresses = %w[subject@example.com SUBJECT@foo.COM A_SUB-JECT@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        subject.email = valid_address
        assert subject.valid?, "#{valid_address.inspect} should be valid"
      end
    end

    it "email validation should reject invalid addresses" do
      invalid_addresses = %w[subject@example,com subject_at_foo.org subject.name@example.
                            foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        subject.email = invalid_address
        assert subject.invalid?, "#{invalid_address.inspect} should be invalid"
      end
    end

    it "email addresses should be unique" do
      duplicate_subject = subject.dup
      duplicate_subject.email = subject.email.upcase
      subject.save
      assert duplicate_subject.invalid?
    end

    it "password should be present (nonblank)" do
      subject.password = subject.password_confirmation = " " * 6
      assert subject.invalid?
    end

    it "password should have a minimum length" do
      subject.password = subject.password_confirmation = "a" * 5
      assert subject.invalid?
    end

    it "authenticated? should return false for a customer with nil digest" do
      assert_not @customer.authenticated?(:remember, '')
    end
  end
end
