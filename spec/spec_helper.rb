$: << File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
require 'rspec'

module ShellShock
  module CommandSpec
    def with_usage text
      it('should display usage') { expect(@command.usage).to eq(text) }
    end

    def with_help text
      it('should display help') { expect(@command.help).to eq(text) }
    end
  end
end