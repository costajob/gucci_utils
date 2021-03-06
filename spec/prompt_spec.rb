require "spec_helper"

describe GitCommands::Prompt do
  let(:klass) { Mocks::Prompt }
  let(:instance) { klass::new }

  it "must print a warning" do
    instance.warning("should print the warning")
    instance.out.string.must_equal "\e[33m\nshould print the warning\e[0m\n"
  end

  it "must print success message" do
    instance.success("i win!")
    instance.out.string.must_equal "\e[32m\ni win!\e[0m\n"
  end

  it "must print error message" do
    instance.error("i loose...")
    instance.out.string.must_equal "\e[31mi loose...\e[0m\n"
  end

  it "must confirm question" do
    def instance.input; "y"; end
    assert instance.confirm("Are you sure") { true }
  end

  it "must raise an abort error" do
    def instance.input; "n"; end
    -> { instance.confirm("Are you sure") }.must_raise klass::AbortError
  end
end
