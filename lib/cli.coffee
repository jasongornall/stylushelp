# dependencies
CSON = require 'cson'
async = require 'async'
coffeelint = require 'coffeelint'
fs = require 'fs'
mkdirp = require 'mkdirp'
mongofb = require 'mongofb'
ncp = require('ncp').ncp
open = require 'open'
optimist = require 'optimist'
path = require 'path'
readline = require 'readline'
log = console.log

# usage
USAGE = """
Usage: styler <command> [command-specific-options]

where <command> [command-specific-options] is one of:
  normalizeZValues <path to stylus files               backup a site
"""
# get arguments and options
argv = optimist.argv._
command = argv[0]
args = argv[1...argv.length]
opts = optimist.argv

#HELPER FUNCTIONS
exit = (msg='bye') ->
  log msg if msg
  process.exit()
log = (msg) ->
  console.log msg

getPreSpaces = (str) ->
  space_check = 0
  for c in str
    if c ==' '
      space_check++
    else
      return space_check
  return space_check
###
checkAlphabetical = (data) ->
  config.files.sort (a, b) ->
    if a.attribute > b.path then 1 else -1.sort (a, b) -> if a.path > b.path then 1 else -1
###


# COMMAND LINE STUFF
processData = (command,args,next) =>
  switch command

    when 'alphabetizeStyle'
      processData 'convertStyleToJson',args, (data) =>
        for file_name, file of data
          for tag, attribute_info of file
            if not(checkAlphabetical(attribute_info.attributes))
              relphabetize(attribute_info.attributes,"#{args[0]}#{file}")

    when 'convertStyleToJson'
      fs.readdir args[0], (err, files) ->
        total_return = {}
        processed = 0
        for file in files
          addFile = (file) ->
            obj = {}
            if /.styl/.test(file)
              fs.readFile "#{args[0]}#{file}",'utf8', (err, data) ->
                data = data.split('\n');
                tagFound = false
                attributeSet = []
                tag = ''
                space_check = 0
                for line_num, line of data
                  if line.match(/(\n|^)\s*(div|span|i|\.|&|>|#|@media).*/)
                    tagFound = true

                    if attributeSet.length
                      obj["#{tag.trim()}"]= {space_check,attributes:attributeSet}
                      obj["#{tag.trim()}"].line = parseInt(line_num, 10)+1 - attributeSet.length

                      attributeSet = []
                      space_check = 0

                    if getPreSpaces(line) > getPreSpaces(tag)
                      tag += " #{line.trim()}"
                    else
                      tag = line


                  else if tagFound
                    pre_spaces = getPreSpaces(line)
                    if space_check == 0
                      space_check = pre_spaces
                      if space_check == 0
                        continue

                    if space_check == pre_spaces
                      attributeSet.push("#{line.trim()}")
                    else
                      obj["#{tag.trim()}"]= {space_check,attributes:attributeSet}
                      obj["#{tag.trim()}"].line = parseInt(line_num, 10)+1 - attributeSet.length

                      tag = ''
                      attributeSet = []
                      space_check = 0


                total_return[file] = obj
                processed++
                if processed == files.length
                  next(total_return,{is_json:true})


          addFile(file)







    # Normalize z index values
    when 'normalizeZvalues'
      sizeOf = (obj) ->
        size = 0
        for key, val of obj
          size++
        return size;

      generateJson = (next) ->
        processed = 1
        filesTotal = {}
        fs.readdir args[0], (err, files) ->
          for file in files
            addFile = (file) ->
              if /.styl/.test(file)
                fs.readFile "#{args[0]}#{file}",'utf8', (err, data) ->
                  arr = data.match(/(z-index:? +)([0-9]+)/g)
                  if arr?.length
                    for val in arr
                      val = val.match(/(z-index:? +)([0-9]+)/)
                      z_index = parseInt(val[2],10)

                      filesTotal[z_index] ?= []
                      filesTotal[z_index].push(file)
                  processed++
                  if files.length is processed
                    next(filesTotal)
            addFile(file)

      generateJson (filesTotal) ->
        count = 0
        breathing_room = args[1]
        breathing_room ?= 10
        for z_index, files of filesTotal
          z_index = parseInt(z_index,10)

          if z_index != count
            for file in files
              buf = fs.readFileSync("#{args[0]}#{file}", 'utf8')
              reg = new RegExp("z-index:? +#{z_index}\n",'g')
              buf = buf.replace reg, "z-index #{count}\n"
              fs.writeFileSync("#{args[0]}#{file}", buf, 'utf8')



          count += breathing_room
        generateJson (filesTotal) ->
          next(filesTotal)

    else
      log "invalid command #{command}"
      exit USAGE


# Output data

processData command, args, (value, options)=>

  if options?.is_json
    value = JSON.stringify(value,null,3)

  console.log value
