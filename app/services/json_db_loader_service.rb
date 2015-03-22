class JsonDbLoaderService
  def self.load
    JSON.parse(IO.read(Rails.root.join('db', 'data.json')))
  end
end
