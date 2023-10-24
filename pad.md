<%= button_to 'Fetch Data', url_for(action: 'fetch_product_data', controller: 'products', id: @product), method: :post, class: 'btn btn-primary' %>

Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOlsiaHR0cHM6Ly93d3cuZWNpZ21hZmlhLmNvbSJdLCJlYXQiOjE2OTgyMzA2OTMsImlhdCI6MTY5ODA1Nzg5MywiaXNzIjoiQkMiLCJzaWQiOjk5OTcwNTkzOCwic3ViIjoiYmNhcHAubGlua2VyZCIsInN1Yl90eXBlIjowLCJ0b2tlbl90eXBlIjoxfQ.cY55gRQfc89_xRCTl0tN3UUvGvUh2nN3suaNEWjrzQDEWxVUDTyvEQL8NeCISKPKXroMchizPUMpCUA_z1cHlg

# good

class ProductsController < ApplicationController
before_action :set_product, only: %i[ show edit update destroy ]

# GET /products or /products.json

def index
@products = Product.all
end

# GET /products/1 or /products/1.json

def show
end

# GET /products/new

def new
@product = Product.new
end

# GET /products/1/edit

def edit
end

# POST /products or /products.json

def create
@product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end

end

# PATCH/PUT /products/1 or /products/1.json

def update
respond_to do |format|
if @product.update(product_params)
format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
format.json { render :show, status: :ok, location: @product }
else
format.html { render :edit, status: :unprocessable_entity }
format.json { render json: @product.errors, status: :unprocessable_entity }
end
end
end

# DELETE /products/1 or /products/1.json

def destroy
@product.destroy!

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end

end

def fetch_product_price
entity_id = params[:entity_id]

    # Replace the following query with your actual GraphQL query.

graphql_query = <<~GRAPHQL
{
site {
products(entityIds: 1) {
edges {
node {
name
prices {
price {
value
currencyCode
}
}
}
}
}
}
}
GRAPHQL

    authorization_token = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOlsiaHR0cHM6Ly93d3cuZWNpZ21hZmlhLmNvbSJdLCJlYXQiOjE2OTgyMzA2OTMsImlhdCI6MTY5ODA1Nzg5MywiaXNzIjoiQkMiLCJzaWQiOjk5OTcwNTkzOCwic3ViIjoiYmNhcHAubGlua2VyZCIsInN1Yl90eXBlIjowLCJ0b2tlbl90eXBlIjoxfQ.cY55gRQfc89_xRCTl0tN3UUvGvUh2nN3suaNEWjrzQDEWxVUDTyvEQL8NeCISKPKXroMchizPUMpCUA_z1cHlg'  # Replace with your actual token

    response = HTTParty.post('https://ecigmafia.com/graphql', body: { query: graphql_query }.to_json, headers: { 'Authorization' => authorization_token, 'Content-Type' => 'application/json' })

    data = JSON.parse(response.body)
    Rails.logger.debug(data) # Add this line to log the response

    if data['data'] && data['data']['site']['products']['edges'].present?
      product_data = data['data']['site']['products']['edges'].first['node']

      @product_price = product_data['prices']['price']['value']
      @product_name = product_data['name']

      flash[:notice] = 'Product price fetched successfully.'
    else
      flash[:alert] = 'No product data found for this entity ID.'
    end

    # Render the 'product_price_page' view with @product_name and @product_price
    render 'product_price_page'

rescue StandardError => e
flash[:alert] = "Error fetching product price: #{e.message}"
render 'product_price_page'
end

private # Use callbacks to share common setup or constraints between actions.
def set_product
@product = Product.find(params[:id])
end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :price, :entity_id)
    end

end

# build no

class ProductsController < ApplicationController
before_action :set_product, only: %i[ show edit update destroy ]

# GET /products or /products.json

def index
@products = Product.all
end

# GET /products/1 or /products/1.json

def show
end

# GET /products/new

def new
@product = Product.new
end

# GET /products/1/edit

def edit
end

# POST /products or /products.json

def create
@product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end

end

# PATCH/PUT /products/1 or /products/1.json

def update
respond_to do |format|
if @product.update(product_params)
format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
format.json { render :show, status: :ok, location: @product }
else
format.html { render :edit, status: :unprocessable_entity }
format.json { render json: @product.errors, status: :unprocessable_entity }
end
end
end

# DELETE /products/1 or /products/1.json

def destroy
@product.destroy!

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end

end

def fetch_product_price
entity_id = params[:product][:entity_id]
graphql_query = <<~GRAPHQL
{
site {
products(entityIds: 1) {
edges {
node {
name
prices {
price {
value
currencyCode
}
}
}
}
}
}
GRAPHQL

authorization_token = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOlsiaHR0cHM6Ly93d3cuZWNpZ21hZmlhLmNvbSJdLCJlYXQiOjE2OTgyMzA2OTMsImlhdCI6MTY5ODA1Nzg5MywiaXNzIjoiQkMiLCJzaWQiOjk5OTcwNTkzOCwic3ViIjoiYmNhcHAubGlua2VyZCIsInN1Yl90eXBlIjowLCJ0b2tlbl90eXBlIjoxfQ.cY55gRQfc89_xRCTl0tN3UUvGvUh2nN3suaNEWjrzQDEWxVUDTyvEQL8NeCISKPKXroMchizPUMpCUA_z1cHlg'

response = HTTParty.post('https://ecigmafia.com/graphql', body: { query: graphql_query }.to_json, headers: { 'Authorization' => authorization_token, 'Content-Type' => 'application/json' })

data = JSON.parse(response.body)

if data['data'] && data['data']['site']['products']['edges'].present?
product_data = data['data']['site']['products']['edges'].first['node']

    @product_name = product_data['name']
    @product_price = product_data['prices']['price']['value']

    flash[:notice] = 'Product price fetched successfully.'

else
flash[:alert] = 'No product data found for this entity ID.'
end

# Build a new Product instance with the fetched data and populate the form

@product = Product.new(name: @product_name, price: @product_price, entity_id: entity_id)

render 'new'
rescue StandardError => e
flash[:alert] = "Error fetching product price: #{e.message}"
render 'new'
end

private # Use callbacks to share common setup or constraints between actions.
def set_product
@product = Product.find(params[:id])
end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :price, :entity_id)
    end

end
