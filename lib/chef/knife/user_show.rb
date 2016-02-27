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
  class UserShow < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner 'knife user show [USERNAME]'

    # ui.format_for_display has logic to handle displaying
    # any attributes set in the config[:attribute] Array.
    attrs_to_show = []
    option :attribute,
    :short => "-a [ATTR]",
    :long => "--attribute [ATTR]",
    :proc => lambda {|val| attrs_to_show << val},
    :description => "Show attribute ATTR. Use multiple times to show multiple attributes."

    def run
      if name_args.length < 1
        show_usage
        ui.fatal "You must specify a username."
        exit 1
      end

      username = name_args[0]
      api_endpoint = "users/#{username}"
      user = rest.get_rest(api_endpoint)
      ui.output(ui.format_for_display(user))
    end
  end
end
