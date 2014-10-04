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


console.log command, 'command'
# COMMAND LINE STUFF
switch command

  # backup your site data
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
        c = console
        c.log filesTotal

  else
    log "invalid command #{command}"
    exit USAGE

