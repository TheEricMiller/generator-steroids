path = require "path"
chalk = require "chalk"
yeoman = require "yeoman-generator"
fs = require "fs"

module.exports = class ControllersTutorialGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    super arguments...

    @on "end", ->
        @log.writeln(
          """
          \nNow change the first tab in #{chalk.bold("config/application.coffee")} to point to

            #{chalk.green("\"http://localhost/views/steroidsTutorial/controllers.html\"")}

          and then reload the application.
          """
        )


  createTutorial: ->
    if not fs.existsSync("app/views/layouts/steroidsTutorial.html")
      @log.writeln(
        """
        #{chalk.red("Error:")} could not find file #{chalk.bold("app/views/layouts/steroidsTutorial.html")}.

        Please make sure you've generated the #{chalk.bold("steroids")} tutorial first with

          #{chalk.bold("$ steroids generate tutorial steroids")}

        """
      )
      process.exit(1)
    else
      @log.writeln(
        """
        Generating tutorial #{chalk.bold("controllers")}...

        """
      )

      @mkdir "app/controllers"

      @copy "application.js", "app/controllers/application.js"
      @copy "controller.js", "app/controllers/steroidsTutorial.js"
      @copy "controllers.html", "app/views/steroidsTutorial/controllers.html"
      @copy "controllers-completed.html", "app/views/steroidsTutorial/controllers-completed.html"
