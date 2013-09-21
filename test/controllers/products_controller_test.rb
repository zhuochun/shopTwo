require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { barcode: @product.barcode, bundle_unit: @product.bundle_unit, category_id: @product.category_id, cost_price: @product.cost_price, cost_price: @product.cost_price, current_stock: @product.current_stock, daily_price: @product.daily_price, daily_price: @product.daily_price, manufacturer_id: @product.manufacturer_id, minimum_stock: @product.minimum_stock, name: @product.name }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { barcode: @product.barcode, bundle_unit: @product.bundle_unit, category_id: @product.category_id, cost_price: @product.cost_price, cost_price: @product.cost_price, current_stock: @product.current_stock, daily_price: @product.daily_price, daily_price: @product.daily_price, manufacturer_id: @product.manufacturer_id, minimum_stock: @product.minimum_stock, name: @product.name }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end
end
