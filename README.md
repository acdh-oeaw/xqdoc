xqdoc display library for BaseX
===============================

This is the 2006 display library for xqdoc packaged for BaseX.
[http.xqm] shows how to setup the RestXQ endpoints to serve
the docs. You can copy that to BaseX' `webapp` directory and
start serving documentation.

The documentation is _not_ extracted on the fly from the sources
but needs to be put into an `xqdoc` DB/collection first.

As an example you can run:

* `/xqdoc/create-cache.xqy` to create the DB
* `/xqdoc/cache-xqdocs.xqy` to add the xqdoc-disply xqdoc
  This takes a `target` query parameter specifying the root directory
  of a directory tree to extract xqdoc XML from.
* alternatively add xqdoc XML using the `xqdoc-display:cache-xqdocs($target)`
  function.

To remove the DB there is `/xqdoc/drop-cache.xqy`

Build the xar package
---------------------

* Zip this directory with some zip utility.
* Use github download and rename to `.xar`
* If you have java JDK available `jar cf xqdoc-display-1.0.xar *`
  does the job too.
