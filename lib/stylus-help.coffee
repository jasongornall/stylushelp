# dependencies

fs = require 'fs'
async = require 'async'
optimist = require 'optimist'
log = console.log

# usage
USAGE = """
Usage: styler <command> [command-specific-options]

where <command> [command-specific-options] is one of:
  normalizeZvalues <path to stylus dir or file>, [value to normalize on]
  inspectZValues <path to stylus dir or file>
  convertStyleToJson <path to stylus dir or file> (note need to > to json write to console)
  checkAlphabetized <path to stylus dir or file>
"""

# get arguments and options (used for command line executions)
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
  return str.match(/^(\s)*/)[0].length

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
  fs.writeFileSync(file, file_str, 'utf8')

alphabetize = (data) =>
  old_data = data.slice(0)
  data.sort()
  arrayEqual = (a, b) ->
    a.length is b.length and a.every (elem, i) -> elem is b[i]
  return not arrayEqual(old_data,data)

getFiles = (args, next) =>
  type = ''
  return next([]) unless args.length
  fs.stat args[0], (err, stats) =>
    if err
      console.log err
      return # exit here since stats will be undefined

    if stats.isDirectory()
      type = 'directory'
      read_files = fs.readdirSync args[0]
      for key, val of read_files
        read_files[key] = args[0]+read_files[key]

    else if stats.isFile()
      type = 'file'
      read_files = [args[0]]

    next(read_files)



# COMMAND LINE STUFF
processData = (command,args,next) =>
  getFiles args, (read_files) =>
    switch command
      when 'checkAlphabetized'
        return_data = null
        processData 'convertStyleToJson',args, (data) =>
          for file_name, file of data
            for tag, attribute_info of file
              if (alphabetize(attribute_info.attributes))
                return_data ?= {
                  alphabetized: false
                  infractions: []
                }
                return_data.infractions.push {
                  line_number: attribute_info.line
                  file_name
                }
          return_data ?= {
            alphabetized: true
          }
          next(return_data,{is_json:true})
      when 'alphabetizeStyle'
        processData 'convertStyleToJson',args, (data) =>
          for file_name, file of data
            for tag, attribute_info of file
              if (alphabetize(attribute_info.attributes))
                space_num = attribute_info.space_check
                spaces = Array(parseInt(space_num+1)).join ' '
                for line_num,attr of attribute_info.attributes
                  line = parseInt attribute_info.line + parseInt line_num
                  writeToLine(file_name,"#{spaces}#{attr}",line)

      when 'convertStyleToJson'
        # a,b  d,c
        #a.d, a.c , b.d, b.c
        join = (data_1, data_2) =>
          arr_1 = data_1.split(',')
          arr_2 = data_2.split(',')
          str = []
          for arg1 in arr_1
            for arg2 in arr_2
              str.push("#{arg1.trim()} #{arg2.trim()}")
          return str.join(', ')

        total_return = {}
        processed = 0

        async.each read_files, ((file, data_next) =>
          obj = {}
          if not (/.styl/.test(file))
            data_next()
            return

          fs.readFile file,'utf8', (err, data) ->
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
                  tag = join(tag, line.trim())
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
        generateJson = (doneJson) ->
          processed = 1
          filesTotal = {}
          async.each read_files, ((file, data_next) =>
            addFile = (file) ->
              if /.styl/.test(file)
                fs.readFile "#{file}",'utf8', (err, data) ->
                  arr = data.match(/(z-index:? +)([0-9]+)/g)
                  if arr?.length
                    for val in arr
                      val = val.match(/(z-index:? +)([0-9]+)/)
                      z_index = parseInt(val[2],10)

                      filesTotal[z_index] ?= []
                      filesTotal[z_index].push(file)
                  data_next()
            addFile(file)
          ),  (err) ->
            doneJson(filesTotal)
        generateJson (filesTotal) ->
          next(filesTotal,{is_json:true})

      # Normalize z index values
      when 'normalizeZvalues'
        sizeOf = (obj) ->
          size = 0
          for key, val of obj
            size++
          return size;

        processData 'inspectZValues', args, (filesTotal) =>
          count = null
          breathing_room = args[1]
          breathing_room ?= 10
          for z_index, files of filesTotal
            z_index = parseInt(z_index,10)
            count ?= Math.min(z_index,1)
            if z_index != count
              for file in files
                buf = fs.readFileSync("#{file}", 'utf8')
                reg = new RegExp("z-index:? +#{z_index}\n",'g')
                buf = buf.replace reg, "z-index #{count}\n"
                fs.writeFileSync("#{file}", buf, 'utf8')

            count += breathing_room
          processData 'inspectZValues', args, (filesTotal) =>
            next(filesTotal,{is_json:true})

      else
        log "invalid command #{command}"
        exit USAGE

# Support for command line stuff
if (/stylus-help/.test module?.parent?.filename)
  processData command, args, (value, options)=>
    if options?.is_json
      value = JSON.stringify(value,null,3)
    console.log value

# support for require
exports.processData = processData
