module.exports = class FPS
  constructor: (game) ->
    @game = game
    @fpsText = null
    @create()

  create: ->
    @fpsText = @game.add.text(0, 0, "0", { fontSize: '16px', fill: 'white', stroke: "black", strokeThickness: 5 })

  update: ->
    @fpsText.content = @game.time.fps.toString()
