# TsVectorTags

A simple tagging library that uses the (fairly exotic) `tsvector` type in PostgreSQL on top of ActiveRecord.

## Requirements

* ActiveRecord
* a field `tags_vector` of type `tsvector` on the underlying table

## Usage

Tags can be set using either an array, or a comma separated list.

    class Post < ActiveRecord::Base
      include TsVectorTags

      # ...
    end

    post = Post.new

    post.tags = "bing, bong"
    post.tags
    => ['bing', 'bong']

    post.tags = ['bing', 'bong']
    post.tags
    => ['bing', 'bong']

The including class has scopes:

Common '&'-searches:

    Post.with_tags('Paris, Texas')
    Post.with_tags('Paris', 'Texas')

Complex tsqueries:

    Post.with_tags_query("foo & !(bar | baz)")

tsqueries deemed potentially dangerous raises the `TsVectorTags::InvalidTsQueryError` exception.

Tags are normalized:

    post.tags = ['  wtf#$%^   &*??!']
    post.tags
    => ['wtf']
