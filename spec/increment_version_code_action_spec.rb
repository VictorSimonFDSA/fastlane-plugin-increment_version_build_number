describe Fastlane::Actions::IncrementVersionBuildNumberAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The increment_version_build_number plugin is working!")

      Fastlane::Actions::IncrementVersionBuildNumberAction.run(nil)
    end
  end
end
