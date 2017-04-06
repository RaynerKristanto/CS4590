// This class does something when a notification is received
// This class plays each notification's respective sound, and spaces the sounds if necessary
import java.util.LinkedList;
import java.util.concurrent.TimeUnit;
class NotificationHandler implements NotificationListener {
  SamplePlayer tweet = getSamplePlayer("tweet.wav");
  SamplePlayer text = getSamplePlayer("text.wav");
  SamplePlayer email = getSamplePlayer("email.wav");
  SamplePlayer ring = getSamplePlayer("ring.wav");
  SamplePlayer voicemail = getSamplePlayer("voicemail.wav");
  TextToSpeechMaker ttsMaker;
  ArrayList<Notification> notifications = new ArrayList<Notification>();
  boolean playing = false;
  Integer context = 0;
  
  LinkedList<SamplePlayer> soundQueue = new LinkedList<SamplePlayer>();
  public NotificationHandler(AudioContext ac) {
    ac.out.addInput(tweet);
    ac.out.addInput(text);
    ac.out.addInput(email);
    ac.out.addInput(ring);
    ac.out.addInput(voicemail);
    tweet.pause(true);
    text.pause(true);
    email.pause(true);
    ring.pause(true);
    voicemail.pause(true);
    ttsMaker = new TextToSpeechMaker();
    //create_ring_wav();
    //ac.start();
  }
  public void setContext(Integer context) {
    this.context = context;
  }
  public void reset() {
    notifications.clear();
  }
  public void notificationReceived(Notification notification) {
    if (playing) {
      try {
            TimeUnit.SECONDS.sleep(1);
          } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
          }
    }
    String debugOutput = "";
    tweet.setPosition(0);
    text.setPosition(0);
    email.setPosition(0);
    ring.setPosition(0);
    voicemail.setPosition(0);
    tweet.pause(true);
    text.pause(true);
    email.pause(true);
    ring.pause(true);
    voicemail.pause(true);
    if (context == 0) {
      println("Please select a context!");
      return;
    }
    if (context == 1) {
      notifications.add(notification);
      switch (notification.getType()) {
        case Tweet:
          tweet.pause(false);
          
          if (notification.getPriorityLevel() > 2) {
            try {
              TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            String tts = "From " + notification.getSender() + ".  ";
            tts = tts + notification.getRetweets() + " retweets. " + notification.getFavorites() + " favorites.";
            ttsPlayback(tts);
          }

          break;
        case Email:
          debugOutput += "New email from ";
          email.setRate(new Glide(ac, notification.getContentSummary() / 2.0));
          email.pause(false);
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
        case VoiceMail:
          debugOutput += "New voicemail from ";
          voicemail.setRate(new Glide(ac, notification.getContentSummary() / 2.0));
          voicemail.pause(false);
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
        case MissedCall:
          ring.pause(false);
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
        case TextMessage:
          debugOutput += "New message from ";
          text.setRate(new Glide(ac, notification.getContentSummary() / 2.0));
          text.pause(false);
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
      }
    } else if (context == 2) {
      notifications.add(notification);
      switch (notification.getType()) {
        case Tweet:
          debugOutput += "New tweet from ";
          tweet.pause(false);
          if (notification.getPriorityLevel() > 3) {
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
          email.setRate(new Glide(ac, notification.getContentSummary() / 2.0));
          email.pause(false);
          if (notification.getPriorityLevel() > 3) {
            try {
              TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            String tts = "From " + notification.getSender();
            ttsPlayback(tts);
          }
          break;
        case VoiceMail:
          debugOutput += "New voicemail from ";
          voicemail.setRate(new Glide(ac, notification.getContentSummary() / 2.0));
          voicemail.pause(false);
          if (notification.getPriorityLevel() > 3) {
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
          ring.pause(false);
          if (notification.getPriorityLevel() > 3) {
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
          text.setRate(new Glide(ac, notification.getContentSummary() / 2.0));
          text.pause(false);
          if (notification.getPriorityLevel() > 3) {
            try {
              TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            String tts = "From " + notification.getSender();
            ttsPlayback(tts);
          }
          break;
      }
    } else if (context == 3) {
      if (notification.getPriorityLevel() > 1) {
        notifications.add(notification);
      }
      switch (notification.getType()) {
        case Tweet:
          debugOutput += "New tweet from ";
          if (notification.getPriorityLevel() > 1) {
            tweet.pause(false);
          }
          if (notification.getPriorityLevel() > 3) {
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
          if (notification.getPriorityLevel() > 1) {
            email.pause(false);
          }
          if (notification.getPriorityLevel() > 3) {
           try {
              TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            String tts = "From " + notification.getSender();
            ttsPlayback(tts);
          } 
          break;
        case VoiceMail:
          debugOutput += "New voicemail from ";
          if (notification.getPriorityLevel() > 1) {
            voicemail.pause(false);
          }
          if (notification.getPriorityLevel() > 3) {
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
          if (notification.getPriorityLevel() > 1) {
            ring.pause(false);
          }
          if (notification.getPriorityLevel() > 3) {
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
          if (notification.getPriorityLevel() > 1) {
            text.pause(false);
          }
          if (notification.getPriorityLevel() > 3) {
            try {
              TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            String tts = "From " + notification.getSender();
            ttsPlayback(tts);
          }
          break;
      }
    } else if (context == 4) {
      if (notification.getPriorityLevel() > 3) {
        notifications.add(notification);
      }
      switch (notification.getType()) {
        case Tweet:
          debugOutput += "New tweet from ";
          if (notification.getPriorityLevel() > 3) {
            tweet.pause(false);
          }
          break;
        case Email:
          debugOutput += "New email from ";
          if (notification.getPriorityLevel() > 3) {
            email.pause(false);
          }
          break;
        case VoiceMail:
          debugOutput += "New voicemail from ";
          if (notification.getPriorityLevel() > 3) {
            voicemail.pause(false);
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
            ring.pause(false);
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
          if (notification.getPriorityLevel() > 3) {
            text.pause(false);
          }
          break;
      }
    } else if (context == 5) {

      if (notifications.contains(notification)) {
        String tts;
        switch (notification.getType()) {
          case Tweet:
            debugOutput += "New tweet from ";
             tweet.pause(false);
              try {
                TimeUnit.SECONDS.sleep(1);
              } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
              }
              tts = "At " + notification.getTimestamp();
              ttsPlayback(tts);
            
            break;
          case Email:
            debugOutput += "New email from ";
              email.pause(false);
              try {
                TimeUnit.SECONDS.sleep(1);
              } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
              }
              tts = "At " + notification.getTimestamp();
              ttsPlayback(tts);
           
            break;
          case VoiceMail:
            debugOutput += "New voicemail from ";
              voicemail.pause(false);
              try {
                TimeUnit.SECONDS.sleep(1);
              } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
              }
              tts = "At " + notification.getTimestamp();
              ttsPlayback(tts);
            break;
          case MissedCall:
            debugOutput += "Missed call from ";
              ring.pause(false);
              try {
                TimeUnit.SECONDS.sleep(1);
              } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
              }
              tts = "At " + notification.getTimestamp();
              ttsPlayback(tts);
            break;
          case TextMessage:
            debugOutput += "New message from ";
            text.pause(false);
            try {
                TimeUnit.SECONDS.sleep(1);
              } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
              }
              tts = "At " + notification.getTimestamp();
              ttsPlayback(tts);
            break;
        } 
      }

    }

    debugOutput += notification.getSender() + ", " + notification.getMessage();
  }
  // This was used to create voicemail.wav
  public void create_voicemail_wav() {
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

    recorder.clip();
    
    try {
      sample.write("sample2.wav", AudioFileType.WAV);
    } catch (Exception e) {
      println("this didn't work");
    }
  }
  // this was used to create ring.wav
  public void create_ring_wav() {
    ac = new AudioContext();
    Sample sample = new Sample(1000);
    RecordToSample recorder = new RecordToSample(ac, sample);
    int time = 100;
    int counter = 0;
    WavePlayer wp = new WavePlayer(ac, 1396.91, Buffer.SINE);
    WavePlayer wp2 = new WavePlayer(ac, 1567.98, Buffer.SINE);
    ac.out.addInput(wp);
    ac.out.addInput(wp2);
    
    recorder.addInput(ac.out);
    ac.out.addDependent(recorder);
  
    wp2.pause(true);
    ac.start();
    while (counter < 5) {
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
  
    recorder.clip();
    try {
      sample.write("ring.wav", AudioFileType.WAV);
    } catch (Exception e) {
      println("this didn't work");
    }
    
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
        if (soundQueue.size() > 0) {
          SamplePlayer sp2 = soundQueue.remove();
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
      soundQueue.add(sp);
    }
  }
}