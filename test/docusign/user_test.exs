defmodule DocuSign.UserTest do
  use ExUnit.Case, async: true

  import DocuSign.ProcessHelper

  alias DocuSign.OAuth.Fake
  alias DocuSign.User
  alias DocuSign.User.AppAccount

  setup do
    {:ok, pid} = DocuSign.ClientRegistry.start_link(oauth_impl: Fake)
    on_exit(fn -> assert_down(pid) end)
  end

  describe "getting user info from client" do
    # In v2.0, we removed the ability to call User.info() without a client

    test "client returns user info" do
      client = DocuSign.ClientRegistry.client(":user-id:")

      result = User.info(client)

      assert %DocuSign.User{
               accounts: [
                 %AppAccount{
                   account_id: ":account-id:",
                   account_name: ":account-name:",
                   base_uri: "https://demo.docusign.net",
                   is_default: true
                 }
               ],
               created: "2018-09-07T23:49:34.163",
               email: ":email:",
               family_name: ":family-name:",
               given_name: ":given-name:",
               name: ":name:",
               sub: ":user-id:"
             } = result
    end
  end
end
