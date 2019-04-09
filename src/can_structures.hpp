#ifndef _SRC_CAN_MESSAGE_HPP
#define _SRC_CAN_MESSAGE_HPP

#define CAN_MAX_DATA_LEN 8

typedef struct {
  uint32_t identifier;            /**< 11 or 29 bit identifier */
  uint8_t data_length_code;       /**< Data length code */
  uint8_t data[CAN_MAX_DATA_LEN]; /**< Data bytes (not relevant in RTR frame) */
} can_message_t;

#endif  // _SRC_CAN_MESSAGE_HPP
