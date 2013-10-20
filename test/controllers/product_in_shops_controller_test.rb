require 'test_helper'

class ProductInShopsControllerTest < ActionController::TestCase
  setup do
    @product_in_shop = product_in_shops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_in_shops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_in_shop" do
    assert_difference('ProductInShop.count') do
      post :create, product_in_shop: { product_id: @product_in_shop.product_id, quantity: @product_in_shop.quantity, store_id: @product_in_shop.store_id }
    end

    assert_redirected_to product_in_shop_path(assigns(:product_in_shop))
  end

  test "should show product_in_shop" do
    get :show, id: @product_in_shop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_in_shop
    assert_response :success
  end

  test "should update product_in_shop" do
    patch :update, id: @product_in_shop, product_in_shop: { product_id: @product_in_shop.product_id, quantity: @product_in_shop.quantity, store_id: @product_in_shop.store_id }
    assert_redirected_to product_in_shop_path(assigns(:product_in_shop))
  end

  test "should destroy product_in_shop" do
    assert_difference('ProductInShop.count', -1) do
      delete :destroy, id: @product_in_shop
    end

    assert_redirected_to product_in_shops_path
  end
end
