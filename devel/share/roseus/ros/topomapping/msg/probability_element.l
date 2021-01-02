;; Auto-generated. Do not edit!


(when (boundp 'topomapping::probability_element)
  (if (not (find-package "TOPOMAPPING"))
    (make-package "TOPOMAPPING"))
  (shadow 'probability_element (find-package "TOPOMAPPING")))
(unless (find-package "TOPOMAPPING::PROBABILITY_ELEMENT")
  (make-package "TOPOMAPPING::PROBABILITY_ELEMENT"))

(in-package "ROS")
;;//! \htmlinclude probability_element.msg.html


(defclass topomapping::probability_element
  :super ros::object
  :slots (_name _prob ))

(defmethod topomapping::probability_element
  (:init
   (&key
    ((:name __name) "")
    ((:prob __prob) 0.0)
    )
   (send-super :init)
   (setq _name (string __name))
   (setq _prob (float __prob))
   self)
  (:name
   (&optional __name)
   (if __name (setq _name __name)) _name)
  (:prob
   (&optional __prob)
   (if __prob (setq _prob __prob)) _prob)
  (:serialization-length
   ()
   (+
    ;; string _name
    4 (length _name)
    ;; float64 _prob
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _name
       (write-long (length _name) s) (princ _name s)
     ;; float64 _prob
       (sys::poke _prob (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _name
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _name (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; float64 _prob
     (setq _prob (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(setf (get topomapping::probability_element :md5sum-) "916a46374b9c700aab897fae5ce97305")
(setf (get topomapping::probability_element :datatype-) "topomapping/probability_element")
(setf (get topomapping::probability_element :definition-)
      "#Standard metadata for higher-level flow data types
string name
float64  prob
")



(provide :topomapping/probability_element "916a46374b9c700aab897fae5ce97305")


