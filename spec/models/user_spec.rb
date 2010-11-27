require 'spec_helper'

describe User do
  before do
    @user = User.new

    @user.email = 'test@test.com'
    @user.password = 'some_password'
    @user.password_confirmation = 'some_password'
  end

  it 'should be invalid if username is too short' do
    @user.should be_valid

    @user.username = 'ab'
    @user.should_not be_valid
  end

  it 'should be invalid if username is too long' do
    @user.should be_valid

    @user.username = '0123456789' * 5
    @user.should_not be_valid
  end

  it 'should be invalid if username is not unique' do
    @user.username = 'test'
    @user.save.should be_true

    @duplicate_user = User.new
    @duplicate_user.email = 'test2@test.com'
    @duplicate_user.password = 'another_password'
    @duplicate_user.password_confirmation = 'another_password'
    @duplicate_user.should be_valid

    @duplicate_user.username = 'test'
    @duplicate_user.should_not be_valid
  end

  it 'should be invalid if username contains unwanted characters' do
    @user.should be_valid

    @user.username = 'bad!@$'
    @user.should_not be_valid
  end

  it 'should be invalid if name is too long' do
    @user.should be_valid

    @user.name = '0123456789' * 13
    @user.should_not be_valid
  end

  it 'should be invalid if location is too long' do
    @user.should be_valid

    @user.location = '0123456789' * 13
    @user.should_not be_valid
  end
end
