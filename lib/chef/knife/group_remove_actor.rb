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
  class GroupRemoveActor < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife group remove actor GROUP ACTOR"
    attr_reader :actor_name, :group_name, :user_map, :clients
    deps do
      require 'yaml'
    end

    def run
      if !File.exists?("actor-map.yaml")
        ui.error "unable to find 'actor-map.yaml'. Run 'knife actor map' and try again."
        exit 1
      end
      actor_map = YAML.load(IO.read("actor-map.yaml"))
      @user_map = actor_map[:user_map]
      @clients = actor_map[:clients]
      @group_name = name_args[0]
      @actor_name = name_args[1]

      if !group_name || !actor_name
        ui.error "must specify GROUP and ACTOR"
        exit 1
      end
      find_actor_in_map
      @chef_rest = Chef::REST.new(Chef::Config[:chef_server_url])
      group = @chef_rest.get_rest("groups/#{group_name}")
      case @actor_type
      when :user
        group["groups"].delete(@actor_id)
      when :client
        group["clients"].delete(@actor_id)
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
          "clients" => existing_group["clients"],
          "groups" => existing_group["groups"],
          "users" => existing_group["users"]
        }
      }
    end

    def find_actor_in_map
      @actor_type, @actor_id = if user_map[:users][actor_name]
                                 [:user, user_map[:users][actor_name]]
                               else
                                 [:client, clients[actor_name]]
                               end
      if @actor_id.nil?
        ui.error("no user or client named '#{actor_name}' in actor-map.yaml")
        exit 1
      end
      true
    end
  end
end
