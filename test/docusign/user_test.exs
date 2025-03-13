defmodule DocuSign.UserTest do
  use ExUnit.Case, async: true

  alias DocuSign.User

  import DocuSign.ProcessHelper

  setup do
    {:ok, pid} = DocuSign.ClientRegistry.start_link(oauth_impl: DocuSign.OAuth.Fake)
    on_exit(fn -> assert_down(pid) end)
  end

  describe "getting user info from client" do
    # In v2.0, we removed the ability to call User.info() without a client

    test "client returns user info" do
      client = DocuSign.ClientRegistry.client(":user-id:")

      result = User.info(client)

      assert %DocuSign.User{
               created: "2018-09-07T23:49:34.163",
               email: ":email:",
               family_name: ":family-name:",
               given_name: ":given-name:",
               name: ":name:",
               sub: ":user-id:",
               accounts: [
                 %DocuSign.User.AppAccount{
                   account_id: ":account-id:",
                   account_name: ":account-name:",
                   base_uri: "https://demo.docusign.net",
                   is_default: true
                 }
               ]
             } = result
    end
  end
end
