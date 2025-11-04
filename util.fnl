(fn point-within? [point boundingBox]
  (if (and point boundingBox)
    (let [{:x x :y y} point
          {:x x2 :y y2
           :width width
           :height height} boundingBox]
      (and width height x2 y2 x y
           (<= x2 x (+ width x2))
           (<= y2 y (+ height y2))))
    false))

{: point-within?}
