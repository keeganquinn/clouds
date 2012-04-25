require 'spec_helper'

describe "users/show" do
  let(:user) { create(:user) }

  it "renders a user profile" do
    assign :user, user

    render

    rendered.should =~ /has not yet created any content/
  end
end
