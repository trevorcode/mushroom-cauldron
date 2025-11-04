(local subscribers {}) 
(local events [])

(fn subscribe [eventType callback sub-type]
  (let [sub-type (or sub-type :scene)]
    (case (. subscribers eventType)
      c (table.insert (. subscribers eventType) {:sub-type sub-type
                                                 :callback callback})
      _ (set (. subscribers eventType) [{:sub-type sub-type
                                         :callback callback}]))))

(fn clear-subscriptions [sub-type]
  (each [eventType callbacks (pairs subscribers)]
    (set (. subscribers eventType)
         (icollect [_ c (ipairs callbacks)]
                 (when (not= sub-type c.sub-type)
                     c)))))

(fn push [eventType event]
  (tset event :type eventType)
  (table.insert events event))

(fn dispatch-recur [events event-count]
  (when (and (< 0 (length events))
             (< event-count 100))
    (let [event (table.remove events 1)
          callbacks (. subscribers event.type)]
      (when callbacks 
        (each [_ c (ipairs callbacks)]
          (c.callback event)))
      (tail! (dispatch-recur events (+ 1 event-count))))))

(fn dispatch []
  (dispatch-recur events 0))

(comment 
 (subscribe :on-click (fn [] (print "yo")) :scene)  
 (clear-subscriptions :scene)

 (push :on-click {:yo "dawg"})

 (dispatch)

 )

{: push : dispatch : subscribe : clear-subscriptions}
