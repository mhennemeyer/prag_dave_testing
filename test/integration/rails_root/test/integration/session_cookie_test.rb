require File.dirname(__FILE__) + '/../test_helper'

integration_test do
  
  get "/models"
  y session
  expect(cookies["_rails_root_session"]) != ""
  cookies.delete("_rails_root_session")
  
  testing "" do
    get "/models"
  end
  
  expect(cookies["_rails_root_session"]) == nil
  
  cookies["cookie"] = "cookie"
  testing "" do
    expect(cookies["cookie"]) == "cookie"
  end
  expect(cookies["cookie"]) == "cookie"
  
end