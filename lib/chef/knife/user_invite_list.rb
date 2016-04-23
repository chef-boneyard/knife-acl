#
# Author:: Steven Danna (<steve@chef.io>)
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
  class UserInviteList < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner 'knife user invite list'

    def run
      api_endpoint = "association_requests/"
      invited_users = rest.get_rest(api_endpoint).map { |i| i['username'] }
      ui.output(invited_users)
    end
  end
end
