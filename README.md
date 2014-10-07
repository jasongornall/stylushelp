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
  stylus-help alphabetizeStyle <path to stylus dir or file>
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
      z-index 41
    a
      z-index 21
    .panda
      .test
        z-index 11
    [test2.styl]
    div
      z-index 1
    .apple
      z-index 31
  ```
  
### inspectZValues
  Returns a json structure showing the ordering of z indexes
  
  sample call 
  ```
  stylus-help inspectZValues testing/
  ```
  
  Return sample.. This shows the z-index in order and the files they are used in
  ```json
  {
   "1": [
      "testing/test2.styl"
   ],
   "11": [
      "testing/test.styl"
   ],
   "21": [
      "testing/test.styl"
   ],
   "31": [
      "testing/test2.styl"
   ],
   "41": [
      "testing/test.styl"
   ]
}
  ```
### checkAlphabetized
  Returns a json structure with a true or false and a line number showing where the non alphabetized attribute starts
  
  sample call 
  ```
  stylus-help checkAlphabetized testing/test.styl
  ```

 Sample File
 ```
 .left
    div
      z-index 41
      display block
      position relative
      left 50px
    div
      right 100px
      position absolute
  a
    z-index 21
    margin-left 2px
  .panda
    .test
      z-index 11

 ```
 
 
 Return sample for a non alphabetized file
  ```json
  {
   "alphabetized": false,
   "infractions": [
      {
         "line_number": 3,
         "file_name": "testing/test.styl"
      },
      {
         "line_number": 8,
         "file_name": "testing/test.styl"
      },
      {
         "line_number": 11,
         "file_name": "testing/test.styl"
      }
   ]
  }
  ```
  
### alphabetizeStyle
  Returns a json structure with a true or false and a line number showing where the non alphabetized attribute starts
  
  sample call 
  ```
  stylus-help alphabetizeStyle testing/test.styl
  ```

 Sample File
 ```
 .left
    div
      z-index 41
      display block
      position relative
      left 50px
    div
      right 100px
      position absolute
  a
    z-index 21
    margin-left 2px
  .panda
    .test
      z-index 11

 ```
 
 
 Modifications after execution
  ```
  .left
    div
      display block
      left 50px
      position relative
      z-index 41
    div
      position absolute
      right 100px
  a
    margin-left 2px
    z-index 21
  .panda
    .test
      z-index 11

  ```
  
  

  
  
