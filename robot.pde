#include <IRremote.h>
#include <IRremoteInt.h>

// The Tech Challenge Project 2017 (Mahir, Akhil, Vijay, Eshaan, Sohil)

#include <AFMotor.h>
#include <Servo.h>

//IR Remote
int RECV_PIN = 47;
int RECV_PIN2 = 22;

IRrecv irrecv(RECV_PIN);
decode_results results;

IRrecv irrecv2(RECV_PIN2);
decode_results results2;

//Motor Assignment
AF_DCMotor rear_left_motor(4);
AF_DCMotor rear_right_motor(1);
AF_DCMotor front_left_motor(3);
AF_DCMotor front_right_motor(2);

//Servo Definition
Servo servo1;
Servo servo2;

void setup() {
  Serial.begin(9600);
  
  irrecv.enableIRIn(); //Start the receiver
  pinMode(45,OUTPUT);
  pinMode(43,OUTPUT);
  digitalWrite(45,LOW);
  digitalWrite(43,HIGH);

  irrecv2.enableIRIn(); //Start the receiver
  pinMode(24,OUTPUT);
  pinMode(26,OUTPUT);
  digitalWrite(24,LOW);
  digitalWrite(26,HIGH);
  
  // turn on servo
  servo1.attach(9);
  servo2.attach(10);
  //it Servo Positions
  servo2.write(120);
  servo1.write(120);
  pinMode(30,OUTPUT);
  pinMode(32,OUTPUT);
  digitalWrite(30,HIGH);
  digitalWrite(32,HIGH);

  digitalWrite(32,LOW);  //debug
}


int i,nstep,idle=9999;
int dcSpeed = 200;
int dcSpeedSpin = 180;
int dcSpeedSpinLong = 180;
int servoPosH = 0;
int servoPosV = 120;  //110;
int mstep =55;
float t1 = millis();


