#ifndef _SRC_MAIN_HPP
#define _SRC_MAIN_HPP

#define STATE_IDLE 0
#define STATE_SDO_RX 1
#define STATE_SDO_TX 2
#define STATE_NODE 3

#define STATE_ID 0
#define STATUS_ID 4
#define PROCESS_ID 8

#define RX_QUEUE_SIZE 50
#define TX_QUEUE_SIZE 50
#define CAN_SEND_PERIOD 1000

#define TEST_MODE true
#define SILENT_MODE false
#define MAX_LOG_SIZE 1000

#include <Arduino.h>
#include <CAN.h>
#include <string>
#include <stdio.h>
#include <math.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "deque"

#include "can_structures.hpp"

#endif  // _SRC_MAIN_HPP
