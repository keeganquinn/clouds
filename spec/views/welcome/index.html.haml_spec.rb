require 'spec_helper'

describe "welcome/index.html.haml" do
  it "renders the welcome page" do
    render

    rendered.should =~ /clouds/
  end
end
