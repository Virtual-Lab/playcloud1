// Testapp for receiving and sending OSC Messages to a webpage
// You need a running node.js webserver (rhizome.js)
// more information: https://github.com/sebpiq/rhizome

// To receive OSC messages from rhizome
(
thisProcess.openUDPPort(9000);

// thisProcess.addOSCRecvFunc({ |args|
// 	("RECEIVED : ".ccatList(args)).postln;
// });
);

b = NetAddr.new("localhost", 9000);

// Subscribing to receive all messages
//b.sendMsg("/sys/subscribe", 9002, "/");

// Now sending stuff
b.sendMsg("/note", 200,0.5,2);
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, recvPort].postln }, '/note');