require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  subject { user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to encrypted_password" do
      expect do
        User.new(encrypted_password: 'something')
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to reset_password_token" do
      expect do
        User.new(reset_password_token: 'something')
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to reset_password_sent_at" do
      expect do
        User.new(reset_password_sent_at: Time.now)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to remember_created_at" do
      expect do
        User.new(remember_created_at: Time.now)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to sign_in_count" do
      expect do
        User.new(sign_in_count: 0)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to current_sign_in_at" do
      expect do
        User.new(current_sign_in_at: Time.now)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to last_sign_in_at" do
      expect do
        User.new(last_sign_in_at: Time.now)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to current_sign_in_ip" do
      expect do
        User.new(current_sign_in_ip: '127.0.0.1')
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to last_sign_in_ip" do
      expect do
        User.new(last_sign_in_ip: '127.0.0.1')
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to confirmation_token" do
      expect do
        User.new(confirmation_token: 'something')
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to confirmed_at" do
      expect do
        User.new(confirmed_at: Time.now)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to confirmation_sent_at" do
      expect do
        User.new(confirmation_sent_at: Time.now)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to authentication_token" do
      expect do
        User.new(authentication_token: 'something')
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "associations" do
    before { user.save }

    it { should respond_to(:posts) }
    it { should respond_to(:follows) }
    it { should respond_to(:followed_users) }
    it { should respond_to(:followers) }
    it { should respond_to(:follower_users) }

    its(:posts) { should be_instance_of(Array) }
    its(:follows) { should be_instance_of(Array) }
    its(:followed_users) { should be_instance_of(Array) }
    its(:followers) { should be_instance_of(Array) }
    its(:follower_users) { should be_instance_of(Array) }
  end

  describe "when username is too short" do
    before { user.username = 't' }
    it { should_not be_valid }
  end

  describe "when username is too long" do
    before { user.username = '0123456789' * 5 }
    it { should_not be_valid }
  end

  describe "when username is not unique" do
    before { user.save }
    let(:duplicate_user) { build(:user, username: user.username) }

    subject { duplicate_user }
    it { should_not be_valid }
  end

  describe "when username contains unwanted characters" do
    before { user.username = 'bad!@$' }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { user.name = '0123456789' * 13 }
    it { should_not be_valid }
  end

  describe "location is too long" do
    before { user.location = '0123456789' * 13 }
    it { should_not be_valid }
  end

  describe "generate and find by URI parameter" do
    before { user.save }
    it { should == User.find_by_param(user.to_param) }
  end

  describe "following" do
    let(:other_user) { create(:user) }
    before do
      user.save
      user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "and unfollowing" do
      before { user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
