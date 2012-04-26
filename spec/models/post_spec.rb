require 'spec_helper'

describe Post do
  let(:user) { create(:user) }
  let(:post) { build(:post, user: user) }

  subject { post }

  it { should be_valid }

  describe "reply" do
    before { post.save }
    let(:reply_post) { build(:post, user: user, in_reply_to_post_id: post.id) }

    subject { reply_post }
    it { should be_valid }
    its(:in_reply_to_post) { should == post }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Post.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "associations" do
    before { post.save }

    it { should respond_to(:user) }
    it { should respond_to(:in_reply_to_post) }
    it { should respond_to(:replies) }

    its(:user) { should == user }
    its(:in_reply_to_post) { should be_blank }
    its(:replies) { should be_instance_of(Array) }
  end

  describe "without a valid User" do
    before { post.user = nil }
    it { should_not be_valid }
  end

  describe "when code is too short" do
    before { post.code = 't' }
    it { should_not be_valid }
  end

  describe "when code is too long" do
    before { post.code = '0123456789' * 30 }
    it { should_not be_valid }
  end

  describe "when code is not unique" do
    before { post.save }
    let(:duplicate_post) { build(:post, user: user, code: post.code) }

    subject { duplicate_post }
    it { should_not be_valid }
  end

  describe "when code contains unwanted characters" do
    before { post.code = 'bad!@$' }
    it { should_not be_valid }
  end

  describe "when subject is too short" do
    before { post.subject = 't' }
    it { should_not be_valid }
  end

  describe "when subject is too long" do
    before { post.subject = '0123456789' * 30 }
    it { should_not be_valid }
  end

  describe "when body is missing" do
    before { post.body = nil }
    it { should_not be_valid }
  end

  describe "generate and find by URI parameter" do
    before { post.save }
    it { should == Post.find_by_param(post.to_param) }
  end

  describe "generate a code from the subject if none is provided" do
    before { post.save }
    its(:code) { should match(/test/) }
  end
end
