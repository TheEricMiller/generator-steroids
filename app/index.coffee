"use strict"
util = require("util")
path = require("path")
yeoman = require("yeoman-generator")
yosay = require("yosay")
SteroidsGenerator = yeoman.generators.Base.extend(
  initializing: ->
    @pkg = require("../package.json")
    return

  prompting: ->
    done = @async()
    
    # Have Yeoman greet the user.
    @log yosay("Welcome to the exquisite Devroids generator!")
    prompts = [
      type: "confirm"
      name: "someOption"
      message: "Would you like to enable this option?"
      default: true
    ]
    @prompt prompts, ((props) ->
      @someOption = props.someOption
      done()
      return
    ).bind(this)
    return

  writing:
    app: ->
      @dest.mkdir "app"
      @dest.mkdir "app/templates"
      @src.copy "_package.json", "package.json"
      @src.copy "_bower.json", "bower.json"

    projectfiles: ->
      @src.copy "gitignore", ".gitignore"

  end: ->
    @installDependencies()
    return
)
module.exports = SteroidsGenerator