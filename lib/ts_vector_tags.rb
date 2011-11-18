require "ts_vector_tags/version"

module TsVectorTags
  class MissingAttributeError < Exception; end

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
    unless base.instance_methods.include?(:tags_vector) && base.instance_methods.include?(:tags_vector=)
      msg = "The TsVectorTags mixin assumes that the underlying PostgreSQL table has a field `tags_vector` of type tsvector"
      raise TsVectorTags::MissingAttributeError.new(msg)
    end

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
