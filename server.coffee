express = require "express"
app = express()

app.engine "jade", require("jade").__express

app.configure ->
  @set "views", "#{ __dirname }/views"
  @set "view engine", "jade"
  @use express.logger "dev"
  @use express.compress()
  @use express.favicon()
  @use express.static "#{ __dirname }/client/www"
  @use require("./components/backbone-middleware") "#{ __dirname }/shared"
  @use express.errorHandler()

app.get "/", (req, res) ->
  thread = [
    {title: "Hello World!"}
    {title: "Another post"}
  ]
  res.render "default", {thread}

app.listen 3000
