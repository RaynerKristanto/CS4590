import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;

Button play;
Button s;
Button fastForward;
Button rewind;
Button reset;

SamplePlayer music;
SamplePlayer click;
void setup() {
    size(320, 240);
    p5 = new ControlP5(this);
    play = p5.addButton("play")
      .setLabel("Play");
    s = p5.addButton("s")
      .setLabel("Stop");
    fastForward = p5.addButton("fastForward")
      .setLabel("FF")
      .setPosition(10, 70);
    rewind = p5.addButton("rewind")
      .setLabel("Rewind")
      .setPosition(90, 70);
    reset = p5.addButton("reset")
      .setLabel("Reset")
      .setPosition(50, 110);
    
    // Sound
    ac = new AudioContext();
    music = getSamplePlayer("music.wav");
    music.setEndListener(new Bead() {
      public void messageReceived(Bead mess) {
        music.pause(true);
        music.setPosition(music.getPosition() - .1);
      }
    });
    click = getSamplePlayer("button.wav");
    click.setEndListener(new Bead() {
      public void messageReceived(Bead mess) {
        click.pause(true);
        click.setPosition(0);
        click.setRate(new Glide(ac, random(0.5, 2.0)));
      }
    });

    ac.out.addInput(music);
    ac.out.addInput(click);
    music.pause(true);
    click.pause(true);
    ac.start();
}
   
void draw() {
    background(250, 250, 250);
    if (music.getPosition() < 0) {
      music.pause(true);
      music.setPosition(0);
    }
}

void mousePressed() {
  if (play.isPressed()) {
    music.pause(false);
    click.pause(false);
    music.setRate(new Glide(ac, 1.0));
  }
  if (s.isPressed()) {
    music.pause(true);
    click.pause(false);
  }
  if (rewind.isPressed()) {
    music.pause(false);
    click.pause(false);
    music.setRate(new Glide(ac, -1.5));
  }
  if (fastForward.isPressed()) {
    music.pause(false);
    click.pause(false);
    music.setRate(new Glide(ac, 1.5));
  }
  if (reset.isPressed()) {
    music.pause(true);
    click.pause(false);
    music.setPosition(0);
  }
}