(local scene {})
(local ebus (require :event-bus))
(var state (require :game-scene-state))
(local util (require :util))
(local songs (require :songs))
(local assets (require :assets))
(local anim8 (require :lib.anim8))
(local flux (require :lib.flux))

(local mushroom (require :mushroom))
(local cauldron (require :cauldron))
(local tab (require :chartab))
(local book (require :book))
(local bigbook (require :bigbook))
(local button (require :button))

(local lg love.graphics)

(fn mushroom-played [{:note note}]
  (local falling-mushroom {:x (+ 192 (love.math.random -25 25))
                           :y 80
                           :note note})
  (-> 
   (flux.to falling-mushroom 0.5 {:y 140})
   (: :ease "quadin"))
  (table.insert state.falling-mushrooms falling-mushroom))

(fn cauldron-clear []
  (set state.falling-mushrooms [])
  (set state.notes []))

(fn book-open []
  (set state.book-open? true))

(fn book-close []
  (set state.book-open? nil))

(fn scene.load []
  (ebus.subscribe :note-played mushroom-played)
  (ebus.subscribe :cauldron-cleared cauldron-clear)
  (ebus.subscribe :book-open book-open)
  (ebus.subscribe :book-close book-close)
  (tab.load-assets)
  (set state {})
  (set state.notes [])
  (set state.falling-mushrooms [])
  (set state.songs (songs.new))
  (set state.tab (tab.new state.songs))
  (set state.cauldron (cauldron.new {:x 118 :y 112 :width (* 2 76) :height (* 2 49)}))
  (set state.mushrooms [(mushroom.new {:x 0 :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :c})
                        (mushroom.new {:x (* 46 1) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :d})
                        (mushroom.new {:x (* 46 2) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :e})
                        (mushroom.new {:x (* 46 3) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :f})
                        (mushroom.new {:x (* 46 4) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :g})
                        (mushroom.new {:x (* 46 5) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :a})
                        (mushroom.new {:x (* 46 6) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :b})
                        (mushroom.new {:x (* 46 7) :y 200 :width 44 :height 44 
                                       :sound assets.bell-sound :tone :high-c})])

  (set state.cat-anim (anim8.newAnimation (assets.cat-animation-grid "1-18" 1) 0.125))
  (set state.littlebook (book.new {:x 285 :y 140}))
  (set state.startTime (love.timer.getTime)))

(fn set-win []
  (set state.elapsedTime
       (- (love.timer.getTime) state.startTime))
  (set state.win? true)
  (set state.replay-button
       (button.new {:x 150 :y 85 :text "Restart"
                    :width 80 :height 18
                    :t-off-x 7 :t-off-y 2
                    :keybinding :g
                    :onclick
                    (fn []
                       (ebus.push :change-scene {:new-scene :title-scene}))}))) 

(fn scene.update [dt]
  (state.cat-anim:update dt)
  (cauldron.update state.cauldron state.notes dt)
  (each [i m (pairs state.falling-mushrooms)] 
    (when (< 135 m.y)
      (table.insert state.notes m.note)
      (when (and (util.notes-equal? state.notes state.tab.song.notes)
                 (not state.tab.completed?))
        (set state.tab.completed? true)
        (: (assets.complete-sound:clone) :play)
        (set state.notes [])
        (ebus.push :song-played state.tab.song)
        (tab.dismiss state.tab 
                     (fn []
                       (if (= 0 (length state.songs))
                           (set-win)
                           (set state.tab (tab.new state.songs))))))
      (table.remove state.falling-mushrooms i)))

  (each [_ m (pairs state.mushrooms)] 
    (mushroom.update m dt))
  (book.update state.littlebook dt)
  (tab.update state.tab dt)
  (bigbook.update dt)
  (when state.replay-button
    (button.update state.replay-button dt))
  )

(fn scene.draw []
  (lg.draw assets.background 0 0 0 2 2)
  (lg.draw assets.potion 85 150 0 2 2)
  (state.cat-anim:draw assets.cat-sheet 190 65 0 2 2)
  (if state.win? 
      (lg.print (string.format "%.2f" state.elapsedTime) (- _G.game-width 40) 0 0 1)
      (lg.print (string.format "%.2f" (- (love.timer.getTime) state.startTime)) (- _G.game-width 40) 0 0 1))
  (cauldron.draw state.cauldron)
  (each [_ m (pairs state.mushrooms)] 
    (mushroom.draw m))

  (each [_ m (pairs state.falling-mushrooms)] 
    (let [color (case m.note
                  :c [0.6 0 0.6]
                  :d [0.3 0 0.6]
                  :e [0 0.4 0.8]
                  :f [0 0.4 0]
                  :g [0.9 0.9 0.4]
                  :a [0.9 0.6 0.2]
                  :b [0.7 0.1 0.1]
                  :high-c [0.3 0.2 0.1])]
      (lg.setColor color)
      (lg.rectangle :fill m.x m.y 6 6)))

  (each [i note (ipairs state.notes)]
    (let [color (case note
                  :c [0.6 0 0.6]
                  :d [0.3 0 0.6]
                  :e [0 0.4 0.8]
                  :f [0 0.4 0]
                  :g [0.9 0.9 0.4]
                  :a [0.9 0.6 0.2]
                  :b [0.7 0.1 0.1]
                  :high-c [0.3 0.2 0.1])]
      (lg.setColor color))
    (lg.rectangle :fill (- (* i 8) 6) (- _G.game-height 8) 6 6))
  (lg.setColor 1 1 1)
  (book.draw state.littlebook)
  (tab.draw state.tab)

  (when state.win?
    (lg.print "You win!" 120 (- (/ _G.game-height 2) 80)
              0 2 2))

  (when state.replay-button
    (button.draw state.replay-button))

  (when state.book-open?
    (bigbook.draw)))

(fn scene.keypressed [key]
  (when (not state.book-open?)
    (each [_ m (pairs state.mushrooms)] 
      (mushroom.keypressed m key))
    (cauldron.keypressed state.cauldron key)
    (book.keypressed state.littlebook key)
    (when state.replay-button
      (button.keypressed state.replay-button key)))

  (when state.book-open?
    (bigbook.keypressed key)))

(fn scene.mousepressed [x y mouse-button istouch presses]
  (when (not state.book-open?)
    (each [_ m (pairs state.mushrooms)] 
      (mushroom.on-click m))
    (cauldron.on-click state.cauldron)
    (book.on-click state.littlebook)
    (when state.replay-button
      (button.mousepressed state.replay-button)))

  (when state.book-open?
    (bigbook.mousepressed)))

(fn scene.mousereleased [x y button istouch presses])

scene
