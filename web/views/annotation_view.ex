defmodule Phxbook.AnnotationView do
  use Phxbook.Web, :view

  def render("annotations.json", %{annotation: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, Phxbook.UserView, "user.json")
    }
  end
end
