#
# Cookbook Name:: cms
# Recipe:: commons
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

template "cms.conf" do
  path "/usr/local/etc/cms.conf"
  source "cms_conf.erb"
  owner "cmsuser"
  group "cmsuser"
  mode 00660
end

template "cms.ranking.conf" do
  path "/usr/local/etc/cms.ranking.conf"
  source "cms_ranking_conf.erb"
  owner "cmsuser"
  group "cmsuser"
  mode 00660
end

node['cms']['cmsuser'].each do|username|
  group "cmsuser" do
    action :modify
    members username
    append true
  end
end
