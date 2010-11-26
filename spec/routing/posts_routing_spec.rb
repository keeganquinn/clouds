require "spec_helper"

describe PostsController do
  describe "routing" do
    it "recognizes and generates site-wide #index" do
      { :get => "/posts" }.should route_to(:controller => "posts", :action => "index")
    end

    it "recognizes and generates per-user #index" do
      { :get => "/users/someone/posts" }.should route_to(:controller => "posts", :action => "index", :user_id => "someone")
    end

    it "recognizes and generates #new" do
      { :get => "/users/someone/posts/new" }.should route_to(:controller => "posts", :action => "new", :user_id => "someone")
    end

    it "recognizes and generates #show" do
      { :get => "/users/someone/posts/1" }.should route_to(:controller => "posts", :action => "show", :id => "1", :user_id => "someone")
    end

    it "recognizes and generates #edit" do
      { :get => "/users/someone/posts/1/edit" }.should route_to(:controller => "posts", :action => "edit", :id => "1", :user_id => "someone")
    end

    it "recognizes and generates #create" do
      { :post => "/users/someone/posts" }.should route_to(:controller => "posts", :action => "create", :user_id => "someone")
    end

    it "recognizes and generates #update" do
      { :put => "/users/someone/posts/1" }.should route_to(:controller => "posts", :action => "update", :id => "1", :user_id => "someone")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/users/someone/posts/1" }.should route_to(:controller => "posts", :action => "destroy", :id => "1", :user_id => "someone")
    end
  end
end
