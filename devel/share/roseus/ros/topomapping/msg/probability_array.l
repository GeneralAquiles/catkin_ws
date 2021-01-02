;; Auto-generated. Do not edit!


(when (boundp 'topomapping::probability_array)
  (if (not (find-package "TOPOMAPPING"))
    (make-package "TOPOMAPPING"))
  (shadow 'probability_array (find-package "TOPOMAPPING")))
(unless (find-package "TOPOMAPPING::PROBABILITY_ARRAY")
  (make-package "TOPOMAPPING::PROBABILITY_ARRAY"))

(in-package "ROS")
;;//! \htmlinclude probability_array.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass topomapping::probability_array
  :super ros::object
  :slots (_header _stamp _items ))

(defmethod topomapping::probability_array
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:stamp __stamp) (instance ros::time :init))
    ((:items __items) (let (r) (dotimes (i 0) (push (instance topomapping::probability_element :init) r)) r))
    )
   (send-super :init)
   (setq _header __header)
   (setq _stamp __stamp)
   (setq _items __items)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:stamp
   (&optional __stamp)
   (if __stamp (setq _stamp __stamp)) _stamp)
  (:items
   (&rest __items)
   (if (keywordp (car __items))
       (send* _items __items)
     (progn
       (if __items (setq _items (car __items)))
       _items)))
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; time _stamp
    8
    ;; topomapping/probability_element[] _items
    (apply #'+ (send-all _items :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; time _stamp
       (write-long (send _stamp :sec) s) (write-long (send _stamp :nsec) s)
     ;; topomapping/probability_element[] _items
     (write-long (length _items) s)
     (dolist (elem _items)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; time _stamp
     (send _stamp :sec (sys::peek buf ptr- :integer)) (incf ptr- 4)  (send _stamp :nsec (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; topomapping/probability_element[] _items
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _items (let (r) (dotimes (i n) (push (instance topomapping::probability_element :init) r)) r))
     (dolist (elem- _items)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get topomapping::probability_array :md5sum-) "d7eef3967fccdc2e28dbf74447871695")
(setf (get topomapping::probability_array :datatype-) "topomapping/probability_array")
(setf (get topomapping::probability_array :definition-)
      "Header header
time stamp
probability_element[] items
================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: topomapping/probability_element
#Standard metadata for higher-level flow data types
string name
float64  prob
")



(provide :topomapping/probability_array "d7eef3967fccdc2e28dbf74447871695")