void loop() {

  //Serial.println(irrecv.decode(&results));
  if (irrecv.decode(&results)) {
   Serial.println("read new value 1");
   Serial.println(results.value, HEX);
   Serial.println("wrote new value 1");
    if(translateIR()!=0){
      nstep=translateIR();
      //nstep = 7677; //debug    
      t1 = millis();
    }
   //Serial.println(nstep);   
    irrecv.resume();//Receive the next value
  }

  if (irrecv2.decode(&results2)) {
   Serial.println("read new value 2");
   Serial.println(results2.value, HEX);
   Serial.println("wrote new value 2");
    if(translateIR2()!=0){
      nstep=translateIR2();
      //nstep = 7677; //debug    
      t1 = millis();
    }
   //Serial.println(nstep);   
   
    irrecv2.resume();//Receive the next value
  }


 // nstep = 1;  //debug

    switch (nstep) {

      case 1:
        //Move Rover Forward
        rear_left_motor.setSpeed(dcSpeed);
        rear_left_motor.run(FORWARD);
        rear_right_motor.setSpeed(dcSpeed);
        rear_right_motor.run(FORWARD);
        front_left_motor.setSpeed(dcSpeed);
        front_left_motor.run(FORWARD);
        front_right_motor.setSpeed(dcSpeed);
        front_right_motor.run(FORWARD);
        if(millis()-t1 > 3600)nstep =2;
      break;
      case 200:
        //Move Rover Forward
        rear_left_motor.setSpeed(dcSpeed);
        rear_left_motor.run(FORWARD);
        rear_right_motor.setSpeed(dcSpeed);
        rear_right_motor.run(FORWARD);
        front_left_motor.setSpeed(dcSpeed);
        front_left_motor.run(FORWARD);
        front_right_motor.setSpeed(dcSpeed);
        front_right_motor.run(FORWARD);
        if(millis()-t1 > 100)nstep =2;
      break;
      case 2:
        rear_left_motor.setSpeed(0);
        //rear_left_motor.run(RELEASE);
        rear_right_motor.setSpeed(0);
        //rear_right_motor.run(RELEASE);
        front_left_motor.setSpeed(0);
        //front_left_motor.run(RELEASE);
        front_right_motor.setSpeed(0);
        //front_right_motor.run(RELEASE);
        //delay(1000);
        nstep = idle;
      break;
      case 203:
      //Turn 180 deg CCW
        rear_left_motor.setSpeed(dcSpeedSpin);
        rear_left_motor.run(BACKWARD);
        rear_right_motor.setSpeed(dcSpeedSpin);
        rear_right_motor.run(FORWARD);
        front_left_motor.setSpeed(dcSpeedSpin);
        front_left_motor.run(BACKWARD);
        front_right_motor.setSpeed(dcSpeedSpin);
        front_right_motor.run(FORWARD);
        if(millis()-t1 > 100)nstep =2;
      break;
      case 201:
       //Move Rover Backward
        rear_left_motor.setSpeed(dcSpeed);
        rear_left_motor.run(BACKWARD);
        rear_right_motor.setSpeed(dcSpeed);
        rear_right_motor.run(BACKWARD);
        front_left_motor.setSpeed(dcSpeed);
        front_left_motor.run(BACKWARD);
        front_right_motor.setSpeed(dcSpeed);
        front_right_motor.run(BACKWARD);
        if(millis()-t1 > 100)nstep =2;
      break;

       case 4:
       //Lower Arm
        for (i = servoPosV; i > servoPosH; i--) {
          servo1.write(i);
          delay(30);
        }
        
        nstep =idle;
      break;
      case 202:

      //Turn 180 deg CW
        rear_left_motor.setSpeed(dcSpeedSpin);
        rear_left_motor.run(FORWARD);
        rear_right_motor.setSpeed(dcSpeedSpin);
        rear_right_motor.run(BACKWARD);
        front_left_motor.setSpeed(dcSpeedSpin);
        front_left_motor.run(FORWARD);
        front_right_motor.setSpeed(dcSpeedSpin);
        front_right_motor.run(BACKWARD);
        if(millis()-t1 > 100)nstep =2;
      break;

      case 3:
      //Turn 180 deg CCW
        rear_left_motor.setSpeed(dcSpeedSpinLong);
        rear_left_motor.run(BACKWARD);
        rear_right_motor.setSpeed(dcSpeedSpinLong);
        rear_right_motor.run(FORWARD);
        front_left_motor.setSpeed(dcSpeedSpinLong);
        front_left_motor.run(BACKWARD);
        front_right_motor.setSpeed(dcSpeedSpinLong);
        front_right_motor.run(FORWARD);
        if(millis()-t1 > 900)nstep =2;
      break;

      case 5:
        //Lift Arm
        for (i = servoPosH; i < 25; i++) {
         servo1.write(i);
          delay(200);
        }

        for (i = 25; i < servoPosV; i++) {
         servo1.write(i);
          delay(50);
        }
        nstep =idle;
      break;
      case 6:
        //activate magnet
        digitalWrite(32,HIGH);
        nstep =idle;
      break;
      
      case 7:
        //deactivate magnet
        digitalWrite(32,LOW);
        nstep =idle;
      break;                
      default:
      break;
    }

}       //Loop Close


int translateIRNew() // takes action based on IR code received

// describing Car MP3 IR codes 

{
  
  if(results.value==0xB47      )return 1;
  if(results.value==0x80B47    )return 2;
  if(results.value==0xFFFFFFFF )return 0;
  
} //END translateIRNew

int translateIRNew2() // takes action based on IR code received

// describing Car MP3 IR codes 

{
  
  if(results2.value==0xB47)return 1;
  if(results2.value==0x80B47)return 2;
  if(results2.value==0xFFFFFFFF)return 0;
  
} //END translateIRNew



int translateIR() // takes action based on IR code received

// describing Car MP3 IR codes 

