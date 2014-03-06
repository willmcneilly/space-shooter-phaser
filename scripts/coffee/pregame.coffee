module.exports = class PreGame
  constructor: (game) ->
    game = @game

  preload: ->
    @game.load.image('bg', '/assets/background.png')

  create: ->
    @background = @game.add.sprite(0, 0, 'bg')

    @gameOverText = @game.add.text(0, 0, "Space Shooter", { font: 'bold 40px Arial', fill: 'white'})
    @gameOverText.x = Math.floor(@game.world.width/2 - @gameOverText.width/2)
    @gameOverText.y = Math.floor(@game.world.height/2 - @gameOverText.height/2)

    @pressUpText = @game.add.text(0, 0, "Press UP to play", { font: 'normal 20px Arial', fill: 'white'})
    @pressUpText.x = Math.floor(@game.world.width/2 - @pressUpText.width/2)
    @pressUpText.y = Math.floor((@game.world.height/2 - @pressUpText.height/2) + 40)

    @cursor = @game.input.keyboard.createCursorKeys()

  update: ->
    if @cursor.up.isDown
      @game.state.start('game', true, true)
