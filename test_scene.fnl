(local test {})
(local ebus (require :event-bus))
(local state (require :test-scene-state))
(local fennel (require :lib.fennel))
(local util (require :util))
(local songs (require :songs))
(local assets (require :assets))
(local anim8 (require :lib.anim8))

(local mushroom (require :mushroom))

(local lg love.graphics)

(fn mushroom-played [{:note note}]
  (table.insert state.notes note)
  (each [_ song (ipairs songs)]
    (when (util.notes-equal? state.notes song.notes)
      (set state.notes [])
      (print song.name))))

(fn clear-notes []
  (: (assets.water-sound:clone) :play)
  (set state.notes []))

(fn test.keypressed [{:key key}]
  (if (= key :a)
      (love.event.quit)

      (= key :space)
      (clear-notes)))

(fn test.load []
  (ebus.clear-subscriptions)
  (ebus.subscribe :keypressed test.keypressed)
  (ebus.subscribe :note-played mushroom-played)
  (set assets.bell-sound (love.audio.newSource :assets/bell.wav :static))
  (set assets.water-sound (love.audio.newSource :assets/water.wav :static))
  (set assets.background (love.graphics.newImage :assets/mushroomcauldronbackground.png))
  (set assets.mushroom-sheet (love.graphics.newImage :assets/mushrooms.png))
  (set assets.mushroom-animation-grid
       (anim8.newGrid 22 22
                      (assets.mushroom-sheet:getWidth)
                      (assets.mushroom-sheet:getHeight)))

  (set state.mushrooms [(mushroom.new {:x 0 :y 200 :width 44 :height 44 :img nil
                                       :sound assets.bell-sound :tone :c})
                        (mushroom.new {:x (* 46 1) :y 200 :width 44 :height 44 :img nil
                                       :sound assets.bell-sound :tone :d})
                        (mushroom.new {:x (* 46 2) :y 200 :width 44 :height 44 :img nil
                                       :sound assets.bell-sound :tone :e})
                        (mushroom.new {:x (* 46 3) :y 200 :width 44 :height 44 :img nil
                                       :sound assets.bell-sound :tone :f})
                        (mushroom.new {:x (* 46 4) :y 200 :width 44 :height 44 :img nil
                                       :sound assets.bell-sound :tone :g})
                        (mushroom.new {:x (* 46 5) :y 200 :width 44 :height 44 :img nil
                                       :sound assets.bell-sound :tone :a})
                        (mushroom.new {:x (* 46 6) :y 200 :width 44 :height 44 :img nil
                                       :sound assets.bell-sound :tone :b})
                        (mushroom.new {:x (* 46 7) :y 200 :width 44 :height 44 :img nil
                                       :sound assets.bell-sound :tone :high-c})]))

(fn test.update [dt]
  (each [_ m (pairs state.mushrooms)] 
    (mushroom.update m dt)))

(fn test.draw []
  (lg.draw assets.background 0 0 0 2 2)
  (lg.print (fennel.view state.notes) 0 50)
  (lg.print (love.timer.getFPS) (- _G.game-width 70) 0 0 1)
  (each [_ m (pairs state.mushrooms)] 
    (mushroom.draw m))
  

  )

test
