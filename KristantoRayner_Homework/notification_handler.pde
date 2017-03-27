// This class does something when a notification is received
// This class plays each notification's respective sound, and spaces the sounds if necessary
import java.util.LinkedList;
import java.util.concurrent.TimeUnit;
class NotificationHandler implements NotificationListener {
  SamplePlayer tweet = getSamplePlayer("tweet.wav");
  TextToSpeechMaker ttsMaker;
  boolean playing = false;
  Integer context = 0;
  
  LinkedList<SamplePlayer> ttsQueue = new LinkedList<SamplePlayer>();
  public NotificationHandler(AudioContext ac) {
    ac.out.addInput(tweet);
    tweet.pause(true);
    ttsMaker = new TextToSpeechMaker();
  }
  public void setContext(Integer context) {
    this.context = context;
  }
  public void notificationReceived(Notification notification) {
    String debugOutput = "";
    tweet.setPosition(0);
    if (context == 0) {
      println("Please select a context!");
      return;
    }
    if (context == 1) {
      switch (notification.getType()) {
        case Tweet:
          tweet.pause(false);
          try {
            TimeUnit.SECONDS.sleep(1);
          } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
          }
          String tts = "From " + notification.getSender() + notification.getMessage() + ".  ";
          tts = tts + notification.getRetweets() + " retweets. " + notification.getFavorites() + " favorites.";
          ttsPlayback(tts);
          println(tts);
        case Email:
        case VoiceMail:
        case MissedCall:
          ring();
        case TextMessage:
      }
    } else if (context == 2) {
      switch (notification.getType()) {
        case Tweet:
          debugOutput += "New tweet from ";
          tweet.pause(false);
          break;
        case Email:
          debugOutput += "New email from ";
          ttsPlayback(notification.getMessage());
          break;
        case VoiceMail:
          debugOutput += "New voicemail from ";
          break;
        case MissedCall:
          debugOutput += "Missed call from ";
          break;
        case TextMessage:
          debugOutput += "New message from ";
          break;
      }
    } else if (context == 3) {
      switch (notification.getType()) {
        case Tweet:
          debugOutput += "New tweet from ";
          tweet.pause(false);
          if (notification.getPriorityLevel() > 2) {
            try {
              TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            String tts = "From " + notification.getSender();
            ttsPlayback(tts);
          }
          break;
        case Email:
          debugOutput += "New email from ";
          ttsPlayback(notification.getMessage());
          break;
        case VoiceMail:
          debugOutput += "New voicemail from ";
          break;
        case MissedCall:
          debugOutput += "Missed call from ";
          break;
        case TextMessage:
          debugOutput += "New message from ";
          break;
      }
    } else if (context == 4) {
      switch (notification.getType()) {
        case Tweet:
          debugOutput += "New tweet from ";
          if (notification.getPriorityLevel() > 3) {
            tweet.pause(false);
          }
          break;
        case Email:
          debugOutput += "New email from ";
         
          break;
        case VoiceMail:
          debugOutput += "New voicemail from ";
          if (notification.getPriorityLevel() > 3) {
            voicemail();
            try {
              TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            String tts = "From " + notification.getSender();
            ttsPlayback(tts);
          }
          break;
        case MissedCall:
          debugOutput += "Missed call from ";
          if (notification.getPriorityLevel() > 3) {
            ring();
            try {
              TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            String tts = "From " + notification.getSender();
            ttsPlayback(tts);
          }
          break;
        case TextMessage:
          debugOutput += "New message from ";
          break;
      }
    }
    debugOutput += notification.getSender() + ", " + notification.getMessage();
    
    println(debugOutput);
    }
  public void voicemail() {
    int time = 100;
    WavePlayer wp = new WavePlayer(ac, 1396.91, Buffer.SINE);
    ac.out.addInput(wp);
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
    }

  public void ring() {
    int time = 100;
    int counter = 0;
    WavePlayer wp = new WavePlayer(ac, 1396.91, Buffer.SINE);
    WavePlayer wp2 = new WavePlayer(ac, 1567.98, Buffer.SINE);
    ac.out.addInput(wp);
    ac.out.addInput(wp2);
    wp2.pause(true);
    while (counter < 10) {
      wp.pause(true);
      wp2.pause(false);
      try {
        TimeUnit.MILLISECONDS.sleep(time);
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }
      wp.pause(false);
      wp2.pause(true);
      try {
        TimeUnit.MILLISECONDS.sleep(time);
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }
      counter++;
    }
    wp.pause(true);
    wp2.pause(true);
  }
  
  public void ttsPlayback(String inputSpeech) {
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
    sp.setKillListener(new Bead() {
      public void messageReceived(Bead mess) {
        if (ttsQueue.size() > 0) {
          SamplePlayer sp2 = ttsQueue.remove();
          sp2.pause(false);
        } else {  
          playing = false;
        }
      }
    });
    volume.setGain(3);
    ac.out.addInput(volume);
    sp.pause(true);
    if (!playing) {
      sp.pause(false);
      playing = true;
    } else {
      ttsQueue.add(sp);
    }
  }
}