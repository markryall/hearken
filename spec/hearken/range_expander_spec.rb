# frozen_string_literal: true

require_relative "../spec_helper"
require "hearken/range_expander"

describe Hearken::RangeExpander do
  before do
    @expander = Hearken::RangeExpander.new
  end

  it "expands single values" do
    expect(@expander.expand("123")).to eq([1371])
  end

  it "expands multiple values separated by any non digit" do
    expect(@expander.expand("123 \t 456  , 789 ")).to eq([1371, 5370, 9369])
  end

  it "expands a fully specified range" do
    expect(@expander.expand(" 456-45i ")).to eq((5370..5382).to_a)
  end

  it "expands an abbreviated range" do
    expect(@expander.expand(" 456-i ")).to eq((5370..5382).to_a)
  end

  it "expands ids for a range" do
    expect(@expander.expand_to_ids(" s-z ")).to eq(%w[s t u v w x y z])
  end
end
