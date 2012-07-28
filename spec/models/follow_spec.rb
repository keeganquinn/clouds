require 'spec_helper'

describe Follow do
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }
  let(:follow) do
    follower.follows.build(follow_user_id: followed.id)
  end

  subject { follow }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Follow.new(user_id: follower.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "associations" do
    before { follow.save }

    it { should respond_to(:user) }
    it { should respond_to(:followed) }

    its(:user) { should == follower }
    its(:followed) { should == followed }
  end

  describe "when User id is not present" do
    before { follow.user_id = nil }
    it { should_not be_valid }
  end

  describe "when follow User id is not present" do
    before { follow.follow_user_id = nil }
    it { should_not be_valid }
  end
end
