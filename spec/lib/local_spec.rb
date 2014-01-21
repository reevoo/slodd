require "spec_helper"

describe Slodd::Local do
  let(:path) do
    File.join(File.dirname(__FILE__), "..", "support", "schema.rb")
  end

  subject { described_class.new(path: path) }

  describe "#schema" do
    it "reads the file" do
      expect(subject.schema).to eq "ActiveRecord::Schema.define(:version => 1) do\n  create_table \"tests\", :force => true do |t|\n    t.string   \"name\"\n  end\nend\n"
    end
  end
end
