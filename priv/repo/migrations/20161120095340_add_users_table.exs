defmodule More.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :user_name, :string, size: 64
      add :profile_picture, :string, size: 255
      add :ig_user_id, :string, size: 64
      add :ig_access_token, :binary
      timestamps
    end
  end
end
