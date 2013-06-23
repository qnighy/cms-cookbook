#
# Cookbook Name:: cms
# Attributes:: default
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

default['cms']['services']['LogService']        = [["localhost", 29000]]
default['cms']['services']['ResourceService']   = [["localhost", 28000]]
default['cms']['services']['ScoringService']    = [["localhost", 28500]]
default['cms']['services']['Checker']           = [["localhost", 22000]]
default['cms']['services']['EvaluationService'] = [["localhost", 25000]]
default['cms']['services']['Worker']            = [["localhost", 26000], ["localhost", 26001]]
default['cms']['services']['ContestWebServer']  = [["localhost", 21000]]
default['cms']['services']['AdminWebServer']    = [["localhost", 21100]]
default['cms']['services']['TestFileCacher']    = [["localhost", 27501]]

default['cms']['contest_server'] = [{
  "host" => "localhost",
  "port" => "8888"
}]
default['cms']['admin_server'] = [{
  "host" => "localhost",
  "port" => "8889"
}]
default['cms']['ranking_server'] = [{
  "host" => "localhost",
  "port" => "8890",
  "username" => "usern4me",
  "password" => "passw0rd"
}]
default['cms']['ranking_server_id'] = 0

default['cms']['cmsuser'] = []

default['cms']['db']['password'] = "password"
default['cms']['db']['database'] = "database"
default['cms']['db']['server'] = "localhost"
default['cms']['db']['debug'] = false

default['cms']['twophase_commit'] = false
default['cms']['keep_sandbox'] = false
default['cms']['tornado_debug'] = false
default['cms']['cookie_duration'] = 10800
default['cms']['submit_local_copy'] = true
default['cms']['submit_local_copy_path'] = "%s/submissions/"
default['cms']['ip_lock'] = true
default['cms']['block_hidden_users'] = false
default['cms']['is_proxy_used'] = false
default['cms']['max_submission_length'] = 100000
default['cms']['max_input_length'] = 5000000
default['cms']['stl_path'] = "/usr/share/doc/stl-manual/html/"
default['cms']['allow_communication'] = true
default['cms']['process_cmdline'] =
  ["/usr/bin/python2", "/usr/local/bin/cms%s", "%d"]
default['cms']['color_shell_log'] = true
default['cms']['color_file_log'] = false
default['cms']['color_remote_shell_log'] = true
default['cms']['color_remote_file_log'] = true

default['cms']['secret_key'] = "8e045a51e4b102ea803c06f92841a1fb"

default['cms']['auth']['auth_types'] = ["Password"]
default['cms']['auth']['twitter_consumer_key'] = ""
default['cms']['auth']['twitter_consumer_secret'] = ""
default['cms']['auth']['facebook_app_id'] = ""
default['cms']['auth']['facebook_app_secret'] = ""
