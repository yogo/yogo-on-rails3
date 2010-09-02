class Yogo::ItemsController < Yogo::BaseController
  defaults :collection_name => 'items',
           :instance_name => 'items'
  
  belongs_to :project, :parent_class => Yogo::Project, :finder => :get, :collection_name => :data_collections
  belongs_to :data_collection, :parent_class => Yogo::Collection::Data, :finder => :get, :param => :collection_id
  
  def paginated_scope(relation)
    instance_variable_set("@items", relation.paginate(:page => params[:page], :per_page => 25))
  end
  hide_action :paginated_scope
  
  protected
  
  def collection
    @items ||= end_of_association_chain.all #paginate(:page => params[:page], :per_page => 25)
  end
  
  def resource
    @item ||= collection.get(params[:id])
  end
  
  def build_resource
    if data = parsed_body
      item_data = data['data'] || {}
      get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build, data || {}))
    else
      super
    end
  end
  
  def update_resource(object, attributes)
    attributes = attributes || parsed_body
    attributes.delete('id')
    attributes = attributes['data'] || {}
    attr_keys = object.attributes.keys.map{|key| key.to_s }
    valid_attributes = attributes.inject({}) {|h,(k,v)| h[k]=v if attr_keys.include?(k); h }
    object.attributes = valid_attributes
    object.save
  end
  
  with_responder do
    def resource_json(item)
      data_collection = controller.send(:parent)
      project = data_collection.project
      
      hash = {}
      hash[:data] = item.as_json
      hash[:uri] = controller.send(:yogo_project_collection_item_path, project, data_collection, item)
      hash[:data_collection] = controller.send(:yogo_project_collection_path, project, data_collection)
      hash
    end
  end
  
  with_responder do
    def csv_header
      data_collection = controller.send(:parent)
      data_collection.schema.map{|s| s.name }.join(',') << "\n"
    end
    
    def resource_csv(resource)
      data_collection = controller.send(:parent)
      result = ''
      resource.each do |item|
        result << data_collection.schema.map{|s| item.send(s.to_s) }.join(',') << "\n"
      end
      result
    end
  end

  private
    
  def method_for_association_build
    :new
  end
  
end