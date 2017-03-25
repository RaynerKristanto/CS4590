// This class does something when a notification is received
// This class plays each notification's respective sound, and spaces the sounds if necessary

class NotificationHandler implements NotificationListener {
  SamplePlayer tweet = getSamplePlayer("tweet.wav");
  
  public NotificationHandler(AudioContext ac) {
    ac.out.addInput(tweet);
    tweet.pause(true);
  }
  
  public void notificationReceived(Notification notification) {
    String debugOutput = "";
    tweet.setPosition(0);
    switch (notification.getType()) {
      case Tweet:
        debugOutput += "New tweet from ";
        tweet.pause(false);
        break;
      case Email:
        debugOutput += "New email from ";
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
    debugOutput += notification.getSender() + ", " + notification.getMessage();
    
    println(debugOutput);
      
  }
}