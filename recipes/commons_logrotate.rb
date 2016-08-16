#
# Cookbook Name:: nginx
# Recipe:: common/conf
#
# Author:: AJ Christensen <aj@junglist.gen.nz>
#
# Copyright 2008-2013, Opscode, Inc.
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

logrotate_app 'nginx' do
  cookbook  'logrotate'
  path      "#{node['nginx']['log_dir']}/*.log"
  frequency node['nginx']['logrotate']['frequency']
  rotate    node['nginx']['logrotate']['rotate']
  create    "644 #{node['nginx']['user']} #{node['nginx']['group']}"
  sharedscripts true
  prerotate ['if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
      run-parts /etc/logrotate.d/httpd-prerotate; \
    fi']
  postrotate <<-EOF
    [ -s #{node['nginx']['pid']} ] && kill -USR1 `cat #{node['nginx']['pid']}`
  EOF
  options ['missingok', 'compress', 'notifempty']
end