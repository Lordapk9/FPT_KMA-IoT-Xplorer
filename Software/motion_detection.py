import json
import subprocess
import time
from threading import Lock, Thread

import cv2
import numpy as np
import paho.mqtt.client as mqtt
import torch


class RTSPProcessor:
    def __init__(self, rtsp_cam, mqtt_server, mqtt_port, mqtt_topic):
        self.rtsp_cam = rtsp_cam
        self.mqtt_server = mqtt_server
        self.mqtt_port = mqtt_port
        self.mqtt_topic = mqtt_topic
        
        
        self.processing_running = False
        self.reading_running = False

        self.processing_thread = None
        self.reading_thread = None

        self.cap = None
        self.frame = None
        self.lock = Lock()

        self.fgbg = cv2.createBackgroundSubtractorMOG2(history=500, varThreshold=100, detectShadows=True)
        self.model = torch.hub.load('ultralytics/yolov5', 'yolov5s', pretrained=True)
        self.target_classes = ['person']

        self.client = mqtt.Client()
        self.client.connect(self.mqtt_server, self.mqtt_port, 60)
        self.client.loop_start()
        
        self.stream_status = 0
        
        self.start_rtsp_stream()

    def start_rtsp_stream(self):
        if not self.reading_running:
            self.reading_running = True
            self.reading_thread = Thread(target=self.read_video)
            self.reading_thread.start()
        
        if not self.processing_running:
            self.processing_running = True
            self.processing_thread = Thread(target=self.process_video)
            self.processing_thread.start()
            
            subprocess.Popen(['pkill', 'ffplay'])
            print("Started RTSP stream and image processing")

    def stop_rtsp_stream(self):
        if self.processing_running or self.reading_running:
            self.processing_running = False
            self.reading_running = False

            if self.processing_thread and self.processing_thread.is_alive():
                self.processing_thread.join()
            if self.reading_thread and self.reading_thread.is_alive():
                self.reading_thread.join()

            print("Stopped RTSP stream and image processing")

    def on_message(self, client, userdata, msg):
        try:
            payload = json.loads(msg.payload.decode())
            if "stream_status" in payload:
                new_stream_status = payload["stream_status"]
                print(f"Stream status updated: {new_stream_status}")
                
                if new_stream_status != self.stream_status:
                    if new_stream_status == 0 and self.stream_status == 1:
                        self.start_rtsp_stream()
                    elif new_stream_status == 1 and self.stream_status == 0:
                        self.stop_rtsp_stream()
                    self.stream_status = new_stream_status
                    print(f"Stream status self: {self.stream_status}")
        
        except Exception as e:
            print(f"Error parsing message: {e}")

    def read_video(self):
        self.cap = cv2.VideoCapture(self.rtsp_cam)
        
        while self.reading_running and self.cap.isOpened():
            ret, frame = self.cap.read()
            if not ret:
                break
            with self.lock:
                self.frame = self.preprocess(frame)
        self.cap.release()

    def process_video(self):
        while self.processing_running:
            if self.frame is not None:
                with self.lock:
                    frame = self.frame.copy()
                fgmask = self.fgbg.apply(frame)

                contours, _ = cv2.findContours(fgmask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                moving = any(cv2.contourArea(contour) > 500 for contour in contours)

                person_detected = False
                if moving:
                    results = self.model(frame)

                    for index, row in results.pandas().xyxy[0].iterrows():
                        if row['name'] in self.target_classes:
                            name = str(row['name'])
                            x1 = int(row['xmin'])
                            y1 = int(row['ymin'])
                            x2 = int(row['xmax'])
                            y2 = int(row['ymax'])


                            if name == 'person':
                                person_detected = True
                                payload = json.dumps({
                                    "motion": 1,
                                    "rtsp_link": self.rtsp_cam
                                })
                                self.client.publish(self.mqtt_topic, payload)
                                break

                    if not person_detected:
                        payload = json.dumps({
                            "motion": 0,
                            "rtsp_link": self.rtsp_cam
                        })
                        self.client.publish(self.mqtt_topic, payload)
            time.sleep(0.1) 

    @staticmethod
    def preprocess(img):
        resized_img = cv2.resize(img, (640, 480))  
        return resized_img

if __name__ == "__main__":
    rtsp_cam = "rtsp://192.168.0.45:8554/stream"
    mqtt_server = "192.168.0.45"
    mqtt_port = 1883
    mqtt_topic = "home/camera"

    processor = RTSPProcessor(rtsp_cam, mqtt_server, mqtt_port, mqtt_topic)

    processor.client.on_message = processor.on_message
    processor.client.subscribe(mqtt_topic)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Exiting...")
        processor.stop_rtsp_stream()
        processor.client.loop_stop()


