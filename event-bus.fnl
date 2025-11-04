(local subscribers {})
(local events [])
(local fennel (require :lib.fennel))

(fn subscribe [eventType callback]
  (case (. subscribers eventType)
    c (table.insert (. subscribers eventType) callback)
    _ (set (. subscribers eventType) [callback])))

(fn push [eventType event]
  (tset event :type eventType)
  (table.insert events event))

(fn dispatch-one [events event-count]
  (when (and (< 0 (length events))
             (< event-count 50))
    (let [event (table.remove events 1)
          callbacks (. subscribers event.type)]
      (when callbacks 
        (each [_ c (ipairs callbacks)]
          (c event)))
      (tail! (dispatch-one events (+ 1 event-count))))))

(fn dispatch []
  (dispatch-one events 0))

(comment 
 (subscribe :on-click (fn [] (print "yo")))

 (push :on-click {:yo "dawg"})

 (dispatch)

 )

{: push : dispatch : subscribe}
