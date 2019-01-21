#!/usr/bin/python

import sys
import RPi.GPIO as GPIO
import time
import os
from subprocess import Popen
from oscpy.client import OSCClient

v1 = "/media/pi/UNTITLED/AutrSpettra-Insta1.mov"
v2 = "/media/pi/UNTITLED/AutrSpettra-Insta2.mov"
vCurrent = v1

timestamp = 0

smooth_distance = 0
smoothing = 0.9

isPlaying = False

try:
      GPIO.setmode(GPIO.BOARD)

      PIN_TRIGGER = 12
      PIN_ECHO = 11

      GPIO.setup(PIN_TRIGGER, GPIO.OUT)
      GPIO.setup(PIN_ECHO, GPIO.IN)

      GPIO.output(PIN_TRIGGER, GPIO.LOW)

      print "Waiting for sensor to settle"
      print "Smoothing set to: " + str(smoothing)

      osc = OSCClient('127.0.0.1', 7000)

      time.sleep(2)

      while 1:

            GPIO.output(PIN_TRIGGER, GPIO.HIGH)
            time.sleep(0.00001)
            GPIO.output(PIN_TRIGGER, GPIO.LOW)

            frame_start = time.time()

            while GPIO.input(PIN_ECHO)==0:
                  pulse_start_time = time.time()

            while GPIO.input(PIN_ECHO)==1:
                  pulse_end_time = time.time()

            pulse_duration = pulse_end_time - pulse_start_time
 













































            distance = round(pulse_duration * 17150, 2)


























            smooth_distance = ( distance * (1.0 - smoothing)) + (smooth_distance * smoothing)































            width = 100 # aka 6 metres
            dist = smooth_distance / 6


            offset = time.time() - timestamp

            if offset > 2:
                  if smooth_distance < 100:

                        if vCurrent != v2:
                              txt = ""
                              for i in xrange(100):
                                    txt += " "
                              txt += "VIDEO 2"
                              print(txt)
                              vCurrent = v2
                              timestamp = time.time()
                              osc.send_message(b'/Presence', [1])
                              # os.system('killall omxplayer.bin')
                              # omxc = Popen(['omxplayer', '-b', v2])
                  else:
                        if vCurrent != v1:
                              txt = ""
                              for i in xrange(100):
                                    txt += " "
                              txt += "VIDEO 1"
                              print(txt)
                              vCurrent = v1
                              timestamp = time.time()
                              osc.send_message(b'/Presence', [0])
                              # os.system('killall omxplayer.bin')
                              # omxc = Popen(['omxplayer', '-b', v1])

            txt = "";

            for i in xrange(width):
                  # time.sleep(0.1)
                  if i < dist:
                        txt += "="
                  else:
                        txt += "-"
            txt += str(int(smooth_distance))
            print txt

            osc.send_message(b'/Ultrasonic', [smooth_distance])
            time.sleep(0.05)


except KeyboardInterrupt:
      # os.system('killall omxplayer.bin')
      GPIO.cleanup()