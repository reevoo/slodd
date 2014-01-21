require "spec_helper"

describe Slodd::Http do
  let(:url) { double }
  let(:schema_file) { double(read: "the schema") }
  subject { described_class.new(url: url) }

  describe "#schema" do
    it "downloads the schema from the url given" do
      expect(subject).to receive(:open).with(url).and_return(schema_file)
      expect(subject.schema).to eq "the schema"
    end
  end
end
