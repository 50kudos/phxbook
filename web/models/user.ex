defmodule Phxbook.User do
  use Phxbook.Web, :model
  alias Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :videos, Phxbook.Video
    has_many :annotations, Phxbook.Annotation

    timestamps()
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w(name username))
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> validate_length(:username, min: 1, max: 20)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password))
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
