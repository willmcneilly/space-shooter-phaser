FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game
    @playerVelocity = 400
    @cursor = null
    @lives = 3
    @score = 0
    @timeBetweenLaserBeams = 200
    @laserDelta = 0
    @averageEnemySpawnTime = 1000
    @enemyDelta = 0

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
    @createLasers()
    @createEnemies()
    @cursor = @game.input.keyboard.createCursorKeys()

  update: ->
    @player.body.velocity.x = 0

    if @cursor.left.isDown
      @player.body.velocity.x = -@playerVelocity
    else if @cursor.right.isDown
      @player.body.velocity.x = @playerVelocity

    if @cursor.up.isDown
      @fire()

    @spawnEnemy()

  createPlayer: ->
    @player = @game.add.sprite(0, 0, 'player')
    @player.y = (@game.height - @player.height) - 20
    @player.x = @game.width - @player.width

  createLasers: ->
    @lasers =  @game.add.group()
    @lasers.createMultiple(25, 'laser')
    @lasers.setAll('outOfBoundsKill', true)

  createEnemies: ->
    @enemies =  @game.add.group()
    @enemies.createMultiple(25, 'enemy1')
    @enemies.setAll('outOfBoundsKill', true)
    @enemies.setAll('scale.x', 0.5)
    @enemies.setAll('scale.y', 0.5)

  fire: ->
    if @game.time.now > @laserDelta
      @spawnOneLaserBeam()
      @laserDelta = @game.time.now + @timeBetweenLaserBeams

  spawnOneLaserBeam: ->
    laser = @lasers.getFirstExists(false)
    laser.reset(@player.x, @player.y)
    laser.body.velocity.y =- 500

  spawnEnemy: ->
    if @game.time.now > @enemyDelta
      @spawnOneEnemy()
      @enemyDelta = @game.time.now + @enemySpawnTime()

  enemySpawnTime: ->
    spawnTimeRange = @averageEnemySpawnTime * 0.2
    upper = @averageEnemySpawnTime + spawnTimeRange
    lower = @averageEnemySpawnTime - spawnTimeRange
    return @game.rnd.integerInRange(lower, upper)

  spawnOneEnemy: ->
    enemy = @enemies.getFirstExists(false)
    enemy.reset(@game.rnd.realInRange(enemy.width, @game.world.width - enemy.width), -enemy.width)
    enemy.body.velocity.y =+ 300
