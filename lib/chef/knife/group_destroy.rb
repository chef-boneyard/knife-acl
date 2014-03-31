#
# Author:: Christopher Maier (<cm@opscode.com>)
# Copyright:: Copyright 2014 Opscode, Inc.
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
  class GroupDestroy < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife group destroy GROUP"

    deps do
      require 'yaml'
    end

    def run
      group_name = name_args[0]
      if !group_name || group_name.empty?
        ui.error "must specify a group name"
        exit 1
      end
      result = rest.delete_rest("groups/#{group_name}")
      ui.output result
    end
  end
end
