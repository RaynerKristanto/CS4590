import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import java.util.List;
ControlP5 p5;

Button context1;
Button context2;
Button context3;
Button context4;

CheckBox events;

Button eventstream1;
Button eventstream2;
Button eventstream3;

Button heartbeat;

Textlabel contextLabel;
Textlabel eventsLabel;
Textlabel eventstreamLabel;
Textlabel heartbeatLabel;

SamplePlayer workingout;
SamplePlayer walking;
SamplePlayer socializing;
SamplePlayer presenting;
SamplePlayer heartbeating;

String eventDataJSON1 = "ExampleData_1.json";
String eventDataJSON2 = "ExampleData_2.json";
String eventDataJSON3 = "ExampleData_3.json";

NotificationServer server;
ArrayList<Notification> notifications;

NotificationHandler handler;

ArrayList<NotificationType> filters;
void setup() {
  ac = new AudioContext();
  // Loading JSON
  server = new NotificationServer();
  handler = new NotificationHandler(ac);
  server.addListener(handler);
  
  // Sound
  
  workingout = getSamplePlayer("workout.wav");
  walking = getSamplePlayer("walking.wav");
  socializing = getSamplePlayer("conversation.wav");
  presenting = getSamplePlayer("presentation.wav");
  heartbeating = getSamplePlayer("heartbeat.wav");
  
  workingout.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  walking.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  socializing.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  presenting.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  heartbeating.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  ac.out.addInput(workingout);
  ac.out.addInput(walking);
  ac.out.addInput(socializing);
  ac.out.addInput(presenting);
  ac.out.addInput(heartbeating);
  
  workingout.pause(true);
  walking.pause(true);
  socializing.pause(true);
  presenting.pause(true);
  heartbeating.pause(true);
  ac.start();
  
  // User Interface
  size(370, 250);
  fill(color(100, 100, 100));
  p5 = new ControlP5(this);
  rect(0, 5, 340, 70);
  contextLabel = p5.addTextlabel("Context")
                   .setText("Context")
                   .setPosition(5, 10);
  context1 = p5.addButton("Working Out")
               .setPosition(10, 35)
               .setLabel("Working Out");
  context2 = p5.addButton("Walking")
               .setPosition(85, 35)
               .setLabel("Walking");
  context3 = p5.addButton("Socializing")
               .setPosition(160, 35)
               .setLabel("Socializing");
  context4 = p5.addButton("Presenting")
               .setPosition(235, 35)
               .setLabel("Presenting");               
  
  rect(0, 85, 90, 130);
  eventsLabel = p5.addTextlabel("EventsLabel")
                  .setText("Events")
                  .setPosition(5, 90);
  
  events = p5.addCheckBox("Events")
             .setPosition(10, 110)
             .setSpacingRow(10);
  events.addItem("Twitter", 0);
  events.addItem("Email", 0);
  events.addItem("Text", 0);
  events.addItem("Phone Call", 0);
  events.addItem("Voice Mail", 0);
  
  rect(100, 85, 240, 70);
  eventstreamLabel = p5.addTextlabel("EventstreamLabel")
                       .setText("Event Stream")
                       .setPosition(105, 90);
  eventstream1 = p5.addButton("eventstream1")
                   .setPosition(110, 115)
                   .setLabel("1");
  eventstream2 = p5.addButton("eventstream2")
                   .setPosition(185, 115)
                   .setLabel("2");
  eventstream3 = p5.addButton("eventstream3")
                   .setPosition(260, 115)
                   .setLabel("3");
  rect(105, 170, 80, 45);
  heartbeat = p5.addButton("heartbeat")
                .setPosition(110, 183)
                .setLabel("Heartbeat");
}

void draw() {
}
NotificationType[] notifTypes = NotificationType.values();
int counter = 0;
void mousePressed() {
  // Heartbeat Button
  if (heartbeat.isPressed()) {
    if (counter % 2 == 0) { 
      heartbeating.pause(false);
    } else {
      heartbeating.pause(true);
    }
    counter++;
  }
  // Events Checkboxes
  List<Toggle> eventList = events.getItems();
  ArrayList<NotificationType> temp = new ArrayList<NotificationType>();
  
  for (int i = 0; i < eventList.size(); i++) {
    if(eventList.get(i).getState()) {
      temp.add(notifTypes[i]);
    }
  }
  filters = temp;
  server.setFilters(filters);
  
  // Eventstream Buttons
  if (eventstream1.isPressed()) {
    server.stopEventStream();
    server.loadEventStream(eventDataJSON1);
  }
  if (eventstream2.isPressed()) {
    server.stopEventStream();
    server.loadEventStream(eventDataJSON2);
  }
  if (eventstream3.isPressed()) {
    server.stopEventStream();
    server.loadEventStream(eventDataJSON3);
  }
  
  // Context Buttons
  if (context1.isPressed() || context2.isPressed() || context3.isPressed() || context4.isPressed()) {
    workingout.pause(true);
    walking.pause(true);
    socializing.pause(true);
    presenting.pause(true);
  }
  if (context1.isPressed()) {
    workingout.pause(false);
    handler.setContext(1);
  }
  if (context2.isPressed()) {
    walking.pause(false);
    handler.setContext(2);
  }
  if (context3.isPressed()) {
    socializing.pause(false);
    handler.setContext(3);
  }
  if (context4.isPressed()) {
    presenting.pause(false);
    handler.setContext(4);
  }
}