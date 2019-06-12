ImagesController.class_eval do 
  def index
    if params[:global_base_imagable]
      @imagable = GlobalID::Locator.locate params[:global_base_imagable]
    else
      @imagable = find_resource
    end

    if @imagable
      if @imagable.is_a?(Inspection)
        insp = @imagable.inspection
        base_imagables = [insp] + insp.elements + Defect.where(element: insp.elements)
        @images = Image.where(base_imagable: base_imagables)
      else
        @images = @imagable.images
      end

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