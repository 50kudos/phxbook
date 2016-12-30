defmodule Phxbook.VideoViewTest do
  use Phxbook.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    videos = [%Phxbook.Video{id: 1, title: "dogs"},
              %Phxbook.Video{id: 2, title: "cats"}]

    content = render_to_string(Phxbook.VideoView, "index.html", conn: conn,
      videos: videos)

    assert String.contains?(content, "Listing videos")
    for video <- videos, do: assert String.contains?(content, video.title)
  end

  test "renders new.html", %{conn: conn} do
    changeset = Phxbook.Video.changeset(%Phxbook.Video{})
    categories = [{"cats", 123}]

    content = render_to_string(Phxbook.VideoView, "new.html", conn: conn,
      changeset: changeset, categories: categories)

    assert String.contains?(content, "New video")
  end
end
