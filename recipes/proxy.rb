#
# Cookbook Name:: cms
# Recipe:: proxy
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

include_recipe "nginx"
include_recipe "htpasswd"

if node['cms']['proxy_contest']['username']
  htpasswd "#{node['nginx']['dir']}/htpasswd-cms-contest" do
    user node['cms']['proxy_contest']['username']
    password node['cms']['proxy_contest']['password']
  end
end

if node['cms']['proxy_ranking']['username']
  htpasswd "#{node['nginx']['dir']}/htpasswd-cms-ranking" do
    user node['cms']['proxy_ranking']['username']
    password node['cms']['proxy_ranking']['password']
  end
end

if node['cms']['proxy_admin']['username']
  htpasswd "#{node['nginx']['dir']}/htpasswd-cms-admin" do
    user node['cms']['proxy_admin']['username']
    password node['cms']['proxy_admin']['password']
  end
end

template "cms.conf" do
  path "#{node['nginx']['dir']}/sites-available/cms"
  source "nginx_site.erb"
  owner "root"
  group "root"
  mode 00644
end

nginx_site "cms" do
  enable true
end

