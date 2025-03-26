class OrganisationType
  DATA = {
    department: { name: "Department" },
    other: { name: "Other" },
  }.freeze

  cattr_accessor(:instances) { {} }

  def self.get(key)
    key = key.to_sym
    raise KeyError, "#{key} is not a known organisation type." if DATA[key].nil?

    instances[key] ||= new(key, DATA[key])
  end

  def self.all
    DATA.keys.map { |key| get(key) }
  end

  def self.valid_keys
    DATA.keys
  end

  attr_reader :key, :name

  def initialize(key, data)
    @key = key
    @name = data[:name]
  end
end
