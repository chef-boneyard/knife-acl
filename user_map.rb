module OpscodeAcl
  class UserMap < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife user map"

    # writes a yaml file to current working directly named
    # 'user-map.yaml'
    # group add/remove operations will read this file
    # 
    deps do
      require 'pp'
      require 'yaml'
    end

    def run
      chef_rest = Chef::REST.new(Chef::Config[:chef_server_url])
      usags = chef_rest.get_rest("groups").keys.select do |gname|
        gname.length == 32 && gname =~ /^[0-9a-f]+$/
      end
      user_map = {:users => {}, :usags => {}}
      user_map = usags.inject(user_map) do |map, usag|
        a_group = chef_rest.get_rest("groups/#{usag}")
        actors = a_group["actors"]
        if actors.length == 1
          user_map[:users][actors.first] = usag
          user_map[:usags][usag] = actors.first
        end
        user_map
      end
      open("user-map.yaml", "w") do |f|
        f.write(user_map.to_yaml)
      end
      puts "wrote user map to 'user-map.yaml'"
    end
  end
end

