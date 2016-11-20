defmodule More.UserService do
  alias Ecto.Multi
  import Ecto.Query, only: [from: 2]

  def login(user_changeset) do
    multi = Multi.new

    ig_user_id = user_changeset.params["ig_user_id"]
    query =
      from u in More.User,
        where: u.ig_user_id == ^ig_user_id
    result = query |> More.Repo.one

    case result do
      nil ->
        multi
        |> Multi.insert(:user, user_changeset)
      user ->
        multi
        |> Multi.update(
          :user,
          More.User.login_changeset(user, user_changeset.params)
        )
    end
  end
end
