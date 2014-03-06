FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game

  preload: ->
    @game.load.image('bg', '/assets/background.png')
    @game.load.image('player', '/assets/player-ship.png')
    @game.load.image('enemy1', '/assets/enemy-green.png')
    @game.load.image('enemy2', '/assets/enemy-red.png')
    @game.load.image('enemy3', '/assets/enemy-yellow.png')
    @game.load.image('powerUp', '/assets/star-gold.png')
    @game.load.image('laser', '/assets/laser-green.png')

  create: ->
    @playerVelocity = 400
    @laserVelocity = 500
    @enemyVelocity = 100
    @baseEnemyVelocity = 100
    @cursor = null
    @lives = 3
    @score = 0
    @timeBetweenLaserBeams = 200
    @laserDelta = 0
    @averageEnemySpawnTime = 600
    @enemyDelta = 0
    @powerUpDelta = 0
    @powerUpSpawnTime = 8000
    @powerUpVelocity = 100
    @powerUpTime = 5000
    @poweredUpDelta = 0

    @background = @game.add.sprite(0, 0, 'bg')
    @createPlayer()
    @createLasers()
    @createPowerUps()
    @createEnemies()
    @createScoreText()
    @createLivesText()
    @cursor = @game.input.keyboard.createCursorKeys()
    @startTime = @game.time.now

  update: ->
    @player.body.velocity.x = 0

    if @cursor.left.isDown
      @player.body.velocity.x = -@playerVelocity
    else if @cursor.right.isDown
      @player.body.velocity.x = @playerVelocity

    if @cursor.up.isDown
      @fire()

    @updateEnemySpeed()
    @spawnEnemy()
    @spawnPowerUps()
    @updateScoreText()
    @updateLivesText()

    @game.physics.overlap(@player, @enemies, @playerHit, null, this)
    @game.physics.overlap(@lasers, @enemies, @enemyHit, null, this)
    @game.physics.overlap(@lasers, @powerUps, @powerUpHit, null, this)
    @game.physics.overlap(@player, @powerUps, @powerUpPlayer, null, this)

  createPlayer: ->
    @player = @game.add.sprite(0, 0, 'player')
    @player.body.collideWorldBounds = true
    @player.y = (@game.height - @player.height) - 20
    @player.x = @game.width / 2 - @player.width / 2

  createLasers: ->
    @lasers =  @game.add.group()
    @lasers.createMultiple(40, 'laser')
    @lasers.setAll('outOfBoundsKill', true)

  createEnemies: ->
    @enemies =  @game.add.group()
    @enemies.createMultiple(25, 'enemy1')
    @enemies.setAll('outOfBoundsKill', true)
    @enemies.setAll('scale.x', 0.5)
    @enemies.setAll('scale.y', 0.5)

  createPowerUps: ->
    @powerUps = @game.add.group()
    @powerUps.createMultiple(5, 'powerUp')
    @powerUps.setAll('outOfBoundsKill', true)

  fire: ->
    if @game.time.now > @laserDelta
      @spawnOneLaserBeam()
      @laserDelta = @game.time.now + @timeBetweenLaserBeams
      bounce = @game.add.tween(@player)
      bounce
        .to({ y: @player.y + 5 }, 80, Phaser.Easing.Bounce.None)
        .to({ y: @player.y }, 80, Phaser.Easing.Bounce.None)
        .start()

  spawnOneLaserBeam: ->
    if @isPoweredUp
      laser1 = @lasers.getFirstExists(false)
      laser1.reset(@player.x, @player.y)
      laser1.body.velocity.y =- @laserVelocity

      laser2 = @lasers.getFirstExists(false)
      laser2.reset(@player.x + @player.width, @player.y)
      laser2.body.velocity.y =- @laserVelocity

      if @game.time.now > @poweredUpDelta
        @isPoweredUp = false
    else
      laser = @lasers.getFirstExists(false)
      laser.reset(@player.x + (@player.width / 2 - 3), @player.y)
      laser.body.velocity.y =- @laserVelocity

  spawnEnemy: ->
    if @game.time.now > @enemyDelta
      @spawnOneEnemy()
      @enemyDelta = @game.time.now + @enemySpawnTime()

  spawnPowerUps: ->
    if @game.time.now > @powerUpDelta
      @spawnOnePowerUp()
      @powerUpDelta = @game.time.now + @powerUpSpawnTime

  spawnOnePowerUp: ->
    powerUp = @powerUps.getFirstExists(false)
    powerUp.reset(@game.rnd.realInRange(powerUp.width, @game.world.width - powerUp.width), -powerUp.width)
    powerUp.body.velocity.y += @powerUpVelocity

  createScoreText: ->
    @scoreText = @game.add.text(20, 20, @score, { fontSize: '14px', fill: 'white'})

  createLivesText: ->
    @livesText = @game.add.text(0, 0, @lives, { fontSize: '14px', fill: 'white'})
    @livesText.anchor = new Phaser.Point(1,0)
    @livesText.x = @game.width - 20
    @livesText.y = 20

  enemySpawnTime: ->
    spawnTimeRange = @averageEnemySpawnTime * 0.2
    upper = @averageEnemySpawnTime + spawnTimeRange
    lower = @averageEnemySpawnTime - spawnTimeRange
    return @game.rnd.integerInRange(lower, upper)

  spawnOneEnemy: ->
    enemy = @enemies.getFirstExists(false)
    enemy.reset(@game.rnd.realInRange(enemy.width, @game.world.width - enemy.width), -enemy.width)
    enemy.body.velocity.y =+ @enemyVelocity
    # tween = @game.add.tween(enemy.scale)
    # tween
    #   .to({ x: 0.3, y: 0.3 }, 500, Phaser.Easing.Bounce.IN, true, 90, true, true)

  playerHit: (player, enemy) ->
    enemy.kill()
    bounce = @game.add.tween(@player)
    bounce
      .to({ alpha: 0.4 }, 100, Phaser.Easing.Bounce.None)
      .to({ alpha: @player.alpha }, 100, Phaser.Easing.Bounce.None)
      .start()
    if (@lives == 1)
      @player.kill()
      @game.state.start('postGame', false)
    @lives -= 1

  enemyHit: (laser, enemy) ->
    laser.kill()
    enemy.kill()
    @score += 1

  updateScoreText: ->
    @scoreText.content = @score

  updateLivesText: ->
    @livesText.content = @lives
    if @lives is 1
      f = @livesText.font
      f.fill = '#ff0000'
      @livesText.setStyle(f)

  updateEnemySpeed: ->
    velocityAddOn = (@game.time.now - @startTime) / 1000
    @enemyVelocity = @baseEnemyVelocity + velocityAddOn

  powerUpHit: (laser, powerUp) ->
    laser.kill()
    powerUp.kill()

  powerUpPlayer: (player, powerUp)->
    powerUp.kill()
    @score =+ 10
    @isPoweredUp = true
    @poweredUpDelta = @game.time.now + @powerUpTime
