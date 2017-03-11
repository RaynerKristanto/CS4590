import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

SamplePlayer bm;
SamplePlayer v1;
SamplePlayer v2;

Gain bmVolume;
Gain masterVolume;

Bead returnGain1;
Bead returnGain2;
ControlP5 p5;

Button v1Button;
Button v2Button;

Slider masterSlider;
Textlabel masterSliderLabel;

void setup() {
 size(320, 240);
 p5 = new ControlP5(this);
 
 // Beads
 returnGain1 = new Bead() {
   public void messageReceived(Bead mess) {
     this.pause(true);
     bmVolume.setGain(1);
   }
 };
 returnGain2 = new Bead() {
   public void messageReceived(Bead mess) {
     this.pause(true);
     bmVolume.setGain(1);
   }
 };
 
 // Buttons and Slider UI
 v1Button = p5.addButton("v1")
              .setLabel("Voice 1");
 v1Button.setPosition((width - v1Button.getWidth()) / 2 - 40, 50);
 
 v2Button = p5.addButton("v2").setLabel("Voice 2");
 v2Button.setPosition((width - v2Button.getWidth()) / 2 + 40, 50);
 
 masterSlider = p5.addSlider("")
                   .setMax(1.0)
                   .setValue(0.5)
                   ;
 masterSlider.setPosition((width - masterSlider.getWidth()) / 2 , 150);
 masterSliderLabel = p5.addTextlabel("masterSliderLabel")
                       .setText("MASTER SLIDER")
                       .setPosition((width - 75) / 2, 130)
                       ;

 // Sound
 ac = new AudioContext();
 bm = getSamplePlayer("intermission.wav");
 bm.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
 v1 = getSamplePlayer("voice1.wav");

 v1.setEndListener(returnGain1);
 v2 = getSamplePlayer("voice2.wav");
 v2.setEndListener(returnGain2);
  
 bmVolume = new Gain(ac, 1);
 bmVolume.addInput(bm);
 
 masterVolume = new Gain(ac, 3);
 masterVolume.addInput(v1);
 masterVolume.addInput(v2);
 masterVolume.addInput(bmVolume);

ac.out.addInput(masterVolume);
 
 v1.pause(true);
 v2.pause(true);
 ac.start();
}

void draw() {
  background(190, 190, 190);
  masterVolume.setGain(masterSlider.getValue());
}

void mousePressed() {
  if (v1Button.isPressed()) {
    if (v2.getPosition() != 0) {
      v2.setToEnd();
      returnGain2.pause(true);
    }
    returnGain1.pause(false);
        v1.start(0);
    bmVolume.setGain(.3);
  }

  if (v2Button.isPressed()) {
    if (v1.getPosition() != 0) { 
      v1.setToEnd();
      returnGain1.pause(true);
    }
    returnGain2.pause(false);
    v2.start(0);
    bmVolume.setGain(.3);
  }
}