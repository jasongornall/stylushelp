# Stylus-help

This is a package designed to assist with common problems and allow for stylus to be parsed into a json format for validation purposes. It makes it easy to identify attributes and style headers aswell as fix some common issues when dealing with stylization

Install
  npm install -g stylus-help
  
Functions for command line
  ```
  stylus-help normalizeZvalues <path to stylus dir or file>, [value to normalize on defaults to 10]
  stylus-help inspectZValues <path to stylus dir or file>
  stylus-help convertStyleToJson <path to stylus dir or file> (note need to > to json write to console)
  stylus-help checkAlphabetized <path to stylus dir or file>
  stylus-help alphabetizeStyle <path to stylus dir or file>
  ```
Functions as a npm package (same returns)<coffeescript>
```coffeescript
  stylus_help = require 'stylus-help'
  
  stylus_help.processData 'normalizeZvalues', [filename1,filename2], (data) ->
  stylus_help.processData 'inspectZValues', [filename1,filename2], (data) ->
  stylus_help.processData 'convertStyleToJson', [filename1,filename2], (data) ->
  stylus_help.processData 'checkAlphabetized', [filename1,filename2], (data) ->
  stylus_help.processData 'alphabetizeStyle', [filename1,filename2], (data) ->
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
  
### convertStyleToJson
  Returns a json structure with a true or false and a line number showing where the non alphabetized attribute starts
  
  sample call 
  ```
  stylus-help alphabetizeStyle testing/test.styl
  ```

 Sample File
 ```
underline()
  &:not(.signup):not(.background)
    box-sizing border-box
    border-bottom 4px solid rgba($color, 0)
    cursor pointer
    padding 0px 5px
    &:hover
      background rgba($frame_background_color, .4)
      border-bottom 4px solid $color

.exports.region
  border-top 1px solid $background_color
  bottom 0
  box-shadow 0px 0px 20px rgba(0, 0, 0, .4)
  color $footer_text_color
  height unit($footer_height, 'px')
  font-family $title_font
  left 0
  position fixed
  right 0
  text-align center
  transition all .2s ease-in
  z-index 16
  .newsletter.custom_text > a
    i, span
      color $footer_text_color
      div, a , iframe
        margin-left 10px


 ```
 Json Conversion Note the space_check is exactly how many spaces to write if you want to modify and line is where the attributes start. line-1 is the style header
  ```json
{
   "testing/test.styl": {
      "&:not(.signup):not(.background)": {
         "space_check": 4,
         "attributes": [
            "box-sizing border-box",
            "border-bottom 4px solid rgba($color, 0)",
            "cursor pointer",
            "padding 0px 5px"
         ],
         "line": 3
      },
      "&:not(.signup):not(.background) &:hover": {
         "space_check": 6,
         "attributes": [
            "background rgba($frame_background_color, .4)",
            "border-bottom 4px solid $color"
         ],
         "line": 8
      },
      ".exports.region": {
         "space_check": 2,
         "attributes": [
            "border-top 1px solid $background_color",
            "bottom 0",
            "box-shadow 0px 0px 20px rgba(0, 0, 0, .4)",
            "color $footer_text_color",
            "height unit($footer_height, 'px')",
            "font-family $title_font",
            "left 0",
            "position fixed",
            "right 0",
            "text-align center",
            "transition all .2s ease-in",
            "z-index 16"
         ],
         "line": 12
      },
      ".exports.region .newsletter.custom_text > a i, .exports.region .newsletter.custom_text > a span": {
         "space_check": 6,
         "attributes": [
            "color $footer_text_color"
         ],
         "line": 26
      },
      ".exports.region .newsletter.custom_text > a i div, .exports.region .newsletter.custom_text > a i a, .exports.region .newsletter.custom_text > a i iframe, .exports.region .newsletter.custom_text > a span div, .exports.region .newsletter.custom_text > a span a, .exports.region .newsletter.custom_text > a span iframe": {
         "space_check": 8,
         "attributes": [
            "margin-left 10px"
         ],
         "line": 28
      }
   }
}

  ```
  

  
  
