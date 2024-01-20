require "file_utils"

module Calm
  class Init
    MAIN_FILE_NEW_CONTENT = [
      "require \"calm/src/calm.cr\"",
      "",
      "require \"./config/*\"",
      "require \"./migrations/*\"",
      "require \"./models/*\"",
      "require \"./handlers/*\"",
      "require \"./policies/*\"",
      "require \"./views/**\"",
      "",
    ] of String

    PROJECT_STRUCTURE = [
      "src/config/locales",
      "src/handlers",
      "src/migrations",
      "src/models",
      "src/policies",
      "src/views",
    ]

    def initialize
      puts "Initializing project..."

      modify_main_file
      create_project_structure
      copy_application_view
      copy_config_file
      copy_routes_file

      puts "...project initialization done."
    end

    private def modify_main_file
      puts " * modifying main file if necessary..."

      project_name = get_project_name
      main_file_path = current_directory.join("/src/#{project_name}.cr")
      old_content = File.read_lines(main_file_path)
      new_content = [] of String

      return if old_content.first == MAIN_FILE_NEW_CONTENT.first

      new_content = MAIN_FILE_NEW_CONTENT
      new_content.concat old_content
      new_content << ""
      new_content << "Calm::Cli::Cli.new(ARGV).run"
      new_content << ""

      File.write(main_file_path, new_content.join("\n"))

      puts "     main file has been modified."
    end

    private def create_project_structure
      puts " * creating project structure if necessary..."

      PROJECT_STRUCTURE.each do |directory|
        FileUtils.mkdir_p(current_directory.join(directory))
      end
      puts "     project structure has been created."
    end

    private def copy_application_view
      original_file_path = Path.new("./lib/calm/src/templates/application_view.cr")
      new_file_path = Path.new("./src/views/application_view.cr")

      FileUtils.cp(original_file_path, new_file_path) unless File.exists?(new_file_path)
    end

    private def copy_config_file
      original_file_path = Path.new("./lib/calm/src/templates/settings.cr")
      new_file_path = Path.new("./src/config/settings.cr")

      FileUtils.cp(original_file_path, new_file_path) unless File.exists?(new_file_path)
    end

    private def copy_routes_file
      original_file_path = Path.new("./lib/calm/src/templates/routes.cr")
      new_file_path = Path.new("./src/config/routes.cr")

      FileUtils.cp(original_file_path, new_file_path) unless File.exists?(new_file_path)
    end

    private def get_project_name
      Path[Dir.current].basename
    end

    private def current_directory
      Path.new(Dir.current)
    end
  end
end

Calm::Init.new
