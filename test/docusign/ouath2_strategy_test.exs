defmodule DocuSign.OAuth2StrategyTest do
  use ExUnit.Case
  alias DocuSign.OAuth2Strategy
  alias OAuth2.{Client, AccessToken}

  test "token_expired?" do
    token = %AccessToken{expires_at: :os.system_time(:seconds) - 30}
    assert OAuth2Strategy.token_expired?(nil)
    assert OAuth2Strategy.token_expired?(token)
    assert OAuth2Strategy.token_expired?(%Client{token: token})
  end
end
