require 'spec_helper'

describe "users/index.html.haml" do
  before(:each) do
    users = [ stub_model(User), stub_model(User) ]
    users.stub :total_pages => 1
    assign :users, users
  end

  it "renders a list of users" do
    render
  end
end
