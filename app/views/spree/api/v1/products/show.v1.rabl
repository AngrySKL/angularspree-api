if request.headers['ng-api'] == 'true'
  object @product => :data
  extends 'spree/api/v1/products/ng_show', root: :data
else
  object @product
  cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object, 'spree-api']
  attributes *product_attributes
  
  node(:display_price) { |p| p.display_price.to_s }
  node(:has_variants, &:has_variants?)
  node(:taxon_ids, &:taxon_ids)
  
  child master: :master do
    extends 'spree/api/v1/variants/small'
  end
  
  child variants: :variants do
    extends 'spree/api/v1/variants/small'
  end
  
  child option_types: :option_types do
    attributes *option_type_attributes
  end
  
  child product_properties: :product_properties do
    attributes *product_property_attributes
  end
  
  child classifications: :classifications do
    attributes :taxon_id, :position
  
    child(:taxon) do
      extends 'spree/api/v1/taxons/show'
    end
  end
end
