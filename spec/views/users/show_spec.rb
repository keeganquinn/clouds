require 'spec_helper'

describe "users/show" do
  it "renders a user profile" do
    assign :user, stub_model(User, :created_at => Time.now)

    render

    rendered.should =~ /has not yet created any content/
  end
end
