defmodule Phxbook.Annotation do
  use Phxbook.Web, :model

  schema "annotations" do
    field :body, :string
    field :at, :integer
    belongs_to :user, Phxbook.User
    belongs_to :video, Phxbook.Video

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :at])
    |> validate_required([:body, :at])
  end
end
