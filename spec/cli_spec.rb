require "spec_helper"

describe GitCommands::CLI do
  let(:repo) { "~/greatest_hits" }
  let(:branches) { "teddybear,love_me_tender" }

  it "must raise an error for unknown command" do
    -> { GitCommands::CLI.new(command_name: "noent") }.must_raise GitCommands::CLI::UnknownCommandError
  end

  it "must call the spcified command with default options" do
    GitCommands::CLI::VALID_COMMANDS.each do |name|
      cli = GitCommands::CLI.new(command_name: name, args: %W[--repo=#{repo} --branches=#{branches}], computer_klass: Mocks::Computer)
      cli.call.must_equal "#{name} on #{File.expand_path(repo)}@origin/master"
    end
  end

  it "must call the spcified command with custom options" do
    origin = "upstream"
    default = "production"
    GitCommands::CLI::VALID_COMMANDS.each do |name|
      cli = GitCommands::CLI.new(command_name: name, args: %W[--repo=#{repo} --origin=#{origin} --default=#{default} --branches=#{branches}], computer_klass: Mocks::Computer)
      cli.call.must_equal "#{name} on #{File.expand_path(repo)}@#{origin}/#{default}"
    end
  end

  it "must print the help" do
    out = StringIO.new
    cli = GitCommands::CLI.new(command_name: "rebase", args: %w[--help], out: out, computer_klass: Mocks::Computer)
    begin
      cli.call
    rescue SystemExit
      out.string.must_equal "Usage: rebase --repo=~/greatest_hits --origin=upstream --default=production --branches=feature/love_me_tender,fetaure/teddybear\n    -r, --repo=REPO                  The path to the existing GIT repository\n    -o, --origin=ORIGIN              Specify the remote alias (origin)\n    -d, --default=DEFAULT            Specify the default branch (master)\n    -b, --branches=BRANCHES          Specify branches as: 1. a comma-separated list of names 2. the path to a file containing names on each line 3. via pattern matching\n    -h, --help                       Prints this help\n"
    end
  end
end
