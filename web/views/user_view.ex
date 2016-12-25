defmodule Phxbook.UserView do
  use Phxbook.Web, :view
  alias Phxbook.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

end