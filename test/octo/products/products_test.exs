defmodule Octo.ProductsTest do
  use Octo.DataCase

  alias Octo.Products

  describe "projects" do
    alias Octo.Products.Project

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Products.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Products.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Products.create_project(@valid_attrs)
      assert project.name == "some name"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, %Project{} = project} = Products.update_project(project, @update_attrs)
      assert project.name == "some updated name"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_project(project, @invalid_attrs)
      assert project == Products.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Products.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Products.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Products.change_project(project)
    end
  end

  describe "flags" do
    alias Octo.Products.Flag

    @valid_attrs %{is_on: true, name: "some name"}
    @update_attrs %{is_on: false, name: "some updated name"}
    @invalid_attrs %{is_on: nil, name: nil}

    def flag_fixture(attrs \\ %{}) do
      {:ok, flag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_flag()

      flag
    end

    test "list_flags/0 returns all flags" do
      flag = flag_fixture()
      assert Products.list_flags() == [flag]
    end

    test "get_flag!/1 returns the flag with given id" do
      flag = flag_fixture()
      assert Products.get_flag!(flag.id) == flag
    end

    test "create_flag/1 with valid data creates a flag" do
      assert {:ok, %Flag{} = flag} = Products.create_flag(@valid_attrs)
      assert flag.is_on == true
      assert flag.name == "some name"
    end

    test "create_flag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_flag(@invalid_attrs)
    end

    test "update_flag/2 with valid data updates the flag" do
      flag = flag_fixture()
      assert {:ok, %Flag{} = flag} = Products.update_flag(flag, @update_attrs)
      assert flag.is_on == false
      assert flag.name == "some updated name"
    end

    test "update_flag/2 with invalid data returns error changeset" do
      flag = flag_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_flag(flag, @invalid_attrs)
      assert flag == Products.get_flag!(flag.id)
    end

    test "delete_flag/1 deletes the flag" do
      flag = flag_fixture()
      assert {:ok, %Flag{}} = Products.delete_flag(flag)
      assert_raise Ecto.NoResultsError, fn -> Products.get_flag!(flag.id) end
    end

    test "change_flag/1 returns a flag changeset" do
      flag = flag_fixture()
      assert %Ecto.Changeset{} = Products.change_flag(flag)
    end
  end

  describe "users" do
    alias Octo.Products.User

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Products.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Products.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Products.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Products.update_user(user, @update_attrs)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_user(user, @invalid_attrs)
      assert user == Products.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Products.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Products.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Products.change_user(user)
    end
  end
end
