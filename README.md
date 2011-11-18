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

The including class has a scope:

    Post.with_tags('Paris, Texas')
    Post.with_tags('Paris', 'Texas')

Tags are normalized:

    post.tags = ['  wtf#$%^   &*??!']
    post.tags
    => ['wtf']
