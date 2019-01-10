defmodule Octo.Products.Flag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "flags" do
    field :is_on, :boolean, default: false
    field :name, :string
    belongs_to :project, Octo.Products.Project

    timestamps()
  end

  @doc false
  def changeset(flag, attrs) do
    flag
    |> cast(attrs, [:name, :is_on, :project_id])
    |> validate_required([:name, :is_on, :project_id])
  end
end
