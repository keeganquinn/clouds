require 'spec_helper'

describe "users/show.html.haml" do
  before(:each) do
    assign :user, stub_model(User, :created_at => Time.now)
  end

  it "renders attributes in <p>" do
    render
  end
end
