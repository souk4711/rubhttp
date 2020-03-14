# frozen_string_literal: true

module DummyServerHelper
  def dummy_server_port
    '9298'
  end

  def dummy_server_process
    @dummy_server_process ||= ChildProcess.build('rackup', 'config.ru', '-p', dummy_server_port)
  end

  def dummy_server_start!
    Dir.chdir(File.join(__dir__, 'dummy')) do
      dummy_server_process.start
    end
  end

  def dummy_server_stop!
    dummy_server_process.stop
  end
end

RSpec.configure do |config|
  config.include DummyServerHelper
end
