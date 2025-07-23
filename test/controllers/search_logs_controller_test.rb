require "test_helper"

class SearchLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @session_id = "test-session-123"
    @ip = "127.0.0.1"
  end

  test "should log a search" do
    assert_difference("SearchLog.count", 1) do
      post "/search_logs", params: { query: "apple", session_id: @session_id }, as: :json
    end
    assert_response :success
  end

  test "should replace last log if query is extension" do
    post "/search_logs", params: { query: "hello", session_id: @session_id }, as: :json
    assert_difference("SearchLog.count", 0) do
      post "/search_logs", params: { query: "hello world", session_id: @session_id }, as: :json
    end
    assert_response :success
    last_log = SearchLog.where(session_id: @session_id, ip_address: @ip).order(created_at: :desc).first
    assert_equal "hello world", last_log.query
  end

  test "should not replace last log if query is not extension" do
    post "/search_logs", params: { query: "hello", session_id: @session_id }, as: :json
    assert_difference("SearchLog.count", 1) do
      post "/search_logs", params: { query: "bye", session_id: @session_id }, as: :json
    end
    assert_response :success
  end

  test "should return analytics and recent" do
    post "/search_logs", params: { query: "apple", session_id: @session_id }, as: :json
    post "/search_logs", params: { query: "banana", session_id: @session_id }, as: :json
    get "/search_logs"
    assert_response :success
    body = JSON.parse(response.body)
    assert body["analytics"].any? { |a| a["query"] == "apple" }
    assert body["analytics"].any? { |a| a["query"] == "banana" }
    assert body["recent"].any? { |r| r["query"] == "banana" }
  end
end 