var Control = {
oscMessage : true,
volume : [0.1, 0.2, 0.1, 0.4], 
freq : [200, 250, 150, 300],
ress : [200, 50, 100, 300],
number : 0
};

Control.client = new rhizome.Client();

Control.client.start(
  function(err) {
      if (err) {
        $('body').html('client failed starting : ' + err)
        throw err
       }
    // subscribe to the rhizome server
    // receive messages with the adress of '/message'
    Control.client.send('/sys/subscribe', ['/message'])
});

Control.client.on('connected', function() {
       alert('connected!')
     });

Control.client.on('connection lost', function() {
 alert('connection lost!')
});

Control.client.on('server full', function() {
 alert('server is full!')
});

  // Webaudio-Code comes here 

Control.orientation = function (eventData) {

  // gamma is the left-to-right tilt in degrees, where right is positive
  var tiltLR = eventData.gamma;

  // beta is the front-to-back tilt in degrees, where front is positive
  var tiltFB = eventData.beta;

  // alpha is the compass direction the device is facing in degrees
  var dir = eventData.alpha;

  console.log(tiltLR, tiltFB, dir);
  var elLR = document.getElementById("setx").innerHTML = Math.round(tiltLR);
  var elFB = document.getElementById("sety").innerHTML = Math.round(tiltFB);
  var elDir = document.getElementById("setz").innerHTML = Math.round(dir);
  this.xset = Math.round(tiltLR);
  this.yset = Math.round(tiltFB);
  this.zset = Math.round(dir);

};

nx.onload = function() {

    nx.colorize("#0af");
    nx.sendsTo("js");
  
  button1.on('press', function(data) {
      if (data == 1) {
        Control.send(0);
      }
  });

  button2.on('press', function(data) {
  if (data == 1) {
        Control.send(1);
      }
  });

  button3.on('press', function(data) {
  if (data == 1) {
        Control.send(2);
      }
  });

  button4.on('press', function(data) {
  if (data == 1) {
        Control.send(3);
      }
  });

  slider1.sendsTo(function(data) {
    Control.volume[0] = data.value;
  });

  slider2.sendsTo(function(data) {
    console.log(data);
    Control.volume[1] = data.value;
  });

  slider3.sendsTo(function(data) {
    Control.volume[2] = data.value;
  });

  slider4.sendsTo(function(data) {
    console.log(data);
    Control.volume[3] = data.value;
  });

  dial1.sendsTo(function(data) {
    Control.ress[0] = data.value*400;
  });

  dial2.sendsTo(function(data) {
    console.log(data);
    Control.ress[1] = data.value*400;
  });

  dial3.sendsTo(function(data) {
    Control.ress[2] = data.value*400;
  });

  dial4.sendsTo(function(data) {
    console.log(data);
    Control.ress[3] = data.value*400;
  });

    //nx.sendsTo("ajax");
    //nx.setAjaxPath("lib/nexusOSCRelay.php");

  Control.send = function (data) {
    if (Control.oscMessage) {
      Control.number = Control.number + 1;
      Control.client.send('/note', [Control.ress[data], Control.volume[data], data, Control.number]);
    }};



}


// var client
//    $(function() {
//      client = new rhizome.Client()

//      // `rhizome.start` is the first function that should be called.
//      // The function inside is executed once the client managed to connect.
//      client.start(function(err) {
//        if (err) {
//          $('body').html('client failed starting : ' + err)
//          throw err
//        }

//        $('#send').submit(function(event) {
//          event.preventDefault()
//          var address = $('#address').val()
//            , args = $('#args').val()
//          if (args.length)
//            args = args.split(' ').map(function(arg) { return JSON.parse(arg) })
//          else args = []
//          client.send(address, args)
//        })

//        // We want to receive all the messages, so we subscribe to '/'
//        client.send('/sys/subscribe', ['/message'])
//      })

//      client.on('message', function(address, args) { 
//        $('#received .message').slice(20).remove()
//        var message = $('<div class="message"><span class="ad"></span><span class="ar"></span></div>')
//          .prependTo('#received')
//        message.find('.ad').html(address)
//        message.find('.ar').html(args.map(function(arg) { return JSON.stringify(arg) }).join(' '))
//      })

//      client.on('connected', function() {
//        alert('connected!')
//      })

//      client.on('connection lost', function() {
//        alert('connection lost!')
//      })

//      client.on('server full', function() {
//        alert('server is full!')
//      })

//    })