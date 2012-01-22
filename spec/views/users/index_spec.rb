require 'spec_helper'

describe "users/index" do
  it "renders a list of users" do
    users = [
      stub_model(User, :username => "jim"),
      stub_model(User, :username => "ray")
    ]
    users.stub :total_pages => 1
    assign :users, users

    render

    rendered.should =~ /jim/
    rendered.should =~ /ray/
  end
end
