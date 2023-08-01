require "spec_helper"

RSpec.describe "Whenever Schedule" do # rubocop:disable RSpec/DescribeClass
  before do
    load "Rakefile" # Makes sure rake tasks are loaded so you can assert in rake jobs
  end

  it "has a daily job for active store cleaning" do
    schedule = Whenever::Test::Schedule.new(file: "config/schedule.rb")

    expect(schedule.jobs[:rake].count).to eq(2)

    schedule.jobs[:rake].each do |job|
      # Makes sure the rake task is defined:
      assert Rake::Task.task_defined?(job[:task])
    end
  end
end

