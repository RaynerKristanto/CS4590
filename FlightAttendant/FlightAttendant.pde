import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import java.util.concurrent.TimeUnit;

ControlP5 p5;
Button play;

TextToSpeechMaker ttsMaker;
SamplePlayer ding;
void setup() {
  // Sound
  ac = new AudioContext();
  ttsMaker = new TextToSpeechMaker();
  ding = getSamplePlayer("text.wav");
  ding.pause(true);
  ding.setEndListener(new Bead() {
      public void messageReceived(Bead mess) {
        ding.pause(true);
        ding.setPosition(0);
      }
    });
  ac.out.addInput(ding);
  
  // UI
  size(300, 300);
  p5 = new ControlP5(this);
  play = p5.addButton("play")
           .setPosition(10, 10)
           .setLabel("Play");
 ac.start();
}
void draw() {
}
void mousePressed() {
  if (play.isPressed()) {
    ttsPlayback("14A", ac);
    ding.setRate(new Glide(ac, 1));
    ding.pause(false);
    try {
      TimeUnit.SECONDS.sleep(2);
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
    }
    ttsPlayback("16C", ac);
    ding.setRate(new Glide(ac, .8));
    ding.pause(false);
    try {
      TimeUnit.SECONDS.sleep(2);
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
    }
    ttsPlayback("16A", ac);
    ding.setRate(new Glide(ac, .6));
    ding.pause(false);
  }
}

public void ttsPlayback(String inputSpeech, AudioContext ac) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
  
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  
  SamplePlayer sp = getSamplePlayer(ttsFilePath, true);
  Gain volume = new Gain(ac, 1);
  volume.addInput(sp);
  volume.setGain(3);
  ac.out.addInput(volume);
}