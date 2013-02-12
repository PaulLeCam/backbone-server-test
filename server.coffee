express = require "express"
app = express()

app.engine "jade", require("jade").__express

app.configure ->
  @set "views", "#{ __dirname }/views"
  @set "view engine", "jade"
  @use express.logger "dev"
  @use express.favicon()
  @use express.static "#{ __dirname }/client/www"
  @use require("./components/backbone-middleware") "#{ __dirname }/shared"
  @use express.errorHandler()

app.get "/", (req, res) ->
  res.render "default"

app.listen 3000
