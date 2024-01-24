require 'tempfile'
require 'fileutils'

module Fastlane
  module Actions
    class IncrementVersionBuildNumberAction < Action
      def self.run(params)

        version_build_number = "0"
        new_version_build_number ||= params[:version_build]

        constant_name ||= params[:ext_constant_name]

        gradle_file_path ||= params[:gradle_file_path]
        if gradle_file_path != nil
            UI.message("The increment_version_build_number plugin will use gradle file at (#{gradle_file_path})!")
            new_version_build_number = incrementVersion(gradle_file_path, new_version_build_number, constant_name)
        else
            app_folder_name ||= params[:app_folder_name]
            UI.message("The get_version_build_number plugin is looking inside your project folder (#{app_folder_name})!")

            #temp_file = Tempfile.new('fastlaneIncrementVersionBuildNumber')
            #foundVersionBuildNumber = "false"
            Dir.glob("**/#{app_folder_name}/build.gradle") do |path|
                UI.message(" -> Found a build.gradle file at path: (#{path})!")
                new_version_build_number = incrementVersion(path, new_version_build_number, constant_name)
            end

        end

        if new_version_build_number == -1
            UI.user_error!("Impossible to find the version code with the specified properties 😭")
        else
            # Store the version name in the shared hash
            Actions.lane_context["version_build_number"]=new_version_build_number
            UI.success("☝️ Version code has been changed to #{new_version_build_number}")
        end

        return new_version_build_number
      end

      def self.incrementVersion(path, new_version_build_number, constant_name)
          if !File.file?(path)
              UI.message(" -> No file exist at path: (#{path})!")
              return -1
          end
          begin
              foundVersionBuildNumber = "false"
              temp_file = Tempfile.new('fastlaneIncrementVersionBuildNumber')
              File.open(path, 'r') do |file|
                  file.each_line do |line|
                      if line.include? constant_name and foundVersionBuildNumber=="false"
                          UI.message(" -> line: (#{line})!")
                        versionComponents = line.strip.split(' ')
                        version_build_number = versionComponents[versionComponents.length-1].tr("\"","")
                        if new_version_build_number <= 0
                            new_version_build_number = version_build_number.to_i + 1
                        end
                        if !!(version_build_number =~ /\A[-+]?[0-9]+\z/)
                            line.replace line.sub(version_build_number, new_version_build_number.to_s)
                            foundVersionBuildNumber = "true"
                        end
                        temp_file.puts line
                      else
                      temp_file.puts line
                   end
              end
              file.close
            end
            temp_file.rewind
            temp_file.close
            FileUtils.mv(temp_file.path, path)
            temp_file.unlink
          end
          if foundVersionBuildNumber == "true"
              return new_version_build_number
          end
          return -1
      end

      def self.description
        "Increment the version build number of your android project with version code like versionCode versionMajor * 10000 + versionMinor * 1000 + versionPatch * 100 + versionBuild."
      end

      def self.authors
        ["VictorSimonFDSA"]
      end

      def self.available_options
          [
              FastlaneCore::ConfigItem.new(key: :app_folder_name,
                                      env_name: "IncrementVersionBuildNumber_APP_FOLDER_NAME",
                                   description: "The name of the application source folder in the Android project (default: app)",
                                      optional: true,
                                          type: String,
                                 default_value:"app"),
             FastlaneCore::ConfigItem.new(key: :gradle_file_path,
                                     env_name: "IncrementVersionBuildNumber_GRADLE_FILE_PATH",
                                  description: "The relative path to the gradle file containing the version code parameter (default:app/build.gradle)",
                                     optional: true,
                                         type: String,
                                default_value: nil),
              FastlaneCore::ConfigItem.new(key: :version_build_number,
                                      env_name: "IncrementVersionBuildNumber_version_build_number",
                                   description: "Change to a specific version (optional)",
                                      optional: true,
                                          type: Integer,
                                 default_value: 0),
              FastlaneCore::ConfigItem.new(key: :ext_constant_name,
                                      env_name: "IncrementVersionBuildNumber_EXT_CONSTANT_NAME",
                                   description: "If the version code is set in an ext constant, specify the constant name (optional)",
                                      optional: true,
                                          type: String,
                                 default_value: "versionCode")
          ]
      end

      def self.output
        [
          ['version_build_number', 'The new version build number of the project']
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
