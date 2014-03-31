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
  module AclBase

    PERM_TYPES = %w(create read update delete grant)
    ACTOR_TYPES = %w(client group)
    OBJECT_TYPES = %w(clients groups containers data nodes roles cookbooks sandboxes environments)
    OBJECT_NAME_SPEC = /^[\-[:alnum:]_\.]+$/

    def validate_object_type!(type)
      if ! OBJECT_TYPES.include?(type)
        ui.fatal "Unknown object type \"#{type}\".  The following types are permitted: #{OBJECT_TYPES.join(', ')}"
        exit 1
      end
    end

    def validate_object_name!(name)
      if ! OBJECT_NAME_SPEC.match(name)
        ui.fatal "Invalid name: #{name}"
        exit 1
      end
    end

    def validate_actor_type!(type)
      if ! ACTOR_TYPES.include?(type)
        ui.fatal "Unknown actor type \"#{type}\". The following types are permitted: #{ACTOR_TYPES.join(', ')}"
        exit 1
      end
    end

    def validate_actor_name!(name)
      # Same rules apply to object's and actors
      validate_object_name!(name)
    end

    def validate_perm_type!(perm)
      if ! PERM_TYPES.include?(perm)
        ui.fatal "Invalid permission \"#{perm}\". The following permissions are permitted: #{PERM_TYPES.join(',')}"
        exit 1
      end

    end

    def validate_all_params!
      # Helper method to valid parameters for commands that modify permisisons
      # This assumes including class has the necessary accessors
      # We the validation to ensure we can give the user more helpful error messages.
      validate_perm_type!(perm)
      validate_actor_type!(actor_type)
      validate_actor_name!(actor_name)
      validate_object_name!(object_name)
      validate_object_type!(object_type)
    end

    def get_acl(object_type, object_name)
      rest.get_rest("#{object_type}/#{object_name}/_acl")
    end

    def get_ace(object_type, object_name, perm)
      get_acl(object_type, object_name)[perm]
    end

    def update_ace!(object_type, object_name, ace_type, ace)
      rest.put_rest("#{object_type}/#{object_name}/_acl/#{ace_type}", ace_type => ace)
    end

  end
end
