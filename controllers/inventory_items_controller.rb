require './models/inventory_item.rb'
require './models/manufacturer.rb'

get '/inventory' do
  @manufacturers = Manufacturer.all
  @inventory = InventoryItem.all_with_manufacturer_name params['manufacturer_id']
  @man_id = params['manufacturer_id'].to_i
  erb :"inventory_items/index"
end

get '/inventory/new' do
  @manufacturers = Manufacturer.all
  erb :"inventory_items/new"
end

post '/inventory/new' do
  new_item = InventoryItem.new(params)
  new_item.save
  redirect to "/inventory/#{new_item.id}"
end

get '/inventory/:id' do
  @item = InventoryItem.get_by_id params[:id].to_i
  erb :"inventory_items/show"
end

post '/inventory/:id/delete' do
  item = InventoryItem.get_by_id params[:id].to_i
  item.delete
  redirect to '/inventory'
end

get '/inventory/:id/edit' do
  @item = InventoryItem.get_by_id params[:id].to_i
  @manufacturers = Manufacturer.all
  erb :"inventory_items/edit"
end

post '/inventory/:id/edit' do
  item = InventoryItem.new params
  item.update
  redirect to "/inventory/#{item.id}"
end
