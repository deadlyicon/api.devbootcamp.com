module RequestDefaults

  def default_parameters
    @default_parameters ||= {}
  end

  def default_headers_or_env
    @default_headers_or_env ||= {}
  end

  alias_method :default_headers, :default_headers_or_env
  alias_method :default_env,     :default_headers_or_env

  %w{get post patch put delete head}.each do |method|
    define_method method do |path, parameters = {}, headers_or_env = {}|
      parameters = default_parameters.merge(parameters)
      headers_or_env = default_headers_or_env.merge(headers_or_env)
      super(path, parameters, headers_or_env)
    end
  end

end
