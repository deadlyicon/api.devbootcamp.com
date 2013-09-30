class Dbc::Resource

  include Dbc::Dependant

  def self.permittable_attributes *permittable_attributes
    @permittable_attributes = permittable_attributes.flatten.map(&:to_s).uniq if permittable_attributes.present?
    @permittable_attributes ||= []
  end

  def self.resource_name resource_name=nil
    @resource_name = resource_name.to_s.underscore if !resource_name.nil?
    @resource_name || name.sub('Dbc::','').underscore.pluralize
  end

  def self.model_name model_name=nil
    @model_name = model_name if !model_name.nil?
    @model_name || resource_name.singularize
  end

  def self.model model=nil
    @model = model if !model.nil?
    @model || Dbc.const_get(model_name.classify)
  end

  def self.serializer serializer=nil
    @serializer = serializer if !serializer.nil?
    @serializer || const_get(:Serializer)
  end

  delegate :model, :permittable_attributes, :resource_name, :model_name, to: :class

  def sanatize_attributes attributes
    attributes.stringify_keys!.slice! *permittable_attributes
  end

  def serializer
    @serializer ||= self.class.serializer.new(dbc)
  end

  def serialize records
    records.respond_to?(:map) ? records.map(&serializer) : serializer.serialize(records)
  end


  def all
    can! :index, resource_name
    serialize model.all
  end

  def create attributes={}
    can! :create, resource_name
    sanatize_attributes(attributes)
    record = model.create(attributes)
    return serialize(record) if record.errors.empty?
    raise Dbc::ValidationError, serialize(record)
  end

  def show id
    can! :show, model_name, id: id
    user = model.find(id)
    serialize user
  end

  def update id, attributes={}
    can! :update, model_name, id: id
    record = model.find(id)
    sanatize_attributes(attributes)
    record.update_attributes(attributes)
    return serialize(record) if record.errors.empty?
    raise Dbc::ValidationError, serialize(record)
  end

  def destroy id
    can! :destroy, model_name, id: id
    record = model.find(id)
    record.destroy
    serialize record
  end

end
