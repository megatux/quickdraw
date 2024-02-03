# frozen_string_literal: true

class GreenDots::Worker
	def self.fork
		pipe = GreenDots::Pipe.new

		pid = Process.fork do
			pipe.with_writer do |writer|
				yield(writer)
			end
		end

		new(pid:, pipe:)
	end

	def initialize(pid:, pipe:)
		@pid = pid
		@pipe = pipe
	end

	def wait
		Process.wait(@pid)

		@pipe.with_reader do |reader|
			reader.read
		end
	end
end