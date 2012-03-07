#
# Author:: Steven Danna (steve@opscode.com)
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
  class AclRemove < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife acl remove OBJECT PERM [group|client] NAME"

    deps do
      include OpscodeAcl::AclBase
    end

    def run
      object_name, perm, actor_type, name = name_args

      if name_args.length < 4
        show_usage
        ui.fatal "You must specify the object, perm, actor type (client or group), and actor name"
        exit 1
      end

      if ! actor_type =~ /^group|client$/
        ui.error "Only removing a group or client from object ACEs has been implemented"
        exit 1
      end

      object = parse_object_name(object_name)

      ace = get_ace(object, perm)

      case actor_type
      when "client"
        remove_actor_from_ace!(name, ace)
      when "group"
        remove_group_from_ace!(name, ace)
      when "users"
        # Not Implemented yet, we shouldn't get here.
      end

      update_ace!(object, perm, ace)
    end

    def remove_group_from_ace!(name, ace)
      ace['groups'].delete(name)
    end

    def remove_actor_from_ace!(name, ace)
      ace['actors'].delete(name)
    end

  end
end
