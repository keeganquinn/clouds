require 'spec_helper'

describe User do
  before do
    @user = User.new
    @user.username = 'test'
    @user.email = 'test@test.com'
    @user.password = 'some_password'
    @user.password_confirmation = 'some_password'
  end

  subject { @user }

  it 'should be valid with normal values' do
    @user.should be_valid
  end

  it 'can have Posts' do
    @user.posts.should be_instance_of(Array)
  end

  it 'can have Follows' do
    @user.follows.should be_instance_of(Array)
  end

  it 'can have followed Users' do
    @user.followed_users.should be_instance_of(Array)
  end

  it 'can have followers' do
    @user.followers.should be_instance_of(Array)
  end

  it 'can have follower Users' do
    @user.follower_users.should be_instance_of(Array)
  end

  it 'should be invalid if username is too short' do
    @user.username = 't'
    @user.should_not be_valid
  end

  it 'should be invalid if username is too long' do
    @user.username = '0123456789' * 5
    @user.should_not be_valid
  end

  it 'should be invalid if username is not unique' do
    @user.save.should be_true

    duplicate_user = User.new
    duplicate_user.username = 'test'
    duplicate_user.email = 'test2@test.com'
    duplicate_user.password = 'another_password'
    duplicate_user.password_confirmation = 'another_password'

    duplicate_user.should_not be_valid
  end

  it 'should be invalid if username contains unwanted characters' do
    @user.username = 'bad!@$'
    @user.should_not be_valid
  end

  it 'should be invalid if name is too long' do
    @user.name = '0123456789' * 13
    @user.should_not be_valid
  end

  it 'should be invalid if location is too long' do
    @user.location = '0123456789' * 13
    @user.should_not be_valid
  end

  it 'should be able to generate and find by a URI parameter' do
    @user.save.should be_true
    User.find_by_param(@user.to_param).should eq(@user)
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
