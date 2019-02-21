class PhotosController < ApplicationController

  get '/yawdsales/:id/photos/edit' do
    @yawdsale = Yawdsale.find_by_id(params[:id])
    @num_upload_fields = 3 - @yawdsale.photos.count

    erb :'/photos/edit'
  end

  get '/yawdsales/:id/photos/:photo_id' do
    @yawdsale = Yawdsale.find_by_id(params[:id])
    @photo = Photo.find_by_id(params[:photo_id])

    erb :'/photos/show_photo'
  end

  post '/yawdsales/:id/photos' do
    @yawdsale = Yawdsale.find_by_id(params[:id])

    path = "./public/yawdsales/#{@yawdsale.id}/photos"
    FileUtils.mkdir_p path

    params[:photos].each do |photo|
      filename = photo[:filename]
      file = photo[:tempfile]

      new_photo = Photo.create(filename: filename)
      @yawdsale.photos << new_photo

      File.write("#{path}/#{new_photo.id}", file.read)
    end

    redirect "/yawdsales/#{@yawdsale.id}"
  end

  delete '/yawdsales/:id/photos/:photo_id' do
    @yawdsale = Yawdsale.find_by_id(params[:id])
    @photo = Photo.find_by_id(params[:photo_id])

    path = "./public/yawdsales/#{@yawdsale.id}/photos/#{@photo.id}"
    FileUtils.rm(path)
    Photo.delete(@photo)

    redirect "/yawdsales/#{@yawdsale.id}/photos/edit"
  end


end
