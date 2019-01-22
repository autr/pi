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


      time.sleep(3)

      print "Calculating distance"
      while True:


            timestamp = time.time()
            sendValue = True


            GPIO.output(PIN_TRIGGER, GPIO.HIGH)
            time.sleep(0.0001)
            GPIO.output(PIN_TRIGGER, GPIO.LOW)

            maxTime = 400.0 / 17150.0
            
            loop_start_time = time.time()

            # print ">"

            skipped = ""

            while GPIO.input(PIN_ECHO)==0:
                  pulse_start_time = time.time()
                  if ( (pulse_start_time - loop_start_time) > maxTime ):
                        skipped = " START SKIPPED"
                        break
            while GPIO.input(PIN_ECHO)==1:
                  pulse_end_time = time.time()
                  if ( (pulse_end_time - pulse_start_time) > maxTime ):
                        skipped = " END SKIPPED"
                        pulse_end_time = pulse_start_time + maxTime
                        break

            pulse_duration = pulse_end_time - pulse_start_time
            distance = round(pulse_duration * 17150, 1)

            if (sendValue):

                  osc.send_message(b'/Ultrasonic', [distance])
                  print "Distance:", distance, "cm", skipped
            else:
                  print "Skipping no returned echo"

            time.sleep(0.05)
            
except KeyboardInterrupt:
      print("Measurement stopped by User")
      GPIO.cleanup()