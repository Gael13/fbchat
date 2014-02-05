require 'spec_helper'

describe MessagesController do
  describe "GET 'index'" do
  	it "should be successful" do
  	  get 'index'
  	  response.should be_success
  	end
  end

  describe "POST create" do
  	describe "with valid params" do
  	  before (:each) do
  	  	@attrs = FactoryGirl.create(:message)
  	  end
  	  
  	  it "creates a new user message" do
  	    post :create, {:message_name => @attrs.name, :message_content => @attrs.content, :message_connection_id => @attrs.connection_id}
  	    message = Message.last
  	    message.name.should eql("TestUser")
  	    message.content.should eql("this is my test message")
  	    message.connection_id.should be > 0
  	    message.connection_id.should be < 10000
  	  end
  	end
  end
  
  describe "EVENT response" do
    before (:each) do
      @attrs = FactoryGirl.create(:message)
      post :create, {:message_name => @attrs.name, :message_content => @attrs.name, :message_connection_id => @attrs.connection_id}	    	
    end

    it "sets the content header" do
      get "events"
      response.header["Content-Type"].should eql("text/event-stream")
    end
    
    it "should include message_name parameter" do
      get "events"
      response.request.filtered_parameters.should include("message_name")
    end
    
    it "should include message_content parameter" do
      get "events"
      response.request.filtered_parameters.should include("message_content")
    end
    
    it "should include message_connection_id parameter" do
      get "events"
      response.request.filtered_parameters.should include("message_connection_id")
    end
  end    
end