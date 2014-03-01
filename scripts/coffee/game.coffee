FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game
    @playerVelocity = 400
    @cursor = null
    @lives = 3
    @score = 0



  preload: ->
    @game.load.image('bg', '/assets/images/background.png')
    @game.load.image('player', '/assets/images/player-ship.png')
    @game.load.image('enemy1', '/assets/images/enemy-green.png')
    @game.load.image('enemy2', '/assets/images/enemy-red.png')
    @game.load.image('enemy3', '/assets/images/enemy-yellow.png')
    @game.load.image('powerUp', '/assets/images/star-gold.png')
    @game.load.image('laser', '/assets/images/laser-green.png')


  create: ->
    @background = @game.add.sprite(0, 0, 'bg')
    @createPlayer()
    @cursor = @game.input.keyboard.createCursorKeys()


  update: ->
    @player.body.velocity.x = 0

    if @cursor.left.isDown
      @player.body.velocity.x = -@playerVelocity
    else if @cursor.right.isDown
      @player.body.velocity.x = @playerVelocity


  createPlayer: ->
    @player = @game.add.sprite(0, 0, 'player')
    @player.y = (@game.height - @player.height) - 20
    @player.x = @game.width - @player.width
