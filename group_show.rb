module OpscodeAcl
  class GroupShow < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife group show GROUP"
    
    deps do
      require 'pp'
      require 'yaml'
    end

    def run
      @user_map = if ::File.exists?("user-map.yaml")
                   YAML.load(IO.read("user-map.yaml"))
                 else
                   {:users => {}, :usags => {}}
                 end
      group_name = name_args[0]
      if !group_name || group_name.empty?
        ui.error "must specify a group name"
        exit 1
      end
      chef_rest = Chef::REST.new(Chef::Config[:chef_server_url])
      group = chef_rest.get_rest("groups/#{group_name}")
      pp annotate_usags(group)
    end

    def annotate_usags(group)
      annotated = group["groups"].map do |name|
        user = @user_map[:usags][name] || ""
        {"group_id" => name,
          "user_usag" => user}
      end
      group["annotated_groups"] = annotated
      group
    end
  end
end

