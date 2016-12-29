# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Phxbook.Repo.insert!(%Phxbook.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Phxbook.Repo
alias Phxbook.Category


for category <- ~w(Action Drama Comedy Romance Sci-fi) do
  Repo.get_by(Category, name: category) || Repo.insert!(%Category{name: category})
end
