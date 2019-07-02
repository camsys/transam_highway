ImagesController.class_eval do

  authorize_resource only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:global_base_imagable]
      @imagable = GlobalID::Locator.locate(GlobalID.parse(params[:global_base_imagable]))
      @images = Image.where(base_imagable: @imagable)
    elsif params[:global_any_imagable] # parameter to return images of self as parent and children
      @imagable = GlobalID::Locator.locate(GlobalID.parse(params[:global_base_imagable]))
      @images = Image.where(base_imagable: @imagable).or(Image.where(imagable: @imagable))
    else
      @imagable = find_resource
      @images = @imagable.images
    end


    if @imagable

      if params[:sort].present? && params[:order].present?
        if params[:sort] == 'creator'
          @images = @images.joins(:creator).reorder("CONCAT(users.first_name, ' ', users.last_name) #{params[:order]}")
        else
          @images = @images.reorder(params[:sort] => params[:order])
        end
      end
    else
      @images = Image.none
    end

    @images = @images.left_outer_joins(:image_classification)

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        render :json => {
            :total => @images.count,
            :rows => @images.limit(params[:limit]).offset(params[:offset]).collect{ |u|
              if u.base_imagable_type == 'Element'
                element_definition = u.base_imagable.element_definition&.number
              end
              if u.base_imagable_type == 'Defect'
                element_definition = u.base_imagable.element&.element_definition&.number
                defect_definition = u.base_imagable.defect_definition&.number
              end

              u.as_json.merge!({
                element_definition: element_definition,
                defect_definition: defect_definition,
                classification: u.image_classification&.to_s,
                link_image: view_context.link_to(view_context.image_tag(u.image.url(:thumb)), u.image.url,  :class => "img-responsive gallery-image", :data => {:lightbox => "gallery"}, :title => u.original_filename),
                imagable_to_s: u.imagable.to_s,
                creator: u.creator.to_s
               })
            }
        }
      }

    end

  end

  private 

  def form_params
    params.require(:image).permit(Image.allowable_params + [:condition_state])
  end 
end