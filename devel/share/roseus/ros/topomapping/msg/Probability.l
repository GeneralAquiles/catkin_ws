;; Auto-generated. Do not edit!


(when (boundp 'topomapping::Probability)
  (if (not (find-package "TOPOMAPPING"))
    (make-package "TOPOMAPPING"))
  (shadow 'Probability (find-package "TOPOMAPPING")))
(unless (find-package "TOPOMAPPING::PROBABILITY")
  (make-package "TOPOMAPPING::PROBABILITY"))

(in-package "ROS")
;;//! \htmlinclude Probability.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass topomapping::Probability
  :super ros::object
  :slots (_header _content _stamp ))

(defmethod topomapping::Probability
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:content __content) "")
    ((:stamp __stamp) (instance ros::time :init))
    )
   (send-super :init)
   (setq _header __header)
   (setq _content (string __content))
   (setq _stamp __stamp)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:content
   (&optional __content)
   (if __content (setq _content __content)) _content)
  (:stamp
   (&optional __stamp)
   (if __stamp (setq _stamp __stamp)) _stamp)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; string _content
    4 (length _content)
    ;; time _stamp
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; string _content
       (write-long (length _content) s) (princ _content s)
     ;; time _stamp
       (write-long (send _stamp :sec) s) (write-long (send _stamp :nsec) s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; string _content
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _content (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; time _stamp
     (send _stamp :sec (sys::peek buf ptr- :integer)) (incf ptr- 4)  (send _stamp :nsec (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get topomapping::Probability :md5sum-) "3e3947f61c5dab14250e75399de0c646")
(setf (get topomapping::Probability :datatype-) "topomapping/Probability")
(setf (get topomapping::Probability :definition-)
      "#Standard metadata for higher-level flow data types
Header header
string content
#Two-integer timestamp that is expressed as:
# * stamp.secs: seconds (stamp_secs) since epoch
# * stamp.nsecs: nanoseconds since stamp_secs
# time-handling sugar is provided by the client library
time stamp

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

")



(provide :topomapping/Probability "3e3947f61c5dab14250e75399de0c646")


