#
# Author:: Seth Falcon (<seth@chef.io>)
# Author:: Jeremiah Snapp (<jeremiah@chef.io>)
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
  class GroupList < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife group list"

    deps do
      require 'chef/knife/acl_base'
      include OpscodeAcl::AclBase
    end

    def run
      groups = rest.get_rest("groups").keys.sort
      ui.output(remove_usags(groups))
    end

    def remove_usags(groups)
      groups.select { |gname| !is_usag?(gname) }
    end
  end
end
