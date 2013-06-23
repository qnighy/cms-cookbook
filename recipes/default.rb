#
# Cookbook Name:: cms
# Recipe:: default
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

include_recipe "cms::prepare"

cms_file_path = "#{Chef::Config['file_cache_path'] || '/tmp'}/cms-v1.0.0.tar.gz"
cms_url = "https://github.com/cms-dev/cms/archive/v1.0.0.tar.gz"

remote_file cms_url do
  source cms_url
  checksum "c02f829482a7e75d6a2ea23fabcb62f2c7b4ba85544546dbaa4cc0ce8c49422e"
  path cms_file_path
  backup false
end

bash "build_cms" do
  not_if 'which cmsImporter'
  cwd ::File.dirname(cms_file_path)
  code <<-EOH
    tar zxf #{cms_file_path} -C #{::File.dirname(cms_file_path)} &&
    cd cms-1.0.0 &&
    ./setup.py build &&
    ./setup.py install
  EOH
end

include_recipe "cms::commons"
