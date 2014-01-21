require "spec_helper"

describe Slodd::Runner do
  subject { described_class }

  describe "#run" do
    before do
      Slodd::Config.path = File.join(File.dirname(__FILE__), "..", "support", "schema.rb")
      Slodd::Config.databases = "slodd_test"
    end

    after do
      Slodd::Config.reset
    end

    it "creates the database ready for testing" do
      subject.run!

      expect(Test.count).to eq 0
      test = Test.create(name: "James")

      expect(Test.count).to eq 1
      expect(Test.last.name).to eq "James"
      expect(`mysql -uroot -e "show databases;"`).to match /slodd_test/

      subject.run!
      expect(Test.count).to eq 0
    end

    context "with multiple databases" do
      before do
        Slodd::Config.databases = "slodd_test slodd_test_2"
      end

      it "creates both databases" do
        subject.run!

        databases = `mysql -uroot -e "show databases;"`
        expect(databases).to match /slodd_test/
        expect(databases).to match /slodd_test_2/
      end
    end

    context "when something is failing" do
      before do
        allow(ActiveRecord::Base).to receive(:establish_connection).and_raise(Mysql2::Error, "mysql error")
      end

      it "ouputs a usefull message to stderr" do
        message = capture_stderr do
          subject.run!
        end
        expect(message).to match /mysql error/
      end
    end
  end
end

class Test < ActiveRecord::Base; end
