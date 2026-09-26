// Function to receive messages from Flutter
    function receiveMessageFromFlutter(message) {
      document.getElementById('messageFromFlutter').innerText = message;
    }

    // Function to send a message to Flutter
    function sendMessageToFlutter() {
      var message = "Hello from the web!";
      messageHandler.postMessage(message);
    }