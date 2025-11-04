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
      (: (state.water-sound:clone) :play)))

(fn test.load []
  (ebus.clear-subscriptions)
  (ebus.subscribe :keypressed (fn [event] (print (fennel.view event))))
  (ebus.subscribe :keypressed test.keypressed)
  (set state.bell-sound (love.audio.newSource :assets/bell.wav :static))
  (set state.water-sound (love.audio.newSource :assets/water.wav :static))
  (set _G.rock (love.graphics.newImage :assets/rock.png))
  (set state.font-test (love.graphics.newFont 48))
  (set state.mushrooms [(mushroom.new {:x 0 :y 0 :width 100 :height 100 :img nil
                                       :sound state.bell-sound :tone :c})
                        (mushroom.new {:x 110 :y 0 :width 100 :height 100 :img nil
                                       :sound state.bell-sound :tone :d})
                        (mushroom.new {:x 220 :y 0 :width 100 :height 100 :img nil
                                       :sound state.bell-sound :tone :e})
                        (mushroom.new {:x 330 :y 0 :width 100 :height 100 :img nil
                                       :sound state.bell-sound :tone :f})
                        (mushroom.new {:x 440 :y 0 :width 100 :height 100 :img nil
                                       :sound state.bell-sound :tone :g})
                        (mushroom.new {:x 550 :y 0 :width 100 :height 100 :img nil
                                       :sound state.bell-sound :tone :a})
                        (mushroom.new {:x 660 :y 0 :width 100 :height 100 :img nil
                                       :sound state.bell-sound :tone :b})
                        (mushroom.new {:x 770 :y 0 :width 100 :height 100 :img nil
                                       :sound state.bell-sound :tone :high-c})
                        ])
  )

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

test
