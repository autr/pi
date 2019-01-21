from oscpy.server import OSCThreadServer
from time import sleep

def callback(values):
    print("got values: {}".format(values))

osc = OSCThreadServer()
sock = osc.listen(address='0.0.0.0', port=7000, default=True)
osc.bind(b'/Ultrasonic', callback)
sleep(1000)
osc.stop()
