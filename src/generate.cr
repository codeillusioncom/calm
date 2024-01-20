require "ecr"
require "file_utils"

module Calm
  class Generate
    def initialize
      puts ""
      if ARGV.size > 0
        if ARGV[0] == "controller" && ARGV.size == 2
          return generate_controller
        end
      end
      puts "Usage: crystal run lib/calm/src/generate.cr -- controller [name]"
      # puts "       crystal run lib/calm/src/generate.cr -- controller [name]"
      puts ""

      return -1
    end

    private def generate_controller
      controller_name = ARGV[1]
      # view
      FileUtils.mkdir_p("./src/views/#{controller_name}")
      controller_path = Path.new("./src/views/#{controller_name}/#{controller_name}_controller_view.cr")
      controller_name_capitalized = controller_name.capitalize
      
      File.write("./src/views/#{controller_name}/#{controller_name}_controller_view.cr", ECR.render("./lib/calm/src/templates/controller_view_template.ecr"))
      
      # controller
      File.write("./src/handlers/#{controller_name}_controller.cr", ECR.render("./lib/calm/src/templates/controller_template.ecr"))

      # policy
      File.write("./src/policies/#{controller_name}_controller_policy.cr", ECR.render("./lib/calm/src/templates/controller_policy.ecr"))

      # route
      old_routes_content = File.read_lines("./src/config/routes.cr")
      route_line = "    get \"/#{controller_name}\", #{controller_name.capitalize}Controller.show, #{controller_name.capitalize}ControllerView.show"
      
      unless old_routes_content.includes?(route_line)
        new_routes_content = [] of String

        old_routes_content.each_with_index do |line, index|
          new_routes_content << line unless index > old_routes_content.size - 3
        end
        new_routes_content << route_line
        new_routes_content << "  end"
        new_routes_content << "end"

        File.write("./src/config/routes.cr", new_routes_content.join("\n"))
      end
    
      return 0
    end
  end
end

Calm::Generate.new
