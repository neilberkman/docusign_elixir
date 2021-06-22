defmodule DocuSign.EnvHelper do
  @moduledoc false

  def put_env(app, key, value) do
    previous_value = Application.get_env(app, key)
    Application.put_env(app, key, value)

    ExUnit.Callbacks.on_exit(fn ->
      if is_nil(previous_value) do
        Application.delete_env(app, key)
      else
        Application.put_env(app, key, previous_value)
      end
    end)
  end
end
