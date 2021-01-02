// Auto-generated. Do not edit!

// (in-package topomapping.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let probability_element = require('./probability_element.js');
let std_msgs = _finder('std_msgs');

//-----------------------------------------------------------

class probability_array {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.header = null;
      this.stamp = null;
      this.items = null;
    }
    else {
      if (initObj.hasOwnProperty('header')) {
        this.header = initObj.header
      }
      else {
        this.header = new std_msgs.msg.Header();
      }
      if (initObj.hasOwnProperty('stamp')) {
        this.stamp = initObj.stamp
      }
      else {
        this.stamp = {secs: 0, nsecs: 0};
      }
      if (initObj.hasOwnProperty('items')) {
        this.items = initObj.items
      }
      else {
        this.items = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type probability_array
    // Serialize message field [header]
    bufferOffset = std_msgs.msg.Header.serialize(obj.header, buffer, bufferOffset);
    // Serialize message field [stamp]
    bufferOffset = _serializer.time(obj.stamp, buffer, bufferOffset);
    // Serialize message field [items]
    // Serialize the length for message field [items]
    bufferOffset = _serializer.uint32(obj.items.length, buffer, bufferOffset);
    obj.items.forEach((val) => {
      bufferOffset = probability_element.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type probability_array
    let len;
    let data = new probability_array(null);
    // Deserialize message field [header]
    data.header = std_msgs.msg.Header.deserialize(buffer, bufferOffset);
    // Deserialize message field [stamp]
    data.stamp = _deserializer.time(buffer, bufferOffset);
    // Deserialize message field [items]
    // Deserialize array length for message field [items]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.items = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.items[i] = probability_element.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += std_msgs.msg.Header.getMessageSize(object.header);
    object.items.forEach((val) => {
      length += probability_element.getMessageSize(val);
    });
    return length + 12;
  }

  static datatype() {
    // Returns string type for a message object
    return 'topomapping/probability_array';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'd7eef3967fccdc2e28dbf74447871695';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    Header header
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
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new probability_array(null);
    if (msg.header !== undefined) {
      resolved.header = std_msgs.msg.Header.Resolve(msg.header)
    }
    else {
      resolved.header = new std_msgs.msg.Header()
    }

    if (msg.stamp !== undefined) {
      resolved.stamp = msg.stamp;
    }
    else {
      resolved.stamp = {secs: 0, nsecs: 0}
    }

    if (msg.items !== undefined) {
      resolved.items = new Array(msg.items.length);
      for (let i = 0; i < resolved.items.length; ++i) {
        resolved.items[i] = probability_element.Resolve(msg.items[i]);
      }
    }
    else {
      resolved.items = []
    }

    return resolved;
    }
};

module.exports = probability_array;
