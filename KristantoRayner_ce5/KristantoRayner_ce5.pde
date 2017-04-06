import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import java.util.concurrent.TimeUnit;
ControlP5 p5;

void setup() {
  ac = new AudioContext();
  Sample sample = new Sample(1000);
  RecordToSample recorder = new RecordToSample(ac, sample);
      int time = 100;
    WavePlayer wp = new WavePlayer(ac, 1396.91, Buffer.SINE);
    ac.out.addInput(wp);
    
    recorder.addInput(ac.out);
    ac.out.addDependent(recorder);
    ac.start();
    try {
      TimeUnit.MILLISECONDS.sleep(time);
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
    }
    wp.pause(true);
      try {
      TimeUnit.MILLISECONDS.sleep(time);
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
    }
    wp.pause(false);
      try {
      TimeUnit.MILLISECONDS.sleep(time);
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
    }
    wp.pause(true);

  println(recorder.getNumFramesRecorded());
  recorder.clip();
  
  try {
    sample.write("sample2.wav", AudioFileType.WAV);
  } catch (Exception e) {
    println("this didn't work");
  }
}

////Button play;
//Button s;
//Button fastForward;
//Button rewind;
//Button reset;

//SamplePlayer music;
//SamplePlayer click;
//void setup() {
//    size(320, 240);
//    p5 = new ControlP5(this);
//    play = p5.addButton("play")
//      .setLabel("Play");
//    s = p5.addButton("s")
//      .setLabel("Stop");
//    fastForward = p5.addButton("fastForward")
//      .setLabel("FF")
//      .setPosition(10, 70);
//    rewind = p5.addButton("rewind")
//      .setLabel("Rewind")
//      .setPosition(90, 70);
//    reset = p5.addButton("reset")
//      .setLabel("Reset")
//      .setPosition(50, 110);
    
//    // Sound
//    ac = new AudioContext();
//    music = getSamplePlayer("music.wav");
//    music.setEndListener(new Bead() {
//      public void messageReceived(Bead mess) {
//        music.pause(true);
//        music.setPosition(music.getPosition() - .1);
//      }
//    });
//    click = getSamplePlayer("button.wav");
//    click.setEndListener(new Bead() {
//      public void messageReceived(Bead mess) {
//        click.pause(true);
//        click.setPosition(0);
//        click.setRate(new Glide(ac, random(0.5, 2.0)));
//      }
//    });

//    ac.out.addInput(music);
//    ac.out.addInput(click);
//    music.pause(true);
//    click.pause(true);
//    ac.start();
//}
   
//void draw() {
//    background(250, 250, 250);
//    if (music.getPosition() < 0) {
//      music.pause(true);
//      music.setPosition(0);
//    }
//}

//void mousePressed() {
//  if (play.isPressed()) {
//    music.pause(false);
//    click.pause(false);
//    music.setRate(new Glide(ac, 1.0));
//  }
//  if (s.isPressed()) {
//    music.pause(true);
//    click.pause(false);
//  }
//  if (rewind.isPressed()) {
//    music.pause(false);
//    click.pause(false);
//    music.setRate(new Glide(ac, -1.5));
//  }
//  if (fastForward.isPressed()) {
//    music.pause(false);
//    click.pause(false);
//    music.setRate(new Glide(ac, 1.5));
//  }
//  if (reset.isPressed()) {
//    music.pause(true);
//    click.pause(false);
//    music.setPosition(0);
//  }
//}