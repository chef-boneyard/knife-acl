#
# Author:: Steven Danna (steve@chef.io)
# Copyright:: Copyright 2011-2016 Chef Software, Inc.
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
  class AclShow < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife acl show OBJECT_TYPE OBJECT_NAME"

    deps do
      require 'chef/knife/acl_base'
      include OpscodeAcl::AclBase
    end

    def run
      object_type, object_name = name_args

      if name_args.length != 2
        show_usage
        ui.fatal "You must specify an object type and object name"
        exit 1
      end

      validate_object_type!(object_type)
      validate_object_name!(object_name)
      acl = get_acl(object_type, object_name)
      PERM_TYPES.each do |perm|
        # Filter out the actors field if we have
        # users and clients.  Note that if one is present,
        # both will be - but we're checking both for completeness.
        if acl[perm].has_key?('users') && acl[perm].has_key?('clients')
          acl[perm].delete 'actors'
        end
      end
      ui.output acl
    end
  end
end
