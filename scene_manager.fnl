(var scene nil)

(fn change-scene [new-scene]
  (new-scene.load)
  (set scene new-scene))

(fn update [dt]
  (scene.update dt))

(fn draw []
  (scene.draw))


{: change-scene : update : draw}
