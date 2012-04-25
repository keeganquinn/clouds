require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  subject { user }

  it { should be_valid }

  its(:posts) { should be_instance_of(Array) }

  its(:follows) { should be_instance_of(Array) }

  its(:followed_users) { should be_instance_of(Array) }

  its(:followers) { should be_instance_of(Array) }

  its(:follower_users) { should be_instance_of(Array) }

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
