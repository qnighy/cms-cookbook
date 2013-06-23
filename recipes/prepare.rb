#
# Cookbook Name:: cms
# Recipe:: prepare
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

%w{ fp-compiler
gettext python2.7 python-setuptools python-tornado python-psycopg2
python-simplejson python-sqlalchemy python-psutil python-netifaces
python-crypto python-tz python-six iso-codes shared-mime-info
stl-manual python-beautifulsoup python-mechanize python-coverage
python-yaml cgroup-lite }.each do|dep|
  package dep
end

node['cms']['services'] \
    ['ContestWebServer'].zip(node['cms']['contest_server']).each do|(ci,cs)|
  if ci[0] != cs["host"]
    Chef::Application.fatal!("hostname of ContestWebServer does not match")
  end
end
