**0.8.1** (2014-06-02)

 - critical fix for Assets.wrap. only emit one error

**0.8.0** (2014-05-11)

 - move back from uglify-js2 to uglifyjs
 - update uglify js from 2.1.x to 2.4.x

**0.7.2** (2014-03-16)

 - better error message for failed compile

**v0.7.1** (2014-03-16)

 - add in try catches for any code that could possibly crash

**v0.7.0** (2014-03-11)

 - allow config.source input on more modules
 - add a .coffee module
 - add a preprocess function when possible to modify input code
 - add a postprocess function when possible to modify output code

**v0.6.0** (2014-02-03)

 - remove pkgcloud dependency (it is 5MB)
 - cdn push still available, but user must install pkgcloud on their own
 - bump stylus to 0.42.x
 - bump chokidar to 0.8.x for better file watching on OS X

**v0.5.2** (2014-02-01)

 - allow for custom code to be passed into stylus module
 - watch out for unexpected errors in tests
 - update to should 3.1.x

**v0.5.1** (2014-02-01)

 - add a CSS module

**v0.5.0** (2013-11-18)

 - update dependencies to pull in various bug fixes
 - dont update coffee-script yet, 1.6.x breaks a few tests
 - merge assets in order they were provided

**v0.4.2** (2013-10-23)

 - fix stylus boolean variables when false

**v0.4.1** (2013-10-06)

 - fix opacity for rgba colors for stylus variables

**v0.4.0** (2013-10-04)

 - remove old stylus variable setting

**v0.3.5** (2013-10-04)

 - parse stylus global variables as the correct node type
 - allow prefix on stylus global variables (ex: $, or var_)
 - not removing old variable setting yet, will bump minor version for that

**v0.3.4** (2013-08-06)

 - add global variables for stylus

**v0.3.3** (2013-06-03 4:59 AM EDT)

 - typo

**v0.3.1** (2013-06-03 4:47 AM EDT)

 - fix merge callback
 - update asset.tag when deploying to cdn

**v0.3.0** (2013-05-31 5:53 PM EDT)

 - add Travis CI
 - separate compiled and complete events
 - add push to cdn
 - push to cdn after compile, but before complete
 - add callback to merge() in case asset needs to go to cdn

**v0.2.3** (2013-04-25 3:03 PM EDT)

 - fix import for chokidar in snockets
 - add snockets test for watch

**v0.2.2** (2013-04-25 2:57 PM EDT)

 - add cleancss option for stylus to concat imported css
 - add file watching for @src file in all modules
 - add file watching for @src and all dependencies in snockets module
 - update stylus to 0.32.1
 - add `define('url', stylus.url())` to stylus module

**v0.2.1** (2013-02-11)

 - ignoreErrors param to wrap.Assets
 - fix merge for javascript files that are missing semicolons
 - add custom Cache-Control setting to middleware
 - add default config values for Assets

**v0.2.0** (2013-01-18 1:00pm EST)

 - Breaking changes to shortcuts
 - Add error handling
 - Update examples
 - Use process.nextTick for shortcut callbacks
 - Use should instead of assert in tests
 - Add examples for express.js

**v0.1.4** (2013-01-17 9:00pm EST)

 - fix stylus nib import
 - add CHANGELOG.md

**v0.1.3** (2013-01-17 7:30pm EST)

 - Fix text/css tags

**v0.1.2** (2013-01-17 6:00pm EST)

 - Add cluster examples
 - Clean up README
 - Add Assets.merge
 - Use src if dst is not defined
 - Add callback shortcut to Assets contructor

**v0.1.1** (2013-01-17 5:00pm EST)

 - Examples
 - Fix express/zappa middleware
 - Sass module
 - Fix Less compress

**v0.1.0** (2013-01-17)

 - Initial Release
 - Stylus module
 - Snockets module
 - Less module
 - Test framework
