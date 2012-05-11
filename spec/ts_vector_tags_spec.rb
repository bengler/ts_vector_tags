require 'ts_vector_tags'

describe TsVectorTags::Standardizer do
  it "normalizes" do
    TsVectorTags::Standardizer.normalize('abc-!@ #$    %^&*()123').should eq('abc123')
  end

  it "splits and normalizes a string" do
    TsVectorTags::Standardizer.tagify('abc-!@ #$  ,  %^&*()123').should eq(['abc', '123'])
  end

  it "normalizes tags in an arrayarray" do
    TsVectorTags::Standardizer.tagify(['abc-!@ #$  ', '  %^&*()123']).should eq(['abc', '123'])
  end
end

class Thing
  def self.scope(name, options = {}); end

  attr_accessor :tags_vector
  include TsVectorTags

end

describe TsVectorTags do
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
