#
# Author:: Steven Danna (steve@opscode.com)
# Author:: Jeremiah Snapp (jeremiah@chef.io)
# Copyright:: Copyright 2011--2015 Chef Software, Inc.
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
  class AclAdd < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife acl add OBJECT_TYPE OBJECT_NAME PERMS MEMBER_TYPE MEMBER_NAME"

    deps do
      include OpscodeAcl::AclBase
    end

    def run
      object_type, object_name, perms, member_type, member_name = name_args

      if name_args.length != 5
        show_usage
        ui.fatal "You must specify the object type, object name, perms, member type [client|group|user] and member name"
        exit 1
      end

      validate_perm_type!(perms)
      validate_member_type!(member_type)
      validate_member_name!(member_name)
      validate_object_name!(object_name)
      validate_object_type!(object_type)
      validate_member_exists!(member_type, member_name)

      add_to_acl!(object_type, object_name, member_type, member_name, perms)
    end
  end
end
