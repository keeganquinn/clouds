require 'spec_helper'

describe "welcome/index" do
  it "renders the welcome page" do
    render

    rendered.should =~ /clouds/
  end
end
