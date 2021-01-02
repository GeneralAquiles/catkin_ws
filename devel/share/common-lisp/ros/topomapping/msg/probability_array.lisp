; Auto-generated. Do not edit!


(cl:in-package topomapping-msg)


;//! \htmlinclude probability_array.msg.html

(cl:defclass <probability_array> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (stamp
    :reader stamp
    :initarg :stamp
    :type cl:real
    :initform 0)
   (items
    :reader items
    :initarg :items
    :type (cl:vector topomapping-msg:probability_element)
   :initform (cl:make-array 0 :element-type 'topomapping-msg:probability_element :initial-element (cl:make-instance 'topomapping-msg:probability_element))))
)

(cl:defclass probability_array (<probability_array>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <probability_array>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'probability_array)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name topomapping-msg:<probability_array> is deprecated: use topomapping-msg:probability_array instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <probability_array>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader topomapping-msg:header-val is deprecated.  Use topomapping-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'stamp-val :lambda-list '(m))
(cl:defmethod stamp-val ((m <probability_array>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader topomapping-msg:stamp-val is deprecated.  Use topomapping-msg:stamp instead.")
  (stamp m))

(cl:ensure-generic-function 'items-val :lambda-list '(m))
(cl:defmethod items-val ((m <probability_array>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader topomapping-msg:items-val is deprecated.  Use topomapping-msg:items instead.")
  (items m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <probability_array>) ostream)
  "Serializes a message object of type '<probability_array>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__sec (cl:floor (cl:slot-value msg 'stamp)))
        (__nsec (cl:round (cl:* 1e9 (cl:- (cl:slot-value msg 'stamp) (cl:floor (cl:slot-value msg 'stamp)))))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 0) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __nsec) ostream))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'items))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'items))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <probability_array>) istream)
  "Deserializes a message object of type '<probability_array>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((__sec 0) (__nsec 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 0) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __nsec) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'stamp) (cl:+ (cl:coerce __sec 'cl:double-float) (cl:/ __nsec 1e9))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'items) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'items)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'topomapping-msg:probability_element))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<probability_array>)))
  "Returns string type for a message object of type '<probability_array>"
  "topomapping/probability_array")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'probability_array)))
  "Returns string type for a message object of type 'probability_array"
  "topomapping/probability_array")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<probability_array>)))
  "Returns md5sum for a message object of type '<probability_array>"
  "d7eef3967fccdc2e28dbf74447871695")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'probability_array)))
  "Returns md5sum for a message object of type 'probability_array"
  "d7eef3967fccdc2e28dbf74447871695")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<probability_array>)))
  "Returns full string definition for message of type '<probability_array>"
  (cl:format cl:nil "Header header~%time stamp~%probability_element[] items~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: topomapping/probability_element~%#Standard metadata for higher-level flow data types~%string name~%float64  prob~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'probability_array)))
  "Returns full string definition for message of type 'probability_array"
  (cl:format cl:nil "Header header~%time stamp~%probability_element[] items~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: topomapping/probability_element~%#Standard metadata for higher-level flow data types~%string name~%float64  prob~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <probability_array>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     8
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'items) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <probability_array>))
  "Converts a ROS message object to a list"
  (cl:list 'probability_array
    (cl:cons ':header (header msg))
    (cl:cons ':stamp (stamp msg))
    (cl:cons ':items (items msg))
))
