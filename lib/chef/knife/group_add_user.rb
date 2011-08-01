#
# Author:: Seth Falcon (<seth@opscode.com>)
# Copyright:: Copyright 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
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

module OpscodeAcl
  class GroupAddUser < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife group add user GROUP USER"
    
    deps do
      require 'pp'
      require 'yaml'
    end

    def run
      user_map = YAML.load(IO.read("user-map.yaml"))
      group_name = name_args[0]
      user_name = name_args[1]
      if !group_name || !user_name
        ui.error "must specify GROUP and USER"
        exit 1
      end
      @chef_rest = Chef::REST.new(Chef::Config[:chef_server_url])
      user_usag = user_map[:users][user_name]
      if !user_usag
        ui.error "user #{user_name} not in user-map.yaml"
        exit 1
      end
      group = @chef_rest.get_rest("groups/#{group_name}")
      if !group["groups"].include?(user_usag)
        group["groups"] << user_usag
      else
        ui.msg "#{user_name} is already in the #{group_name} group."
        exit 0
      end
      save_group(group)
    end

    def save_group(group)
      new_group = make_group_for_put(group)
      @chef_rest.put_rest("groups/#{new_group["groupname"]}", new_group)
    end

    def make_group_for_put(existing_group)
      new_group = {
        "groupname" => existing_group["groupname"],
        "orgname" => existing_group["orgname"],
        "actors" => {
          "users" => existing_group["actors"],
          "groups" => existing_group["groups"]
        }
      }
    end
  end
end

