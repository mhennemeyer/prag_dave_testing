require File.dirname(__FILE__) + '/../test_helper'

def read_db_file
  File.open(RAILS_ROOT + "/db/test.sqlite3") do |f|
    f.readlines
  end
end

testing "Set the DB to its original state if an exception occurs in a testing block" do
  
  Model.destroy_all
  Sti.destroy_all
  
  # Do some db stuff:
  10.times {Model.create!; Sti.create!}
  expect(Model.count) == 10
  expect(Sti.count) == 10
  
  # Read the db/test.sqlite3 file:
  db = read_db_file
  
  testing "Modify DB and cause an error" do
    10.times {Model.create!; Sti.create!}
    begin
      testing "error" do
        nonexistent_variable.call
      end
    rescue
    end
  end
  
  expect(Model.count) == 10
  expect(Sti.count) == 10
  
  # Read the db/test.sqlite3 file again. It should be the same as before
  expect(read_db_file) == db
  
end