require './models/manufacturer.rb'

get '/manufacturers' do
  @manufacturers = Manufacturer.all
  @man_city = params['city']
  if @man_city == nil
    @to_display = @manufacturers
  else
    @to_display = @manufacturers.select {|man| man.city == @man_city}
  end
  erb :"manufacturers/index"
end

get '/manufacturers/new' do
  erb :"manufacturers/new"
end

post '/manufacturers/new' do
  new_manufacturer = Manufacturer.new(params)
  new_manufacturer.save
  redirect to "/manufacturers/#{new_manufacturer.id}"
end

get '/manufacturers/:id' do
  @manufacturer = Manufacturer.get_by_id params[:id].to_i
  erb :"manufacturers/show"
end

post '/manufacturers/:id/delete' do
  manufacturer = Manufacturer.get_by_id params[:id].to_i
  manufacturer.delete
  redirect to '/manufacturers'
end

get '/manufacturers/:id/edit' do
  @manufacturer = Manufacturer.get_by_id params[:id].to_i
  erb :"manufacturers/edit"
end

post '/manufacturers/:id/edit' do
  manufacturer = Manufacturer.new params
  manufacturer.update
  redirect to "/manufacturers/#{manufacturer.id}"
end
