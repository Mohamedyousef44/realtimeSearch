require "test_helper"

class SearchLogTest < ActiveSupport::TestCase
  test "should not save search_log without query" do
    log = SearchLog.new(session_id: "abc123", ip_address: "1.2.3.4")
    assert_not log.save, "Saved the search_log without a query"
  end

  test "should not save search_log without session_id" do
    log = SearchLog.new(query: "test", ip_address: "1.2.3.4")
    assert_not log.save, "Saved the search_log without a session_id"
  end

  test "should not save search_log without ip_address" do
    log = SearchLog.new(query: "test", session_id: "abc123")
    assert_not log.save, "Saved the search_log without an ip_address"
  end

  test "should save search_log with all required attributes" do
    log = SearchLog.new(query: "test", session_id: "abc123", ip_address: "1.2.3.4")
    assert log.save, "Did not save the search_log with all required attributes"
  end
end
