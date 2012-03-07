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
  module AclBase

    OBJECT_TYPES = %w(clients groups containers data nodes roles cookbooks sandboxes environments)
    OBJECT_NAME_SPEC = /^[\-[:alnum:]_\.]+$/

    def parse_object_name(object_name)
      if m = object_name.match('(.*)\[(.*)\]')
        type = m[1]
        name = m[2]

        if ! OBJECT_TYPES.include?(type)
          ui.fatal "Unknown object type: #{type}"
          exit 1
        end

        if ! OBJECT_NAME_SPEC.match(name)
          ui.fatal "Invalid object name: #{name}"
          exit 1
        end

        {'type' => type, 'name' => name}
      else
        ui.fatal "Could not parse OBJECT.  It should have the form OBJECT_TYPE[OBJECT_NAME]"
        exit 1
      end
    end


    def get_acl(object)
      rest.get_rest("#{object['type']}/#{object['name']}/_acl")
    end

    def get_ace(object, perm)
      get_acl(object)[perm]
    end

    def update_ace!(object, ace_type, ace)
      rest.put_rest("#{object['type']}/#{object['name']}/_acl/#{ace_type}", ace_type => ace)
    end

  end
end
