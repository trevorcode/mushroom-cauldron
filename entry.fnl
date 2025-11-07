;;(require :lib.repl)
(local scene-manager (require :scene_manager))
;;(local fennel (require :lib.fennel))
(local ebus (require :event-bus))

(local assets (require :assets))
(local push (require :lib.push))
(local flux (require :lib.flux))
(local (window-width window-height) (love.window.getDesktopDimensions))
(set _G.game-width 384)
(set _G.game-height 256)

(fn love.load []
  (love.graphics.setDefaultFilter "nearest" "nearest")
  (push:setupScreen _G.game-width
                    _G.game-height
                    (* 0.4 window-width)
                    (* 0.4 window-height)
                    {:vsync true :resizable true})
  (local myFont (love.graphics.newImageFont
                 :assets/imagefont.png
                 (.. " abcdefghijklmnopqrstuvwxyz"
                     "ABCDEFGHIJKLMNOPQRSTUVWXYZ0"
                     "123456789.,!?-+/():;%&`'*#=[]\"")))
  (assets.load-assets)
  (love.graphics.setFont myFont)
  (ebus.push :change-scene {:new-scene :title-scene}))

(fn love.draw []
  (push:start)
  (scene-manager.draw)
  (push:finish))

(fn love.update [dt]
  (ebus.dispatch)
  (flux.update dt)
  (scene-manager.update dt))

(fn love.resize [w h]
  (push:resize w h))

(fn love.keypressed [key]
  (scene-manager.keypressed key))

(fn love.mousepressed [x y button istouch presses]
  (scene-manager.mousepressed x y button istouch presses))

(fn love.mousereleased [x y button istouch presses]
  (scene-manager.mousereleased x y button istouch presses))
