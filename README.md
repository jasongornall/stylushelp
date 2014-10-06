# Stylus-help

This is a package designed to assist with common problems and allow for stylus to be parsed into a json format for validation purposes. It makes it easy to identify attributes and style headers aswell as fix some common issues when dealing with stylization

Install
  npm install -g stylus-help
  
Functions
  ```
  stylus-help normalizeZvalues <path to stylus dir or file>, [value to normalize on defaults to 10]
  stylus-help inspectZValues <path to stylus dir or file>
  stylus-help convertStyleToJson <path to stylus dir or file> (note need to > to json write to console)
  stylus-help checkAlphabetized <path to stylus dir or file>
  ```
### normalizeZvalues
  Takes a directory (not recursive) and goes through and normalizes z-index across the files... It automatically uses a buffer of 10 between z-index values. You can manually specify a buffer if you want to only have a space of 3,4 between values
  
  sample call 
  ```
  stylus-help normalizeZvalues testing/
  ```
Before Execution
  ```
  [test.styl]
  div
    z-index 99
  a
    z-index 12
  .panda
    .test
      z-index 2
  ```
  ```
  [test2.styl]
  div
    z-index 1
  .apple
    z-index 25
  ```
After Execution
  ```styl
    [test.styl]
    div
      z-index 40
    a
      z-index 20
    .panda
      .test
        z-index 10
    [test2.styl]
    div
      z-index 0
    .apple
      z-index 30
  ```

  
  
