require 'spec_helper'

describe Post do
  def mock_user(stubs = {})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  before do
    @post = Post.new
    @post.user = mock_user
    @post.subject = 'Test'
    @post.body = 'This is a test post.'
  end

  it 'should be valid with normal values' do
    @post.should be_valid
  end

  it 'can be marked as a reply to another Post' do
    @post.save.should be_true

    reply_post = Post.new
    reply_post.user = mock_user
    reply_post.in_reply_to_post = @post
    reply_post.subject = 'Reply test'
    reply_post.body = 'This is a test reply.'
    reply_post.should be_valid
  end

  it 'can have replies' do
    @post.replies.should be_instance_of(Array)
  end

  it 'should be invalid without a valid User' do
    @post.user = nil
    @post.should_not be_valid
  end

  it 'should be invalid if code is too short' do
    @post.code = 't'
    @post.should_not be_valid
  end

  it 'should be invalid if code is too long' do
    @post.code = '0123456789' * 30
    @post.should_not be_valid
  end

  it 'should be invalid if code is not unique' do
    @post.save.should be_true

    duplicate_post = Post.new
    duplicate_post.subject = 'Test'
    duplicate_post.body = 'Duplicate test.'
    duplicate_post.should_not be_valid
  end

  it 'should be invalid if code contains unwanted characters' do
    @post.code = 'bad!@$'
    @post.should_not be_valid
  end

  it 'should be invalid if subject is too short' do
    @post.subject = 't'
    @post.should_not be_valid
  end

  it 'should be invalid if subject is too long' do
    @post.subject = '0123456789' * 30
    @post.should_not be_valid
  end

  it 'should be invalid if body is missing' do
    @post.body = nil
    @post.should_not be_valid
  end

  it 'should be able to generate and find by a URI parameter' do
    @post.save.should be_true
    Post.find_by_param(@post.to_param).should eq(@post)
  end

  it 'should generate a code from the subject if none is provided' do
    @post.save.should be_true
    @post.code.should match(/test/)
  end
end
