defmodule SmokeShop.ProductsTest do
  use SmokeShop.DataCase

  alias SmokeShop.Products

  describe "products" do
    alias SmokeShop.Products.Product

    @valid_attrs %{name: "some name", street_name: "some street_name", url: "some url"}
    @update_attrs %{name: "some updated name", street_name: "some updated street_name", url: "some updated url"}
    @invalid_attrs %{name: nil, street_name: nil, url: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.name == "some name"
      assert product.street_name == "some street_name"
      assert product.url == "some url"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Products.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.name == "some updated name"
      assert product.street_name == "some updated street_name"
      assert product.url == "some updated url"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
