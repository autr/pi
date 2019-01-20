#!/usr/bin/python
import RPi.GPIO as GPIO
import time
from oscpy.client import OSCClient


try:
      osc = OSCClient('127.0.0.1', 7000)


      GPIO.setmode(GPIO.BOARD)

      PIN_TRIGGER = 12
      PIN_ECHO = 11

      GPIO.setup(PIN_TRIGGER, GPIO.OUT)
      GPIO.setup(PIN_ECHO, GPIO.IN)

      GPIO.output(PIN_TRIGGER, GPIO.LOW)

      print "Waiting for sensor to settle"


      time.sleep(2)

      print "Calculating distance"
      while True:

            GPIO.output(PIN_TRIGGER, GPIO.HIGH)

            time.sleep(0.00001)

            GPIO.output(PIN_TRIGGER, GPIO.LOW)

            while GPIO.input(PIN_ECHO)==0:
                  pulse_start_time = time.time()
            while GPIO.input(PIN_ECHO)==1:
                  pulse_end_time = time.time()

            pulse_duration = pulse_end_time - pulse_start_time
            distance = round(pulse_duration * 17150, 2)

            osc.send_message(b'/Ultrasonic', [distance])

            print "Distance:", distance, "cm"
except KeyboardInterrupt:
      print("Measurement stopped by User")
      GPIO.cleanup()