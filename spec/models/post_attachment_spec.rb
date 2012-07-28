require 'spec_helper'

describe PostAttachment do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:post_attachment) { build(:post_attachment, post: post) }

  subject { post_attachment }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to post_id" do
      expect do
        PostAttachment.new(post_id: post.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "associations" do
    before { post_attachment.save }

    it { should respond_to(:post) }

    its(:post) { should == post }
  end

  describe "without a valid Post" do
    before { post_attachment.post = nil }
    it { should_not be_valid }
  end

  describe "without filename" do
    before { post_attachment.filename = nil }
    it { should_not be_valid }
  end

  describe "without content_type" do
    before { post_attachment.content_type = nil }
    it { should_not be_valid }
  end

  describe "without data" do
    before { post_attachment.data = nil }
    it { should_not be_valid }
  end
end
