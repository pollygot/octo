defmodule Octo.Products.UserFlag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octo.Products.{User, Flag}

  schema "users_flags" do
    field :is_on, :boolean, default: false
    belongs_to :user, User
    belongs_to :flag, Flag

    timestamps()
  end

  @doc false
  def changeset(user_flag, attrs) do
    user_flag
    |> cast(attrs, [:is_on])
    |> validate_required([:is_on, :user_id, :flag_id])
  end
end
