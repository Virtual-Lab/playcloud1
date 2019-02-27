(
//---------------------------------------------------
//          Midicontroller und GUI gekoppelt
//---------------------------------------------------

if(w != nil, {w.close});
w = Window("Controllers", Rect(50, 50, 500, 250)).front;


~slider = Array.fill(8, { Bus.control() });
~sliderGui = Array.fill(8, { Bus.control() });
~sliderValue =  Array.newClear(8);

~knob = Array.fill(8, { Bus.control() });
~knobGui = Array.fill(8, { Bus.control() });
~knobValue =  Array.newClear(8);

8.do{ | i |

	 var backgr = Color.rand;

	 ~knobGui[i] = Knob(w, Rect(((i*60)+15), 30, 40, 40))
		.canFocus_(true)
		.background_(backgr)
		.valueAction_(0.01);

	StaticText(w, Rect(((i*60)+10), 10, 50, 20))
		.font_(Font("helvetica", 11))
		.align_(\center)
		.string_("knob"++i.asString++"");

	~sliderGui[i] = Slider(w, Rect(((i*60)+20), 90, 30, 150))
		.canFocus_(true)
		.background_(backgr)
		.valueAction_(0.01);

	StaticText(w, Rect(((i*60)+10), 70, 50, 20))
		.font_(Font("helvetica", 11))
		.align_(\center)
		.string_("slider"++i.asString++"");

};



//GUI -Abfrage
8.do {|i|


	~sliderGui[i].action_({
	~slider[i].value = ~sliderGui[i].value;
	~sliderValue[i]=~sliderGui[i].value;
	w.front;});
};


~osc = { 
	var oldtime = 0;
	var door = 0;

	thisProcess.openUDPPort(9002);

	b = NetAddr.new("localhost", 9000);

	// Subscribing to receive all messages
	b.sendMsg("/sys/subscribe", 9002, "/note");
	b.sendMsg("/sys/subscribe", 9002, "/freq");
	b.sendMsg("/sys/subscribe", 9002, "/vol");
	b.sendMsg("/sys/subscribe", 9000, "/message");

	//o = OSCFunc({ arg msg, time, addr, recvPort; [msg, recvPort].postln; }, '/note');
	//o = OSCFunc({ arg msg, time, addr, recvPort; msg.postln; }, '/message');
	//
	// Now sending stuff
	b.sendMsg("/message", "Hello, osc is ready!");

	//b.sendMsg("/note", 220, 0.2);

	// -------- SENDING FROM ODROID
	// b = NetAddr.new("192.168.0.26", 9000);

	o = OSCFunc({ arg msg, time, addr, recvPort; ~note.value(msg, time) }, '/note');
	//j = OSCFunc({ arg msg, time, addr, recvPort; ~note.value(msg, time) }, '/button');
};


~osc.value();

// //MIDI - Abfrage
// MIDIIn.connectAll;
//
// MIDIFunc.cc( { |val, num|
//
// 	8.do {|i|
//
// 		if(num == (i+1),
//
// 			{
// 				~slider[i].value = val/127;
// 				~sliderValue[i]= val/127;
//
// 				{
// 					~sliderGui[i].valueAction_(val/127);
// 					w.front;
// 				}.defer;…
//
// 		});
//
// 	};
// });

);