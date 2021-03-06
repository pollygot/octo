defmodule Octo.Products.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octo.Products.Flag

  schema "users" do
    field :identifier, :string
    belongs_to :project, Octo.Products.Project
    many_to_many :flags, Flag, join_through: Octo.Products.UserFlag, on_delete: :delete_all


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:identifier, :project_id])
    |> validate_required([:identifier, :project_id])
  end
end
