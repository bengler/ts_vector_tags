# encoding: utf-8
module TsVectorTags

  # Regexp to reject injection attacks with ts_queries
  TSQUERY_VALIDATOR = /^[[:alnum:]\*\:\(\)\&\!\|[:space:]]+$/

  class InvalidTsQueryError < StandardError; end

  module Standardizer
    class << self
      def tagify(tags)
        tags = tags.split(/\s*,\s*/) if tags.is_a?(String)
        tags.map{ |tag| self.normalize(tag) }.reject(&:empty?)
      end

      def normalize(tag)
        tag.downcase.gsub(/[^[:alnum:]_]/, "")
      end
    end
  end

  def self.acceptable_tsquery?(query)
    # TODO: Check for balanced parantheses
    query =~ TSQUERY_VALIDATOR
  end

  def self.included(base)
    base.class_eval do
      # Accepts a comma separated list of tags and applies the 'and'-operator to them
      scope :with_tags, lambda { |tags|
        where("tags_vector @@ to_tsquery('simple', ?) ", TsVectorTags::Standardizer.tagify(tags).join(' & '))
      }

      # Accepts a proper ts_query an allows complex logical expressions like "foo & !(bar | bling)"
      scope :with_tags_query, lambda { |query|
        raise InvalidTsQueryError, "Invalid tag query '#{query}'" unless TsVectorTags.acceptable_tsquery?(query)
        # "!foo" will not match empty tsvectors, so we have to cheat using coalesce :-(
        where("coalesce(tags_vector, '-invalid-tag-') @@ to_tsquery('simple', '#{query}')")
      }

      # Make sure empty vectors are always saved as null values
      before_save lambda {
        self.tags_vector = nil if self.tags_vector && self.tags_vector.strip.size == 0
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
