#include<WiFi.h>
#include <ArduinoJson.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <LiquidCrystal_I2C.h>
#include <ESP32Servo.h>
#include "DHT.h"
#define IR_RECEIVER_PIN 19
#define DHTPIN 13
#define DHTTYPE DHT22
#define LedPin1  32
#define LedBethroom 27
#define LedKitchen 26
#define LedPinQ 12

byte lastState = LOW;
byte currentState;
byte flagStateChange = HIGH;
byte lastState1 = LOW;
byte currentState1;
byte flagStateChange1 = HIGH;
byte lastState2 = LOW;
byte currentState2;
byte flagStateChange2 = HIGH;
byte lastState3 = LOW;
byte currentState3;
byte flagStateChange3 = HIGH;
int lastFan = 4;
int flat_lastFan = 0;
int flatDoor = 0;
int lastDoor = 1;
int flag_led = 1;
int flag_led1 = 1;
int flag_led2 = 1;
int flag_fan = 1;
int temp = 0;
int flatKitchen = 0;
int flatBethroom = 0;
int flat = 0;
int flatDh = 0;
int flatQ = 0;
int flatB = 0;
int val = 0;
byte flatGara = 0;
int val_ac = 0;
int lcdColumns = 16;
int lcdRows = 2;
LiquidCrystal_I2C lcd(0x27, lcdColumns, lcdRows);
DHT dht(DHTPIN, DHTTYPE);
bool danhan = 0;
int temparature = 0;
int sfAC = 0;
int mode = 0;
static const int servoPin = 18;
int PWM1_DutyCycle = 0;
unsigned long lastDebounceTime = 0;
unsigned long lastDebounceTime1 = 0;
unsigned long lastDebounceTime2 = 0;
unsigned long lastDebounceTime3 = 0;
unsigned long lastDebounceTime4 = 0;

const char* ssid = " "; // your SSID
const char* password = " "; // your Password

const char* mqtt_server = " "; // your MQTT broker sever
const int mqtt_port = 1883; // Or 8883

const char* mqtt_username = ""; //User
const char* mqtt_password = ""; //Password

IPAddress staticIP(192,168,137,176); // IP static
IPAddress gateway(192,168,137,1); // Gateway your Wifi
IPAddress subnet(255,255,255,0); // Subnetmask
WiFiServer server(80);

WiFiClient espClient;
PubSubClient client(espClient);

unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE (50)
char msg[MSG_BUFFER_SIZE];
char mqtt_message[128];

void setup_wifi()
{
    Serial.println("Connecting to WiFi...");
    WiFi.config(staticIP, gateway, subnet);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
    server.begin();
}

void reconnect()
{
    while (!client.connected())
    {
        Serial.print("Attempting MQTT connection...");
        if (client.connect("ESP32client",mqtt_username,mqtt_password))
        {
            Serial.println("connected");
            client.subscribe("home/bethroom");
            client.subscribe("home/livingroom");
            client.subscribe("home/kitchen");
            client.subscribe("home/garage");
            client.subscribe("home/camera/door");
        }
        else
        {
            Serial.print("failed, rc=");
            Serial.print(client.state());
            Serial.println(" try again in 5 seconds");
            delay(5000);
        }
    }
}

void publishMessage(const char* topic, String payload, boolean retained)
{
    if(client.publish(topic,payload.c_str(),true))
        Serial.println("Message published ["+String(topic)+"]: "+payload);
}
Servo servo1;
void setup()
{
    dht.begin();
    lcd.init();
    lcd.backlight();
    ESP32PWM::allocateTimer(0);
    servo1.setPeriodHertz(50);
    servo1.attach(servoPin, 1000, 2000);
    Serial.begin(9600);
    pinMode(LedPin1, OUTPUT);
    pinMode(LedBethroom,OUTPUT);
    pinMode(LedKitchen,OUTPUT);
    pinMode(LedPinQ, OUTPUT);
    while(!Serial) delay(1);
    setup_wifi();
    client.setServer(mqtt_server, mqtt_port);
    client.setCallback(callback);
}
unsigned long timeUpdata=millis();

void handleClientRequest(WiFiClient &clienthttp)
{
    String request = clienthttp.readStringUntil('\r');
    Serial.println(request);
    clienthttp.flush();
    if (request.indexOf("/on_ledlivingroom") != -1)
    {
        flat = 1;
    }
    else if (request.indexOf("/off_ledlivingroom") != -1)
    {
        flat = 0;
    }
    else if (request.indexOf("/on_ledkitchen") != -1)
    {
        flatKitchen = 1;
    }
    else if (request.indexOf("/off_ledkitchen") != -1)
    {
        flatKitchen = 0;
    }
    else if (request.indexOf("/on_bethroom") != -1)
    {
        flatBethroom = 1;
    }
    else if (request.indexOf("/off_bethroom") != -1)
    {
        flatBethroom = 0;
    }
    else if (request.indexOf("/on_fanlv1") != -1)
    {
        publishMessage("home/livingroom", "{\"Fan\":{\"Status\":true,\"Lever\":1}}", true);
    }
    else if (request.indexOf("/on_fanlv2") != -1)
    {
        publishMessage("home/livingroom", "{\"Fan\":{\"Status\":true,\"Lever\":2}}", true);
    }
    else if (request.indexOf("/on_fanlv3") != -1)
    {
        publishMessage("home/livingroom", "{\"Fan\":{\"Status\":true,\"Lever\":3}}", true);
    }
    else if (request.indexOf("/off_fan") != -1)
    {
        publishMessage("home/livingroom", "{\"Fan\":{\"Status\":false}}", true);
    }
    clienthttp.println("HTTP/1.1 200 OK");
    clienthttp.println("Content-Type: text/html");
    clienthttp.println("");
    clienthttp.println("<!DOCTYPE HTML>");
    clienthttp.println("<html>");
    clienthttp.println("OK");
    clienthttp.println("</html>");
    clienthttp.flush();
    clienthttp.stop();
}

