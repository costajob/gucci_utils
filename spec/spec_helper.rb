$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "git_commands"
require "minitest/autorun"
require "rr"
require "ostruct"
require "tempfile"
require "mocks"

$VERBOSE = nil