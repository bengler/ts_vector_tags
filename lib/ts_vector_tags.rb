module TsVectorTags

  module Standardizer
    class << self
      def tagify(tags)
        tags = tags.split(/\s*,\s*/) if tags.is_a?(String)
        tags.map!{ |tag| self.normalize(tag) }
      end

      def normalize(tag)
        tag.downcase.gsub(/[^[:alnum:]]/, "")
      end
    end
  end

  def self.included(base)
    base.class_eval do
      scope :with_tags, lambda { |tags|
        where("tags_vector @@ to_tsquery('simple', ?) ", TsVectorTags::Standardizer.tagify(tags).join(' & '))
      }
    end
  end

  def tags=(value)
    return self.tags_vector = "" if value.nil?
    self.tags_vector = TsVectorTags::Standardizer.tagify(value).map{ |tag| "'#{tag}'" }.join(' ')
  end

  def tags
    return [] unless self.tags_vector
    self.tags_vector.scan(/'(.+?)'/).flatten
  end

end
