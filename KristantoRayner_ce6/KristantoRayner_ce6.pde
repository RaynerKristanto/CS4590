import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;

Textlabel ambientLabel;
Textlabel alertLabel;

Button ambient1Button;
Button ambient2Button;
Button ambient3Button;

Button alert1Button;
Button alert2Button;
Button alert3Button;

SamplePlayer ambient1;
SamplePlayer ambient2;
SamplePlayer ambient3;
SamplePlayer alert1;
SamplePlayer alert2;
SamplePlayer alert3;

Gain ambientVolume;
Gain alert1Volume;
Gain alert2Volume;

Slider ambientVolumeSlider;
Bead returnGain;
void setup() {
  size(320, 240);
  p5 = new ControlP5(this);
  
  // Beads
  returnGain = new Bead() {
    public void messageReceived(Bead mess) {
      ambientVolume.setGain(1);
    }
  };
  
  // Button/Slider/Label UI
  ambientVolumeSlider = p5.addSlider("Ambient Volume")
                          .setMax(1.0)
                          .setValue(0.3)
                          .setPosition(10, 160);
  ambientLabel = p5.addTextlabel("Ambient")
                   .setText("Ambient")
                   .setPosition(10, 10);
  ambient1Button = p5.addButton("ambient1")
               .setLabel("Low")
               .setPosition(10, 30);
  
  ambient2Button = p5.addButton("ambient2")
               .setLabel("Medium")
               .setPosition(100, 30);
               
  ambient3Button = p5.addButton("ambient3")
               .setLabel("High")
               .setPosition(190, 30);
  
  alertLabel = p5.addTextlabel("Alert")
                 .setText("Alert")
                 .setPosition(10, 70);
                 
  alert1Button = p5.addButton("alert1")
               .setLabel("Low")
               .setPosition(10, 90);
  
  alert2Button = p5.addButton("alert2")
               .setLabel("Medium")
               .setPosition(100, 90);
               
  alert3Button = p5.addButton("alert3")
               .setLabel("High")
               .setPosition(190, 90);
  // Sound
  ac = new AudioContext();
  ambient1 = getSamplePlayer("ambientLowFinal.wav");
  ambient1.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  ambient2 = getSamplePlayer("ambientFinal.wav");
  ambient2.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  ambient3 = getSamplePlayer("ambientHighFinal.wav");
  ambient3.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  alert1 = getSamplePlayer("alertLowFinal.wav");
  alert2 = getSamplePlayer("alertFinal.wav");
  alert3 = getSamplePlayer("alertHighFinal.wav");
  
  alert1.setEndListener(returnGain);
  alert2.setEndListener(returnGain);
  alert3.setEndListener(returnGain);
  
  ambient2.pause(true);
  ambient3.pause(true);
  alert1.pause(true);
  alert2.pause(true);
  alert3.pause(true);
  
  ambientVolume = new Gain(ac, 3);
  ambientVolume.addInput(ambient1);
  ambientVolume.addInput(ambient2);
  ambientVolume.addInput(ambient3);
  
  alert1Volume = new Gain(ac, 1);
  alert1Volume.addInput(alert1);
  alert1Volume.setGain(.3);
  
  alert2Volume = new Gain(ac, 1);
  alert2Volume.addInput(alert2);
  alert2Volume.setGain(.75);
  
  ac.out.addInput(ambientVolume);
  ac.out.addInput(alert1Volume);
  ac.out.addInput(alert2Volume);
  ac.out.addInput(alert3);
  ac.start();
}

void draw() {
  background(190, 190, 190);
  ambientVolume.setGain(ambientVolumeSlider.getValue());
}

void mousePressed() {
  if (ambient1Button.isPressed()) {
    ambient1.pause(false);
    ambient2.pause(true);
    ambient3.pause(true);
  }
  if (ambient2Button.isPressed()) {
    ambient1.pause(true);
    ambient2.pause(false);
    ambient3.pause(true);
  }
  if (ambient3Button.isPressed()) {
    ambient1.pause(true);
    ambient2.pause(true);
    ambient3.pause(false);
  }
  if (alert1Button.isPressed()) {
    ambientVolume.setGain(.3);
    alert1.start(0);
    alert1.pause(false);
    alert2.pause(true);
    alert3.pause(true);
  }
  if (alert2Button.isPressed()) {
    ambientVolume.setGain(.3);
    alert2.start(0);
    alert1.pause(true);
    alert2.pause(false);
    alert3.pause(true);
  }
  if (alert3Button.isPressed()) {
    ambientVolume.setGain(.3);
    alert3.start(0);
    alert1.pause(true);
    alert2.pause(true);
    alert3.pause(false);
  }
}