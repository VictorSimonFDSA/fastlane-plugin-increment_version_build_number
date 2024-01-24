module Fastlane
  module Helper
    class IncrementVersionBuildNumberHelper
      # class methods that you define here become available in your action
      # as `Helper::IncrementVersionBuildNumberHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the increment_version_build_number plugin helper!")
      end
    end
  end
end
