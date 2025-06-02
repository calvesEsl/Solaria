require "test_helper"

class AssistantControllerTest < ActionDispatch::IntegrationTest
  test "should get chatbot" do
    get assistant_chatbot_url
    assert_response :success
  end
end
