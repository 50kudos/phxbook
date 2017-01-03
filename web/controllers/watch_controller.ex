defmodule Phxbook.WatchController do
  use Phxbook.Web, :controller
  alias Phxbook.Video

  def show(conn, %{"id" => id}) do
    video = Repo.get(Video, id)
    render conn, "show.html", video: video
  end
end
