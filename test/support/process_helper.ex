defmodule DocuSign.ProcessHelper do
  @moduledoc false

  defmacro assert_down(pid) do
    quote do
      # As suggested here:
      # https://elixirforum.com/t/how-to-stop-otp-processes-started-in-exunit-setup-callback/3794/5
      ref = Process.monitor(unquote(pid))
      assert_receive({:DOWN, ^ref, _, _, _})
    end
  end
end
