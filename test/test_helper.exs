Code.require_file "../../info_sys/test/backends/http_client.exs", __DIR__
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Phxbook.Repo, :manual)
