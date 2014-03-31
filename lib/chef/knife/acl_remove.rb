#
# Author:: Steven Danna (steve@opscode.com)
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
  class AclRemove < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife acl remove OBJECT_TYPE OBJECT_NAME PERM ACTOR_TYPE ACTOR_NAME"

    attr_reader :object_type, :object_name, :perm, :actor_type, :actor_name

    deps do
      include OpscodeAcl::AclBase
    end

    def run
      @object_type, @object_name, @perm, @actor_type, @actor_name = name_args

      if name_args.length < 5
        show_usage
        ui.fatal "You must specify the object_type, object_name,  perm, actor type (client or group), and actor name"
        exit 1
      end

      validate_all_params!
      ace = get_ace(object_type, object_name, perm)

      case actor_type
      when "client"
        remove_actor_from_ace!(actor_name, ace)
      when "group"
        remove_group_from_ace!(actor_name, ace)
      when "users"
        # Not Implemented yet, we shouldn't get here.
      end

      update_ace!(object_type, object_name, perm, ace)
    end

    def remove_group_from_ace!(name, ace)
      ace['groups'].delete(name)
    end

    def remove_actor_from_ace!(name, ace)
      ace['actors'].delete(name)
    end

  end
end
