(

~ip = ["10.0.0.21", "10.0.0.22", "10.0.0.23", "10.0.0.24"];
//~ip = ["localhost"];
//~ip = ["pi8", "zero2", "zero3", "pi7"];
~clients = ~ip.size;
~number = 0;
~server = Array.newClear(~clients);
~message = Array.newClear(~clients);
~control = Array.newClear(~clients);
~buffers = Array.newClear(~clients);
~keys = Array.newClear(~clients);

~setServer = { arg ip;
	~clients.do{ |i|
		~server[i] = Server("cloud"+i, NetAddr(ip[i], 57110));
		~message[i] = NetAddr(ip[i], 57120);
		~control[i] = NetAddr(ip[i], 9000);
		~server[i].initTree;
	}
};

~setServer.value(~ip);

~pulsen =
// Synth Definition
SynthDef("pulsen", {
	arg
	freq1 = 220
	,interv = 1.5,
	width = 0.5,
	puls1 = 2,
	puls2 = 3,
	mul = 0.1,
	time = 6;

	var pulse = Lag.kr(Pulse.kr([puls1, puls2], width, mul), 0.001);
	var envelope1 = XLine.kr(2, 1, time, doneAction: 2) - 1;
	var sound1 = SinOsc.ar(freq1, 0, pulse) * envelope1;
	var sound2 = SinOsc.ar([freq1, freq1+interv], 0, pulse) * envelope1;

	Out.ar(0, sound2);
}).add;

~klank =
	SynthDef(\klank1, {
		arg ress = 0, vol = 1.0;
		var klank, env;

		klank = Klank.ar(`[{Rand(70,21000)}!7, {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		//klank = klank;
		env = EnvGen.kr(Env.perc(0.07, ress), doneAction:2)*vol;
		Out.ar(0, klank*env.dup*0.0128);
	});


~test1 =
	// Synth Defintion Test
	SynthDef("sine", { arg freq=800;
		var osc, env;
		env = EnvGen.kr(Env.sine(0.5), doneAction: 2);
		osc = SinOsc.ar(freq, 0, 0.1) *env; // 800 Hz sine oscillator

		Out.ar(0, osc); // send output to audio bus zero.
	});

~test2 =
	// Synth Defintion Test
	SynthDef("click", { arg vol=0.5;
		var osc, env;
		env = EnvGen.kr(Env.perc(0.001, 0.5), doneAction: 2);
		osc = WhiteNoise.ar(vol)*env; // 800 Hz sine oscillator

		Out.ar(0, osc); // send output to audio bus zero.
	});


s.waitForBoot {

	~clients.do { |i|
		~klank.send(~server[i]);
		~pulsen.send(~server[i]);
		~test1.send(~server[i]);
		~test2.send(~server[i]);
		//~keys[i] = Array.newClear(128);
	};


	//"simpleCtrl.scd".loadRelative;
	"/Users/rvogtenh/Sites/testsites/www/performances/vilab_play_cloud1/simpleCtrl.scd".loadPaths;
	"simpleCtrl.scd";
	// Platform.userConfigDir;
	// Platform.userHomeDir;

	~test1 = { |i|
		~server[i].sendMsg("/s_new", "sine", x = ~server[i].nextNodeID, 1, 1);
	};

	~test2 = Routine ({
		inf.do {
			~clients.do { |i|
				~server[i].sendMsg("/s_new", "click", x = ~server[i].nextNodeID, 1, 1);
				~server[i].sendMsg("/n_set",x, \vol, 0.2);
				["Test node", i].postln;
				0.5.wait;
			}
		}
	});

	~note = {
		arg msg, time;

		var node;
		var ress = msg[1]+1/400;
		var vol = msg[2];
		var number = msg[3];
		var length = [3, 5, 8.3, 12];
		var xset = 0.5, yset = 0.5, zset= 0.5;
		//var x = (~sliderValue[i*2]+0.1);
		["RECEIVED A NOTE", msg].postln;

		// if (msg[3].notNil,  {xset = (msg[3]+180) / 360});
		// if (msg[4].notNil, {yset = (msg[4] + 180) /360});
		// if (msg[5] != 0, {zset = msg[5]/360});
		// ~number = (~number + 1)%~clients;

		Synth(\klank1, [\ress, 0.1+(7*ress), \vol, vol], ~server[number]);
	};

};

// Ende Setup
// ~setup.value();
);

{

~test1.value(3);

~test2.play;
~test2.stop;
~test2.reset;

~clients.do { |i| {
	inf.do {
		var x = (~sliderValue[i*2]+0.1);
		var vol = ~sliderValue[(i*2)+1];
		x.postln;
		Synth(\klank1, [\ress, 0.1+(7*x), \vol, vol], ~server[i]);
		x.wait;
	}}.fork;
};

~clients.do { |i|
	~server[i].sendMsg("/s_new", "pulsen", x = ~server[i].nextNodeID, 0, 1);
	~server[i].sendMsg("/n_set", x, \freq1,  200.rrand(500), \interv, 20.rand, \width, 0.4.rand+0.5,
		\puls1, 5.rand+0.05, \puls2, 2.rand+0.05, \time, 40.rand);
};


{loop { ~sliderValue[0].postln; 1.wait}}.fork;
/*x = Synth("patternsynth");

x.map(\speed, ~slider[0]);
x.map(\lag, ~slider[1]);*/

// Another Routines

};




