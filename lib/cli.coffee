# dependencies
CSON = require 'cson'
async = require 'async'
coffeelint = require 'coffeelint'
fs = require 'fs'
mkdirp = require 'mkdirp'
async = require 'async'
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
  normalizeZvalues <path to stylus files               backup a site
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

writeToLine = (file, line_str, line_num) =>
  file_str = ''
  data = fs.readFileSync file,'utf8'
  data = data.split('\n');
  for line_number, line of data
    end_line = ''
    if line_number == "#{line_num-1}"
      line = line_str
    if "#{data.length-1}" !=line_number
      end_line = '\n'
    file_str+="#{line}#{end_line}"
  console.log file_str
  fs.writeFileSync(file, file_str, 'utf8')

alphabetize = (data) =>
  old_data = data.slice(0)
  data.sort (a, b) -> if a > b then 1 else -1
  arrayEqual = (a, b) ->
    a.length is b.length and a.every (elem, i) -> elem is b[i]
  return not arrayEqual(old_data,data)





# COMMAND LINE STUFF
processData = (command,args,next) =>
  switch command
    when 'test'

      # Fs.WriteSync (fd, buffer, offset, length, position)


      writeToLine("#{args[0]}","        wwwww 0",14)


    when 'alphabetizeStyle'
      console.log 'wwhyyy'
      processData 'convertStyleToJson',args, (data) =>
        console.log 'processed'
        for file_name, file of data
          for tag, attribute_info of file
            if (alphabetize(attribute_info.attributes))
              space_num = attribute_info.space_check
              spaces = Array(parseInt(space_num+1)).join ' '
              for line_num,attr of attribute_info.attributes
                line = parseInt attribute_info.line + parseInt line_num
                console.log "#{args[0]}#{file_name}","#{spaces}#{attr}",line,attribute_info.line,line_num
                writeToLine("#{args[0]}#{file_name}","#{spaces}#{attr}",line)


    when 'convertStyleToJson'
      fs.readdir args[0], (err, files) ->
        console.log 'read_dir'
        total_return = {}
        processed = 0

        async.each files, ((file, data_next) =>
          obj = {}
          console.log 'test styl'
          if not (/.styl/.test(file))
            data_next()
            return

          fs.readFile "#{args[0]}#{file}",'utf8', (err, data) ->
            console.log
            data = data.split('\n');
            tagFound = false
            attributeSet = []
            tag = ''
            space_check = 0
            for line_num, line of data
              if line.match(/((\n|^)(\s)*(\.|&|>|#|@media).+)|(\n|^)(\s)*(table|td|th|tr|div|span|a|h1|h2|h3|h4|h5|h6|strong|em|quote|form|fieldset|label|input|textarea|button|body|img|ul|li|html|object|iframe|p|blockquote|abbr|address|cite|del|dfn|ins|kbd|q|samp|sup|var|b|i|dl|dt|dd|ol|legend|caption|tbody|tfoot|thead|article|aside|canvas|details|figcaption|figure|footer|header|hgroup|menu|nav|section|summary|time|mark|audio|video)(,| |\.|$).*/)
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
            data_next()
        ), (err) ->
          next(total_return,{is_json:true})





    when 'inspectZValues'
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
        next(filesTotal,{is_json:true})

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
          next(filesTotal,{is_json:true})

    else
      log "invalid command #{command}"
      exit USAGE


# Output data

processData command, args, (value, options)=>

  if options?.is_json
    value = JSON.stringify(value,null,3)

  console.log value
