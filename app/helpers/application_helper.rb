module ApplicationHelper
  def eval_cancan_action(action)
    case action.to_s
      when "index", "show", "search"
        cancan_action = "read"
      when "create", "new"
        cancan_action = "create"
      when "edit", "update"
        cancan_action = "update"
      when "delete", "destroy"
        cancan_action = "delete"
      else
        cancan_action = action.to_s
    end
    return cancan_action
  end
  
  def i18n_set? key
    I18n.t key, :raise => true rescue false
  end

  def t_editing_model(model)
    t_model(model, :editing)
  end
  
  def t_showing_model(model)
    t_model(model, :showing, :one)
  end
  
  def t_create_model(model)
    t_model(model, :create)
  end
  
  def t_creating_model(model)
    t_model(model, :creating)
  end
  
  def t_listing_model(model)
    t_model(model, :listing, :other)
  end
  
  def t_model_created(model)
    t_model(model, :created)
  end
  
  def t_model_updated(model)
    t_model(model, :updated)
  end
  
  def t_model_destroyed(model)
    t_model(model, :destroyed)
  end
  
  def t_attr_model(model, attr)
    model = model.to_s
    attr = attr.to_s
    
    translate_key = "simple_form.labels.#{model}.#{attr}"
    
    if i18n_set? translate_key
      attr_desc = t translate_key
    else
      attr_desc = attr.to_s.camelize
    end
    puts translate_key
    puts attr_desc
    return attr_desc
  end
  
  def t_model_name(model, plur = :one)
    model = model.to_s
    plur = plur.to_s
    key_model = "activerecord.models.#{model}.#{plur}"
    
    if i18n_set? key_model
      model_desc = t(key_model)
    else
      if plur == 'one'
        model_desc = model.camelize
      else
        model_desc = model.pluralize.camelize
      end
    end
    return model_desc
  end
  
  private
    def t_model(model, action, plur = :one)
      model = model.to_s
      action = action.to_s
      plur = plur.to_s
      
      model_desc = t_model_name model, plur
      
      translate_key = "app.#{action}_model"
      
      if i18n_set? translate_key
        desc = t translate_key, model: model_desc
      else
        desc = "#{action.camelize} #{model_desc}"
      end
      
      desc
    end
    
    
end