void callback(char* topic, byte* payload, unsigned int length)
{
    StaticJsonDocument<200> docj;
    String incommingMessage = "";
    for(int i=0; i<length; i++)
    {
        incommingMessage += (char)payload[i];
    }

    Serial.println("Massage arived ["+String(topic)+"]"+incommingMessage);
    DeserializationError error = deserializeJson(docj,incommingMessage );
    if(incommingMessage != "")
    {
        JsonObject AC = docj["AC"];
        if(AC["Status"]) sfAC = 1;
        else if(AC["Status"] == 0) sfAC = 0;
        temparature = AC["Temp"];
        mode = AC["Mode"];
    }
    if(incommingMessage == "{\"\Light\"\:true}")
    {
        if(String(topic) == "home/livingroom") flat = 1;
        if(String(topic) == "home/kitchen") flatKitchen = 1;
        if(String(topic) == "home/bethroom") flatBethroom = 1;
    }
    else if(incommingMessage == "{\"\Light\"\:false}")
    {
        if(String(topic) == "home/livingroom") flat = 0;
        if(String(topic) == "home/kitchen") flatKitchen = 0;
        if(String(topic) == "home/bethroom") flatBethroom = 0;
    }
    if (incommingMessage.indexOf("\"Relay\": 0") != -1)
    {
        flatDoor = 0;
    }
    else if (incommingMessage.indexOf("\"Relay\": 1") != -1)
    {
        flatDoor = 1;  //
    }
    else if(incommingMessage == "{\"\Fan\"\:{\"\Status\"\:true,\"\Lever\"\:1}}")
    {
        val = 1;
    }
    else if(incommingMessage == "{\"\Fan\"\:{\"\Status\"\:true,\"\Lever\"\:2}}")
    {
        val = 2;
    }
    else if(incommingMessage == "{\"\Fan\"\:{\"\Status\"\:true,\"\Lever\"\:3}}")
    {
        val = 3;
    }
    else if(incommingMessage == "{\"\Fan\"\:{\"\Status\"\:false}}")
    {
        val = 0;
    }
}

