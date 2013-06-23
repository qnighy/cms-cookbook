#
# Cookbook Name:: cms
# Recipe:: db
#
# Copyright 2013, Masaki Hara
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"
include_recipe "postgresql::client"
include_recipe "postgresql::server"
if system("which make")!=0
  # TODO: ad-hoc for postgresql::ruby
  system("sudo apt-get install build-essential -y")
end
include_recipe "postgresql::ruby"
include_recipe "database"

postgresql_connection_info = {
  :host => "localhost",
  :port => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

database_user 'cmsuser' do
  connection postgresql_connection_info
  password node['cms']['db']['password']
  provider Chef::Provider::Database::PostgresqlUser
  action :create
end

database node['cms']['db']['database'] do
  connection postgresql_connection_info
  provider Chef::Provider::Database::Postgresql
  owner 'cmsuser'
  action :create
end

database "give some privileges I" do
  connection postgresql_connection_info
  provider Chef::Provider::Database::Postgresql
  database_name node['cms']['db']['database']
  sql 'ALTER SCHEMA public OWNER TO cmsuser'
  action :query
end
database "give some privileges II" do
  connection postgresql_connection_info
  provider Chef::Provider::Database::Postgresql
  database_name node['cms']['db']['database']
  sql 'GRANT SELECT ON pg_largeobject TO cmsuser'
  action :query
end
