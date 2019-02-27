# playcloud1

This is a framework and template for play and interact with cloudspeakers (cloudspeaker.zhdk.ch) over a webapplication
The webpplaication (in the folder pages) is controlling sounds from supercollider

Instructions
--------------

- load the supercollider patch (cloud1.scd) in the supercolider IDE
- start the rhizome server (it needs nodejs Version 6, see intructions below)





How to start the rhizome application:

1. install node.js and npm (It needs node Version 6) 
it is the best opportunity to install it with nvm: https://github.com/creationix/nvm
- install nvm with terminal
<code>curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash</code>
or Wget:

<code>wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash</code>

then install node 6 and use it:
<code>nvm install 6<br/>
	nvm use 6</code>
	
You can also download an installer directly from Node.js website.

2) Install rhizome

Open a terminal, and simply run npm install -g rhizome-server. If this succeeded, you can try to run rhizome. This should print rhizome help message.

4) Start the server

There is a configuration file called config.js. You can now start the server by running rhizome myConfig.js in your terminal.

There is also a template for controlling messages in Supercollider with a Gui and/or Midi:
simpleCtrl.scd
	

In the Test-Folder there are template files for SuperCollider and Pure Data
It shows simple message sending / receiving with different clients for **rhizome** :

- a static webpage (communication over websockets)
- SuperCollider (communication over OSC)
- Pure Data (communication over OSC)



Then, open either of the clients and try sending messages. Other clients that have subscribed to the right address should receive these messages.

To open the web page (websocket client), just go to [http://localhost:8000/index.html](http://localhost:8000/index.html).

All the code for the web page is in [pages/index.html](https://github.com/sebpiq/rhizome/blob/master/examples/base/pages/index.html) once you got the example working, you can just modify the html/javascript there to fit your needs.
