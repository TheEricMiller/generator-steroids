util = require("util")
path = require("path")
yosay = require("yosay")

fs = require "fs"
chalk = require "chalk"

template = require "lodash-node/modern/utilities/template"
strings = require "underscore.string"

SteroidsGenerator = require '../SteroidsGenerator'

module.exports = class SteroidsDataModuleGenerator extends SteroidsGenerator
  constructor: ([resourceName, scriptExt, fieldNames...]) ->
    super

    @resourceNameNotLowercased = @context.resourceNameNotLowercased = resourceName
    @resourceName = @context.resourceName = resourceName.toLowerCase()
    @scriptExt = @context.scriptExt = scriptExt
    @fieldNames = @context.fields = fieldNames

    if !@resourceName?.length
      throw new Error "Expected a resource name as the first argument to the generator"

  prompting: ->
    done = @async()

    # Have Yeoman greet the user.
    @log yosay("You're about to create a module for your #{@resourceName} resource!")
    @log "#{chalk.green "Resource name:"} #{chalk.gray @resourceName}"
    @log "#{chalk.green "Fields:"} #{chalk.gray @fieldNames.join ', '}"

    prompts = [
      type: "input"
      name: "moduleName"
      message: "What is the name for your new module?"
      default: "#{@resourceName.toLowerCase}"
    ]
    @prompt prompts, (props) =>
      @moduleName = @context.moduleName = props.moduleName
      done()

  template: (contents) ->
    @context._ = strings
    template(contents, @context)

  writing: ->
    @dest.mkdir "app/#{@moduleName}"

    @src.copy "_index.#{@scriptExt}", "app/#{@moduleName}/index.#{@scriptExt}", process: @template
    @src.copy "scripts/_IndexController.#{@scriptExt}", "app/#{@moduleName}/scripts/IndexController.#{@scriptExt}", process: @template
    @src.copy "scripts/_NewController.#{@scriptExt}", "app/#{@moduleName}/scripts/NewController.#{@scriptExt}", process: @template
    @src.copy "scripts/_ShowController.#{@scriptExt}", "app/#{@moduleName}/scripts/ShowController.#{@scriptExt}", process: @template
    @src.copy "scripts/_EditController.#{@scriptExt}", "app/#{@moduleName}/scripts/EditController.#{@scriptExt}", process: @template

    @src.copy "scripts/_Model.#{@scriptExt}", "app/#{@moduleName}/scripts/#{strings.capitalize @resourceName}Model.#{@scriptExt}", process: @template

    @src.copy "views/layout.html", "app/#{@moduleName}/views/layout.html"

    @src.copy "views/_index.html", "app/#{@moduleName}/views/index.html", process: @template
    @src.copy "views/_show.html", "app/#{@moduleName}/views/show.html", process: @template
    @src.copy "views/_edit.html", "app/#{@moduleName}/views/edit.html", process: @template
    @src.copy "views/_new.html", "app/#{@moduleName}/views/new.html", process: @template
    @src.copy "views/__form.html", "app/#{@moduleName}/views/_form.html", process: @template
    @src.copy "views/__spinner.html", "app/#{@moduleName}/views/_spinner.html", process: @template
