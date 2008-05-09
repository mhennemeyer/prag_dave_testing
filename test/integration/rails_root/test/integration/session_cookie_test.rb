require File.dirname(__FILE__) + '/../test_helper'

integration_test do
  
  get "/models"
  expect(cookies["_rails_root_session"]) != ""
  cookies.delete("_rails_root_session")
  
  testing "" do
    get "/models"
  end
  
  expect(cookies["_rails_root_session"]) == nil
  
end