require 'spec_helper'

describe "users/index" do
  let!(:users) { [ create(:user), create(:user) ] }

  it "renders a list of users" do
    assign :users, User.paginate(page: 1)

    render

    users.each do |user|
      rendered.should =~ /#{user.username}/
    end
  end
end
