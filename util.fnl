(fn point-within? [point boundingBox]
  (let [{:x x :y y} point
        {:x x2 :y y2
         :width width
         :height height} boundingBox]
    (and (<= x2 x (+ width x2))
         (<= y2 y (+ height y2)))))
