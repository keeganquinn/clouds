require 'spec_helper'

describe Post do
  before do
    @post = Post.new
  end

  it 'should be invalid if code is too long' do
    @post.subject = 'Model Test'
    @post.body = 'Testing.'
    @post.should be_valid

    @post.code = '0123456789' * 30
    @post.should_not be_valid
  end

  it 'should be invalid if code is not unique' do
    @post.subject = 'Test 1'
    @post.body = 'Test one.'
    @post.save.should be_true

    @duplicate_post = Post.new
    @duplicate_post.subject = 'Test 1'
    @duplicate_post.body = 'Test one.'
    @duplicate_post.should_not be_valid
  end

  it 'should be invalid if code contains unwanted characters' do
    @post.subject = 'Model Test'
    @post.body = 'Testing.'
    @post.should be_valid

    @post.code = 'bad!@$'
    @post.should_not be_valid
  end

  it 'should be invalid without a subject and body' do
    @post.should_not be_valid

    @post.subject = 'Model Test'
    @post.body = 'Testing.'
    @post.should be_valid
  end

  it 'should generate a code from the subject if none is provided' do
    @post.subject = 'Model Test'
    @post.body = 'Testing.'
    @post.should be_valid

    @post.code.should match(/model-test/)
  end
end
