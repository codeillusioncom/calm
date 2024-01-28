require "ecr"
require "file_utils"

module Calm
  class Generate
    def initialize
      puts ""
      if ARGV.size > 0
        if ARGV[0] == "controller" && (ARGV.size == 2 || ARGV.size == 3)
          return generate_controller
        elsif ARGV[0] == "policy" && (ARGV.size == 2 || ARGV.size == 3)
          return generate_policy
        elsif ARGV[0] == "view" && ARGV.size == 2 || ARGV.size == 3
          return generate_view
        elsif ARGV[0] == "model" && ARGV.size == 2
          return generate_model
        elsif ARGV[0] == "migration" && ARGV.size == 2
          return generate_migration
        end
      end
      puts "Usage: crystal run lib/calm/src/generate.cr -- controller [name] [action]"
      puts "       crystal run lib/calm/src/generate.cr -- policy [name] [action]"
      puts "       crystal run lib/calm/src/generate.cr -- view [name]"
      puts "       crystal run lib/calm/src/generate.cr -- model [name]"
      puts "       crystal run lib/calm/src/generate.cr -- migration [name]"
      puts ""

      return -1
    end

    private def generate_controller
      controller_name = ARGV[1]
      controller_name_capitalized = ARGV[1].camelcase
      action_content = ""

      if ARGV.size == 3
        action_name = ARGV[2]

        action_content = ECR.render("./lib/calm/src/templates/controller/index_partial.ecr") if action_name == "index"
        action_content = ECR.render("./lib/calm/src/templates/controller/show_partial.ecr") if action_name == "show"
        action_content = ECR.render("./lib/calm/src/templates/controller/add_partial.ecr") if action_name == "add"
        action_content = ECR.render("./lib/calm/src/templates/controller/create_partial.ecr") if action_name == "create"
        action_content = ECR.render("./lib/calm/src/templates/controller/edit_partial.ecr") if action_name == "edit"
        action_content = ECR.render("./lib/calm/src/templates/controller/update_partial.ecr") if action_name == "update"
        action_content = ECR.render("./lib/calm/src/templates/controller/destroy_partial.ecr") if action_name == "destroy"
      end

      if File.exists?("./src/controllers/#{controller_name}_controller.cr")
        return if ARGV.size == 2

        original_file_content = File.read_lines("./src/controllers/#{controller_name}_controller.cr")
        new_file_content = [] of String
        original_file_content.each_with_index do |line, index|
          new_file_content << line
          if index == 0
            new_file_content << action_content
            new_file_content << ""
          end
        end
        File.write("./src/controllers/#{controller_name}_controller.cr", new_file_content.join("\n"))
      else
        File.write("./src/controllers/#{controller_name}_controller.cr", ECR.render("./lib/calm/src/templates/controller_template.ecr"))
      end

      return 0
    end

    private def generate_policy
      policy_name = ARGV[1]
      policy_name_capitalized = ARGV[1].camelcase
      action_content = ""

      if ARGV.size == 3
        action_name = ARGV[2]

        action_content = ECR.render("./lib/calm/src/templates/policy/partial.ecr")
      end

      if File.exists?("./src/policies/#{policy_name}_controller_policy.cr")
        return if ARGV.size == 2

        original_file_content = File.read_lines("./src/policies/#{policy_name}_controller_policy.cr")
        new_file_content = [] of String
        original_file_content.each_with_index do |line, index|
          new_file_content << line
          if index == 0
            new_file_content << action_content
            new_file_content << ""
          end
        end
        File.write("./src/policies/#{policy_name}_controller_policy.cr", new_file_content.join("\n"))
      else
        File.write("./src/policies/#{policy_name}_controller_policy.cr", ECR.render("./lib/calm/src/templates/policy/policy_template.ecr"))
      end

      return 0
    end

    private def generate_view
      view_name = ARGV[1]
      view_name_capitalized = ARGV[1].camelcase
      action_content = ""

      if ARGV.size == 3
        action_name = ARGV[2]

        action_content = ECR.render("./lib/calm/src/templates/view_actions/index_partial.ecr") if action_name == "index"
        action_content = ECR.render("./lib/calm/src/templates/view_actions/show_partial.ecr") if action_name == "show"
        action_content = ECR.render("./lib/calm/src/templates/view_actions/add_partial.ecr") if action_name == "add"
        action_content = ECR.render("./lib/calm/src/templates/view_actions/create_partial.ecr") if action_name == "create"
        action_content = ECR.render("./lib/calm/src/templates/view_actions/edit_partial.ecr") if action_name == "edit"
        action_content = ECR.render("./lib/calm/src/templates/view_actions/update_partial.ecr") if action_name == "update"
        action_content = ECR.render("./lib/calm/src/templates/view_actions/destroy_partial.ecr") if action_name == "destroy"
      end

      if File.exists?("./src/controllers/#{view_name}_controller.cr")
        return if ARGV.size == 2

        original_file_content = File.read_lines("./src/controllers/#{view_name}_controller.cr")
        new_file_content = [] of String
        original_file_content.each_with_index do |line, index|
          new_file_content << line
          if index == 0
            new_file_content << action_content
            new_file_content << ""
          end
        end
        File.write("./src/controllers/#{view_name}_controller.cr", new_file_content.join("\n"))
      else
        File.write("./src/controllers/#{view_name}_controller.cr", ECR.render("./lib/calm/src/templates/controller_template.ecr"))
      end

      return 0
    end

    private def generate_model
      model_name = ARGV[1]

      model_name_capitalized = model_name.capitalize

      File.write("./src/models/#{model_name}.cr", ECR.render("./lib/calm/src/templates/model_template.ecr"))

      return 0
    end

    private def generate_migration
      date_str = Time.utc.to_s("%Y%m%d%H%M%S%L")
      migration_name = ARGV[1]
      migration_name_capitalized = migration_name.camelcase

      File.write("./src/migrations/#{date_str}_#{migration_name}.cr", ECR.render("./lib/calm/src/templates/migration_template.ecr"))

      return 0
    end
  end
end

Calm::Generate.new
