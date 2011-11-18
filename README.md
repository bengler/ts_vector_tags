# TsVectorTags

A simple tagging library that uses the (fairly exotic) `ts_vector` type in PostgreSQL.

## Usage

Tags can be set using either an array, or a comma separated list.

Note that the including class *must* have an attribute `tags_vector`.

    class Post
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


The including class will also have a scope:

    Post.with_tags('Paris, Texas')
    Post.with_tags('Paris', 'Texas')

Tags are normalized:

    post.tags = ['  wtf#$%^   &*??!']
    post.tags
    => ['wtf']
