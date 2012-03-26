Factory.define :database do |s|
  s.name "database-01"
  s.type "postgres"
  s.server_ids { [Factory(:server).id] }
end

Factory.define :oracle, parent: :database do |s|
  s.name "database-02"
  s.type "oracle"
  s.server_ids { [Factory(:virtual).id] }
end
