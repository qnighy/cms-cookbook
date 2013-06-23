#
# Cookbook Name:: cms
# Recipe:: git
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
package "git"

cms_git_path = "#{Chef::Config['file_cache_path'] || 'tmp'}/cms"
cms_git_repo = node['cms']['git']['repo']
cms_git_ref = node['cms']['git']['ref']

git cms_git_path do
  repository cms_git_repo
  reference cms_git_ref
  action :checkout
end

bash "build_cms" do
  not_if 'which cmsImporter'
  cwd cms_git_path
  code <<-EOH
    ./setup.py build &&
    ./setup.py install
  EOH
end

include_recipe "cms::commons"