void loop()
{
    WiFiClient webClient = server.available();
    if (webClient)
    {
        handleClientRequest(webClient);
    }
    if (!client.connected())
    {
        reconnect();
    }
    client.loop();
    int h = dht.readHumidity();
    int t = dht.readTemperature();
    if(danhan == 0)
    {
        StaticJsonDocument<200> docTemp,docHum;
        docHum["Huminity"] = h;
        docTemp["Temperature"] = t;
        serializeJson(docTemp,mqtt_message);
        publishMessage("home/livingroom", mqtt_message, false);
        serializeJson(docHum,mqtt_message);
        publishMessage("home/livingroom", mqtt_message, false);
        danhan = 1;
    }

    currentState = digitalRead(4);    //fan home/living
    currentState1 = digitalRead(15); //led home/living
    currentState2 = digitalRead(2); //led  home/bethroom
    currentState3 = digitalRead(14); //led home/kitchen

    if(currentState != flagStateChange)
    {
        lastDebounceTime = millis();
        flagStateChange = currentState;
    }
    else if(currentState1 != flagStateChange1)
    {
        lastDebounceTime1 = millis();
        flagStateChange1 = currentState1;
    }
    else if(currentState2 != flagStateChange2)
    {
        lastDebounceTime2 = millis();
        flagStateChange2 = currentState2;
    }
    else if(currentState3 != flagStateChange3)
    {
        lastDebounceTime3 = millis();
        flagStateChange3 = currentState3;
    }

    if(millis()-timeUpdata > 50)
    {
        //DynamicJsonDocument doc(1024);
        StaticJsonDocument<200> docFan,docKitchen,docBethroom,docGara,docAC,docLight,docDoor;
        JsonObject AC = docAC.createNestedObject("AC");
        JsonObject Fan = docFan.createNestedObject("Fan");
        JsonObject Light = docLight.createNestedObject("Light");
        JsonObject LightKit = docKitchen.createNestedObject("Light");
        if(lastState3 == HIGH && currentState3 == LOW)
        {
            if(flatKitchen == 1) flatKitchen = 0;
            else if(flatKitchen == 0) flatKitchen = 1;
        }
        lastState3 = currentState3;
        if(lastState == HIGH && currentState == LOW)
        {
            val++;
            if(val == 4) val = 0;
        }
        lastState = currentState;
        if(lastState1 == HIGH && currentState1 == LOW)
        {

            if(flat == 1) flat = 0;
            else if(flat == 0) flat = 1;
        }
        lastState1 = currentState1;
        if(lastState2 == HIGH && currentState2 == LOW)
        {
            if(flatBethroom == 1) flatBethroom = 0;
            else if(flatBethroom == 0) flatBethroom = 1;
        }
        lastState2 = currentState2;
        if(sfAC == 1)
        {
            lcd.setCursor(0,0);
            lcd.print("nhiet do : ");
            lcd.setCursor(10, 0);
            lcd.print(temparature);
            lcd.setCursor(0,1);
            if(mode == 1)
            {
                lcd.print("Mode:cool       ");
                AC["Status"] = true;
                AC["Temp"] = temparature;
                AC["Mode"] = 1;
            }
            else if(mode == 2)
            {
                lcd.print("Mode:wet        ");
                AC["Status"] = true;
                AC["Temp"] = temparature;
                AC["Mode"] = 2;
            }
            else if(mode == 3)
            {
                lcd.print("Mode:dry        ");
                AC["Status"] = true;
                AC["Temp"] = temparature;
                AC["Mode"] = 3;
            }
            else if(mode == 4)
            {
                lcd.print("Mode:warm       ");
                AC["Status"] = true;
                AC["Temp"] = temparature;
                AC["Mode"] = 4;
            }
        }
        else if(sfAC == 0)
        {
            lcd.setCursor(0, 0);
            lcd.print("OFF             ");
            lcd.setCursor(0,1);
            lcd.print("                ");
            AC["Status"] = false;

        }
        if(flatKitchen == 1 )
        {
            digitalWrite(LedKitchen, HIGH);
            docKitchen["Light"] = true;
        }
        else if(flatKitchen == 0)
        {
            digitalWrite(LedKitchen,LOW);
            docKitchen["Light"] = false;
        }
        if(flat == 1)
        {
            digitalWrite(LedPin1, HIGH);
            docLight["Light"] = true;
        }
        else if(flat == 0)
        {
            digitalWrite(LedPin1,LOW);
            docLight["Light"] = false;
        }
        if(val == 0)
        {
            analogWrite(LedPinQ, 0);
            Fan["Status"] = false;
        }
        else if(val == 1)
        {
            analogWrite(LedPinQ, 80);
            Fan["Status"] = true;
            Fan["Level"] = 1;
        }
        else if(val == 2)
        {
            analogWrite(LedPinQ, 178);
            Fan["Status"] = true;
            Fan["Level"] = 2;
        }
        else if(val == 3)
        {
            analogWrite(LedPinQ, 255);
            Fan["Status"] = true;
            Fan["Level"] = 3;
        }
        if(flatBethroom == 0)
        {
            digitalWrite(LedBethroom,LOW);
            docBethroom["Light"] = false;
        }
        else if(flatBethroom == 1)
        {
            digitalWrite(LedBethroom,HIGH);
            docBethroom["Light"] = true;
        }
        if(flatDoor == 0)
        {
            servo1.write(0);
            docDoor["Relay"] = false;
        }
        else if(flatDoor == 1)
        {
            servo1.write(90);
            docDoor["Relay"] = true;

        }
        serializeJson(docBethroom,mqtt_message);
        if(flatBethroom == 1)
        {
            if(flag_led1 == 0)
            {
                publishMessage("home/bethroom", mqtt_message, false);
                flag_led1 = 1;
            }

        }
        else if(flatBethroom == 0)
        {
            if(flag_led1 == 1)
            {
                publishMessage("home/bethroom", mqtt_message, false);
                flag_led1 = 0;
            }
        }
        serializeJson(docKitchen,mqtt_message);
        if(flatKitchen == 1)
        {
            if(flag_led2 == 0)
            {
                publishMessage("home/kitchen", mqtt_message, false);
                flag_led2 = 1;
            }

        }
        else if(flatKitchen == 0)
        {
            if(flag_led2 == 1)
            {
                publishMessage("home/kitchen", mqtt_message, false);
                flag_led2 = 0;
            }
        }

        serializeJson(docLight,mqtt_message);
        if(flat == 1)
        {
            if(flag_led == 0)
            {
                publishMessage("home/livingroom", mqtt_message, false);
                flag_led = 1;
            }

        }
        else if(flat == 0)
        {
            if(flag_led == 1)
            {
                publishMessage("home/livingroom", mqtt_message, false);
                flag_led = 0;
            }
        }
        serializeJson(docAC,mqtt_message);
        if(val_ac != mode)
        {
            publishMessage("home/livingroom", mqtt_message, false);
            val_ac = mode;
        }
        serializeJson(docFan,mqtt_message);
        if(val != lastFan)
        {
            publishMessage("home/livingroom", mqtt_message, false);
            lastFan = val;
        }
        if(lastDoor != flatDoor)
        {
            lastDoor = flatDoor;
        }
        timeUpdata=millis();
    }

}
