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
  class ActorMap < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife actor map"

    # writes a yaml file to current working directly named
    # 'actor-map.yaml'
    # group add/remove operations will read this file
    # 
    deps do
      require 'pp'
      require 'yaml'
    end

    def run
      chef_rest = Chef::REST.new(Chef::Config[:chef_server_url])
      usags = chef_rest.get_rest("groups").keys.select do |gname|
        gname.length == 32 && gname =~ /^[0-9a-f]+$/
      end
      user_map = {:users => {}, :usags => {}}
      user_map = usags.inject(user_map) do |map, usag|
        a_group = chef_rest.get_rest("groups/#{usag}")
        actors = a_group["actors"]
        if actors.length == 1
          user_map[:users][actors.first] = usag
          user_map[:usags][usag] = actors.first
        end
        user_map
      end
      clients = chef_rest.get_rest("clients").keys.inject({}) { |h, c| h[c] = c; h }
      open("actor-map.yaml", "w") do |f|
        f.write({ :user_map => user_map, :clients => clients }.to_yaml)
      end
      ui.msg "Found %d users and %d clients" % [user_map[:users].size, clients.size]
      ui.msg "wrote map to 'actor-map.yaml'"
    end
  end
end

