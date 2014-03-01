FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game
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
    @player = @game.add.sprite(0, 0, 'player')
    @cursor = @game.input.keyboard.createCursorKeys()



  update: ->
