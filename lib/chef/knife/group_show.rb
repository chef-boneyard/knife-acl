#
# Author:: Seth Falcon (<seth@opscode.com>)
# Copyright:: Copyright 2011--2014 Chef Software, Inc.
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
  class GroupShow < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife group show GROUP"
    
    deps do
      require 'pp'
      require 'yaml'
    end

    def run
      @user_map = if ::File.exists?("actor-map.yaml")
                   YAML.load(IO.read("actor-map.yaml"))[:user_map]
                 else
                   {:users => {}, :usags => {}}
                 end
      group_name = name_args[0]
      if !group_name || group_name.empty?
        ui.error "must specify a group name"
        exit 1
      end
      chef_rest = Chef::REST.new(Chef::Config[:chef_server_url])
      group = chef_rest.get_rest("groups/#{group_name}")
      ui.output(annotate_usags(group))
    end

    def annotate_usags(group)
      annotated = group["groups"].map do |name|
        user = @user_map[:usags][name] || ""
        {"group_id" => name,
          "user_usag" => user}
      end
      group["annotated_groups"] = annotated
      group
    end
  end
end

