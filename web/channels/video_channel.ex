defmodule Phxbook.VideoChannel do
  use Phxbook.Web, :channel

  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Repo.get(Phxbook.Video, video_id)

    annotations = Repo.all(
      from a in assoc(video, :annotations),
      where: a.id > ^last_seen_id,
      order_by: [asc: a.at, asc: a.id],
      limit: 200,
      preload: [:user]
    )

    resp = %{annotations: Phoenix.View.render_many(annotations, Phxbook.AnnotationView, "annotations.json")}
    {:ok, resp, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Phxbook.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end
  def handle_in("new_annotation", params, user, socket) do
    changeset =
      user
      |> build_assoc(:annotations, video_id: socket.assigns.video_id)
      |> Phxbook.Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast_annotation(socket, annotation)
        Task.start_link(fn -> compute_additional_info(annotation, socket) end)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{error: changeset}}, socket}
    end
  end

  intercept ["new_annotation"]
  def handle_out("new_annotation", msg, socket) do
    push socket, "new_annotation", Map.merge(msg, %{is_editable: true})
    {:noreply, socket}
  end

  defp broadcast_annotation(socket, annotation) do
    annotation = Repo.preload(annotation, :user)
    rendered_ann = Phxbook.AnnotationView.render("annotations.json", %{annotation: annotation})

    broadcast! socket, "new_annotation", rendered_ann
  end

  defp compute_additional_info(annotation, socket) do
    for result <- InfoSys.Application.compute(annotation.body, limit: 1, timeout: 10_000) do
      attrs = %{url: result.url, body: result.text, at: annotation.at}
      info_changeset =
        Repo.get_by!(Phxbook.User, username: result.backend)
        |> build_assoc(:annotations, video_id: annotation.video_id)
        |> Phxbook.Annotation.changeset(attrs)

      case Repo.insert(info_changeset) do
        {:ok, info_ann} -> broadcast_annotation(socket, info_ann)
        {:error, _changeset} -> :ignore
      end
    end
  end

end
