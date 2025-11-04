(local test {})
(local ebus (require :event-bus))
(local state (require :test-scene-state))
(local fennel (require :lib.fennel))

(local mushroom (require :mushroom))

(local lg love.graphics)

(fn test.keypressed [{:key key}]
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

(fn test.load []
  (ebus.subscribe :keypressed (fn [event] (print (fennel.view event))))
  (ebus.subscribe :keypressed test.keypressed)
  (set state.bell-sound (love.audio.newSource :assets/bell.wav :static))
  (set state.water-sound (love.audio.newSource :assets/water.wav :static))
  (set _G.rock (love.graphics.newImage :assets/rock.png))
  (set state.font-test (love.graphics.newFont 48))
  (set state.mushrooms [(mushroom.new {:x 0 :y 0 :width 100 :height 100 :img nil})
                        (mushroom.new {:x 200 :y 200 :width 100 :height 100 :img nil})
                        ]))

(fn test.update [dt]
  (ebus.dispatch)
  (each [_ m (pairs state.mushrooms)] 
    (mushroom.update m dt)))

(fn test.draw []
  (lg.setFont state.font-test)
  (lg.setColor 0.6 0.6 1)
  (lg.rectangle :fill 0 0 _G.game-width _G.game-height)
  (lg.setColor 1 1 1)
  (lg.draw _G.rock 0 0 0 0.3)
  (lg.print "Hello from FENNEL!\n" 0 0)
  (lg.print (love.timer.getFPS) (- _G.game-width 70) 0 0 1)
  (each [_ m (pairs state.mushrooms)] 
    (mushroom.draw m)))


(fn test.mousepressed [x y button istouch presses])

(fn test.mousereleased [x y button istouch presses]
  (each [_ m (pairs state.mushrooms)] 
    (mushroom.on-click m)))

test