{
  switch(results.value)

  {
  case 0xB47:
  case 0x2D: 
  case 0xAFA9CA08: 
    //Serial.println(" 1              "); 
    return 1;
    break;

  case 0x80B47:
  case 0x5FFE7C91:
  case 0x8F290601:
  case 0x319F88509:
  case 0xAC8855AA:
  case 0x4AB0F7B5:
  case 0xEA083247:
  case 0xD9D350FC:
  case 0x27E0C510:
  case 0xE9E70E8C:
  case 0x86B1F7CE:
  case 0x122E27A8:
    //Serial.println(" 2              "); 
    return 2;
    break;
 
  case 0x40B47:
  case 0xCBB6AE06:
  case 0xAF5EF9C6:
  case 0xC0CE699F: 
  case 0x3039494E:
  case 0xA50B178C:
  case 0x565660EF:
  case 0x4CB0FADC:
    //Serial.println(" 3              "); 
    return 3;
    break;

  case 0xC0B47:
  case 0xD9F31175:
  case 0xE025D441:
  case 0x65B84EC5: 
    //Serial.println(" 4              "); 
    return 4;
    break;

  case 0x20B47:
  case 0x33E9DCB2:
  case 0xE2FD846C:
  case 0xD4173F13:
    //Serial.println(" 5              "); 
    return 5;
    break;
  
  case 0xA0B47:
  case 0x3B3D61C3:
  case 0x67C88F22:
  case 0x5E90424B: 
  case 0x3A3D602F:
    //Serial.println(" 6              "); 
    return 6;
    break;


  case 0x60B47:
  case 0xA03744C2:
  case 0x1B87C95D:
    //Serial.println(" 7              "); 
    return 7;
    break;

  case 0x9CB47:
  case 0x272D1:
  case 0x884EBF5F:
    //Serial.println(" Forward              "); 
    return 200;
    break;

  case 0x5CB47:
  case 0xA3666B38:
  case 0x1641AE03:
  case 0xD37A8151:
    //Serial.println(" Backward              "); 
    return 201;
    break;

  case 0x3CB47:
  case 0x53A904A6:
  case 0x1E5:
  case 0x33DA034:
  case 0x2DC5945B:
    //Serial.println(" Right              "); 
    return 202;
    break;

  case 0xDCB47:
  case 0x2433443:
  case 0x372D:
  case 0xBB4EEAC:
  case 0x77DEF9F52:
  case 0x581D268F:
    //Serial.println(" Left              "); 
    return 203;
    break;

  
  case 0xFFFFFFFF:  
    //Serial.println(" 0              "); 
    return 0;
    break;
    
  default: 
    //Serial.println(" other button   ");
    return 166;
    break;
  }

} //END translateIR






int translateIR2() // takes action based on IR code received

// describing Car MP3 IR codes 

{
  switch(results2.value)

  {
  case 0xB47:
  case 0x2D: 
  case 0xAFA9CA08: 
    //Serial.println(" 1              "); 
    return 1;
    break;

  case 0x80B47:
  case 0x5FFE7C91:
  case 0x8F290601:
  case 0x319F88509:
  case 0xAC8855AA:
  case 0x4AB0F7B5:
  case 0xEA083247:
  case 0xD9D350FC:
  case 0x27E0C510:
  case 0xE9E70E8C:
  case 0x86B1F7CE:
  case 0x122E27A8:
    //Serial.println(" 2              "); 
    return 2;
    break;
 
  case 0x40B47:
  case 0xCBB6AE06:
  case 0xAF5EF9C6:
  case 0xC0CE699F: 
  case 0x3039494E:
  case 0xA50B178C:
  case 0x565660EF:
  case 0x4CB0FADC:
    //Serial.println(" 3              "); 
    return 3;
    break;

  case 0xC0B47:
  case 0xD9F31175:
  case 0xE025D441:
  case 0x65B84EC5: 
    //Serial.println(" 4              "); 
    return 4;
    break;

  case 0x20B47:
  case 0x33E9DCB2:
  case 0xE2FD846C:
  case 0xD4173F13:
    //Serial.println(" 5              "); 
    return 5;
    break;
  
  case 0xA0B47:
  case 0x3B3D61C3:
  case 0x67C88F22:
  case 0x5E90424B: 
  case 0x3A3D602F:
    //Serial.println(" 6              "); 
    return 6;
    break;


  case 0x60B47:
  case 0xA03744C2:
  case 0x1B87C95D:
    //Serial.println(" 7              "); 
    return 7;
    break;

  case 0x9CB47:
  case 0x272D1:
  case 0x884EBF5F:
    //Serial.println(" Forward              "); 
    return 200;
    break;

  case 0x5CB47:
  case 0xA3666B38:
  case 0x1641AE03:
  case 0xD37A8151:
    //Serial.println(" Backward              "); 
    return 201;
    break;

  case 0x3CB47:
  case 0x53A904A6:
  case 0x1E5:
  case 0x33DA034:
  case 0x2DC5945B:
    //Serial.println(" Right              "); 
    return 202;
    break;

  case 0xDCB47:
  case 0x2433443:
  case 0x372D:
  case 0xBB4EEAC:
  case 0x77DEF9F52:
  case 0x581D268F:
    //Serial.println(" Left              "); 
    return 203;
    break;

  
  case 0xFFFFFFFF:  
    //Serial.println(" 0              "); 
    return 0;
    break;
    
  default: 
    //Serial.println(" other button   ");
    return 166;
    break;
  }

} //END translateIR


/* ( THE END ) */

