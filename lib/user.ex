defmodule More.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "user" do
    field :user_name, :string
    field :profile_picture, :string
    field :ig_user_id, :string
    field :ig_access_token, :binary
    timestamps
  end

  def login_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:user_name, :profile_picture, :ig_user_id, :ig_access_token])
    |> validate_required([:user_name, :profile_picture, :ig_user_id, :ig_access_token])
  end
end
