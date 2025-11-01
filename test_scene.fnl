(local test {})
(local state (require :test-scene-state))

(local lg love.graphics)

(fn test.load []
  (set _G.rock (love.graphics.newImage :assets/rock.png))
  (set state.font-test (love.graphics.newFont 48)))

(fn test.update [])

(fn test.draw []
  (lg.setFont state.font-test)
  (lg.setColor 0.6 0.6 1)
  (lg.rectangle :fill 0 0 _G.game-width _G.game-height)
  (lg.setColor 1 1 1)
  (lg.draw _G.rock 0 0 0 0.3)
  (lg.print "Hello from FENNEL!\n" 0 0)
  (lg.print (love.timer.getFPS) (- _G.game-width 70) 0 0 1))

test
