; Auto-generated. Do not edit!


(cl:in-package topomapping-msg)


;//! \htmlinclude probability_element.msg.html

(cl:defclass <probability_element> (roslisp-msg-protocol:ros-message)
  ((name
    :reader name
    :initarg :name
    :type cl:string
    :initform "")
   (prob
    :reader prob
    :initarg :prob
    :type cl:float
    :initform 0.0))
)

(cl:defclass probability_element (<probability_element>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <probability_element>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'probability_element)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name topomapping-msg:<probability_element> is deprecated: use topomapping-msg:probability_element instead.")))

(cl:ensure-generic-function 'name-val :lambda-list '(m))
(cl:defmethod name-val ((m <probability_element>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader topomapping-msg:name-val is deprecated.  Use topomapping-msg:name instead.")
  (name m))

(cl:ensure-generic-function 'prob-val :lambda-list '(m))
(cl:defmethod prob-val ((m <probability_element>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader topomapping-msg:prob-val is deprecated.  Use topomapping-msg:prob instead.")
  (prob m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <probability_element>) ostream)
  "Serializes a message object of type '<probability_element>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'name))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'prob))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <probability_element>) istream)
  "Deserializes a message object of type '<probability_element>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'prob) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<probability_element>)))
  "Returns string type for a message object of type '<probability_element>"
  "topomapping/probability_element")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'probability_element)))
  "Returns string type for a message object of type 'probability_element"
  "topomapping/probability_element")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<probability_element>)))
  "Returns md5sum for a message object of type '<probability_element>"
  "916a46374b9c700aab897fae5ce97305")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'probability_element)))
  "Returns md5sum for a message object of type 'probability_element"
  "916a46374b9c700aab897fae5ce97305")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<probability_element>)))
  "Returns full string definition for message of type '<probability_element>"
  (cl:format cl:nil "#Standard metadata for higher-level flow data types~%string name~%float64  prob~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'probability_element)))
  "Returns full string definition for message of type 'probability_element"
  (cl:format cl:nil "#Standard metadata for higher-level flow data types~%string name~%float64  prob~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <probability_element>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'name))
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <probability_element>))
  "Converts a ROS message object to a list"
  (cl:list 'probability_element
    (cl:cons ':name (name msg))
    (cl:cons ':prob (prob msg))
))
