require "test_helper"
require "informed_opinion_mcp"

class InformedOpinionMcpTest < ActiveSupport::TestCase
  test "server exposes focused tools and editorial resources" do
    with_env("INFORMED_OPINION_API_TOKEN" => "io_mod_test") do
      server = InformedOpinionMcp.server
      tool_names = server.tools.keys

      assert_includes tool_names, "list_moderation_issues"
      assert_includes tool_names, "save_opinion_proposal_edit"
      assert_includes tool_names, "decide_moderation_issue"
      assert_includes tool_names, "create_fact_questions"
      assert_includes server.resources.map(&:uri), "informed-opinion://editorial-standard"
    end
  end

  private

  def with_env(values)
    old = values.keys.to_h { |key| [ key, ENV[key] ] }
    values.each { |key, value| ENV[key] = value }
    yield
  ensure
    old.each { |key, value| ENV[key] = value }
  end
end
