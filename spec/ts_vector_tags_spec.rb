# encoding: utf-8
require 'ts_vector_tags'

describe TsVectorTags::Standardizer do
  it "normalizes" do
    TsVectorTags::Standardizer.normalize('abc-!@ #$ _  %^&*()123æøå∞').should eq('abc_123æøå')
  end

  it "splits and normalizes a string" do
    TsVectorTags::Standardizer.tagify('abc-!@ #$  ,  %^&*()123').should eq(['abc', '123'])
  end

  it "normalizes tags in an arrayarray" do
    TsVectorTags::Standardizer.tagify(['abc-!@ #$  ', '  %^&*()123']).should eq(['abc', '123'])
  end

  it "removes empty tags" do
    TsVectorTags::Standardizer.tagify(['abc', '  %^&*()']).should eq(['abc'])
  end
end

class Thing
  def self.scope(name, options = {}); end

  attr_accessor :tags_vector
  include TsVectorTags

end

describe TsVectorTags do
  describe "tsqueries" do
    it "rejects potentially dangerous tsqueries" do
      TsVectorTags.acceptable_tsquery?("'").should be_false
      TsVectorTags.acceptable_tsquery?('"').should be_false
    end
    it "accepts plain tsqueries" do
      TsVectorTags.acceptable_tsquery?("foo & !(bar | fudd)")
      TsVectorTags.acceptable_tsquery?("foo:*A")
    end
  end
  describe "accessors" do
    let(:thing) { Thing.new }

    describe "deleting tags" do
      before :each do
        thing.tags_vector = "'bing' 'bong'"
      end

      it "uses nil" do
        thing.tags = nil
        thing.tags.should eq([])
      end

      it "removes tags with an empty array" do
        thing.tags = []
        thing.tags.should eq([])
      end

      it "removes tags with an empty string" do
        thing.tags = ""
        thing.tags.should eq([])
      end
    end

    it "assigns comma-separated strings" do
      thing.tags = "bing, bong"
      thing.tags_vector.should eq("'bing' 'bong'")
    end

    it "assigns arrays" do
      thing.tags = ["bing", "bong"]
      thing.tags_vector.should eq("'bing' 'bong'")
    end

    it "reads tag vectors" do
      thing.tags_vector = "'bing' 'bong'"
      thing.tags.should eq(['bing', 'bong'])
    end
  end

end
