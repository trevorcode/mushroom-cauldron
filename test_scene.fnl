(local test {})
(local state (require :test-scene-state))

(local lg love.graphics)

(fn test.load []
  (set state.bell-sound (love.audio.newSource :assets/bell.wav :static))
  (set state.water-sound (love.audio.newSource :assets/water.wav :static))
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

(fn test.keypressed [key]
  (if (= key :a)
      (love.event.quit)

      (= key :space)
      (: (state.water-sound:clone) :play)

      (let [s (state.bell-sound:clone)
            pitch (case key
                    :q 1.0
                    :1 (^ 2 (/ 1 12))
                    :w (^ 2 (/ 2 12))
                    :2 (^ 2 (/ 3 12))
                    :e (^ 2 (/ 4 12))
                    :r (^ 2 (/ 5 12))
                    :4 (^ 2 (/ 6 12))
                    :u (^ 2 (/ 7 12))
                    :y (^ 2 (/ 8 12))
                    :i (^ 2 (/ 9 12))
                    :9 (^ 2 (/ 10 12))
                    :o (^ 2 (/ 11 12))
                    :p 2
                    _ nil)]
        (when pitch 
          (s:setPitch pitch)
          (s:play)))))

test
