module.exports = class PostGame
  constructor: (game) ->
    game = @game

  create: ->
    @text = @game.add.text(0, 0, "Game Over", { fontSize: '14px', fill: 'white'})
    @text.x = Math.floor(@game.world.width/2 - @text.width/2)
    @text.y = Math.floor(@game.world.height/2 - @text.height/2)
